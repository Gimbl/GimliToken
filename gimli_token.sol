pragma solidity ^0.4.11;


/*
Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
.*/
contract GimliToken {

    /*************************
    **** Global variables ****
    *************************/

    string public constant NAME = "Gimli Token";
    uint8 public constant DECIMALS = 8;
    string public constant SYMBOL = "GML";
    string public constant VERSION = 'v1';

    address owner;

    /// balances indexed by address
    mapping (address => uint256) balances;
    address[] holders;

    /// allowances indexed by owner and spender
    mapping (address => mapping (address => uint256)) allowed;

    /// total amount of tokens
    uint256 public totalSupply = 150 * 10**6 * 10**8; // 150M, 8 decimals

    /// ICO
    uint256 ICOAmount = 100 * 10**6 * 10**8; // 100M, 8 decimals
    uint256 ICOStartBlock = 0; // TODO
    uint256 ICOEndBlock = 10**10; // TODO
    uint256 ICOGMLSold = 0;
    uint256 ICOPrice = 1 finney / 10**8; // 0.001 ETH
    bool ICOClosed = false;

    /// Maximum GML fees by authorized contract
    mapping (address => uint256) authorizedContractsAllowance;
    address[] authorizedContracts;


    /***************
    **** Events ****
    ***************/

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);


    /*********************
    **** Transactions ****
    *********************/

    function GimliToken() {
        owner = msg.sender;
        balances[msg.sender] = totalSupply - ICOAmount; // Give the creator initial tokens
    }

    /// @notice `msg.sender` invest msg.value
    function() payable {
        // check date
        require(block.number >= ICOStartBlock && block.number <= ICOEndBlock);

        // calculate and check quantity
        uint256 quantity = msg.value / ICOPrice;
        require(ICOGMLSold + quantity <= ICOAmount);

        // update balances
        ICOGMLSold += quantity;
        balances[msg.sender] += quantity;
    }

    /// @notice send `_value` token to `_to` from `msg.sender`
    /// @param _to The address of the recipient
    /// @param _value The amount of token to be transferred
    /// @return Whether the transfer was successful or not
    function transfer(address _to, uint256 _value) {
        require(balances[msg.sender] >= _value && _value > 0);

        balances[msg.sender] -= _value;
        balances[_to] += _value;
        Transfer(msg.sender, _to, _value);
    }

    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
    /// @param _from The address of the sender
    /// @param _to The address of the recipient
    /// @param _value The amount of token to be transferred
    /// @return Whether the transfer was successful or not
    function transferFrom(address _from, address _to, uint256 _value) {
        require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0);

        balances[_to] += _value;
        balances[_from] -= _value;
        allowed[_from][msg.sender] -= _value;
        Transfer(_from, _to, _value);
    }

    /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
    /// @param _spender The address of the account able to transfer the tokens
    /// @param _value The amount of tokens to be approved for transfer
    /// @return Whether the approval was successful or not
    function approve(address _spender, uint256 _value) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
    }

    /// @notice returns non-sold tokens to owner
    function closeICO() {
        // only owner can close the ICO
        require(msg.sender == owner);

        // check date
        require(block.number > ICOEndBlock);

        // owner can close the ICO only once
        require(!ICOClosed);
        ICOClosed = true;

        // update balances
        balances[msg.sender] += ICOAmount - ICOGMLSold;
    }

    /// @notice authorize an address to proceed fees payment
    function authorizeContract(address _contractAddress, uint256 maxFees) {
        // only owner can set authorize an address
        require(msg.sender == owner);

        authorizedContractsAllowance[_contractAddress] = maxFees;
        authorizedContracts.push(_contractAddress);
    }

    /// @notice fees payment called by Gimli contracts
    function payFeesFor(address _user, uint256 fees) {
        // only allowed contract can pay fees
        require(authorizedContractsAllowance[msg.sender] >= fees);

        // only _user can be the origin of this transaction
        require(tx.origin == _user);

        // check balance
        require(balances[_user] >= fees);

        // update balances
        balances[_user] -= fees;
        balances[owner] += fees;
    }

    function withdrawalETH(address _to) {
        // only owner can withdrawal
        require(msg.sender == owner);

        _to.transfer(this.balance);
    }

    /****************
    **** Getters ****
    ****************/

    /// @param _owner The address from which the balance will be retrieved
    /// @return The balance
    function balanceOf(address _owner) constant returns (uint256 balance) {
        return balances[_owner];
    }

    /// @param _owner The address of the account owning tokens
    /// @param _spender The address of the account able to transfer the tokens
    /// @return Amount of remaining tokens allowed to spent
    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
      return allowed[_owner][_spender];
    }

    /// @return holder count
    function getHolderCount() returns (uint256) {
        return holders.length;
    }

    /// @param _holderIndex The holder index
    /// @return balance by holder index
    function getBalanceByIndex(uint256 _holderIndex) returns (uint256) {
        return balances[holders[_holderIndex]];
    }

    /// @return authorized contract count
    function getAuthorizedContractCount() returns (uint256) {
        return authorizedContracts.length;
    }

    /// @param _contractAddress The contract address
    /// @return get contract allowance
    function getContractAllowance(address _contractAddress) returns (uint256) {
        return authorizedContractsAllowance[_contractAddress];
    }

    /// @param _contractIndex The contract index
    /// @return get contract allowance
    function getContractAllowanceByIndex(uint256 _contractIndex) returns (uint256) {
        return authorizedContractsAllowance[authorizedContracts[_contractIndex]];
    }

}
