pragma solidity ^0.4.11;

import "SafeMath.sol";
import "ERC20.sol";
import "Ownable.sol";

/// @title Gimli Token Contract.
contract GimliToken is ERC20, SafeMath, Ownable {


    /*************************
    **** Global variables ****
    *************************/
    address public constant MULTISIG_WALLET_ADDRESS = 0xcac029186c773dbfc18402f464a3818e46541fba; // TODO

    // crowdsale
    uint256 public constant CROWDSALE_AMOUNT = 80 * MILLION_GML; // Should not include vested amount
    uint256 public constant CROWDSALE_START_BLOCK = 4278234; // Around 11AM GMT on 9/16/17
    uint256 public constant CROWDSALE_END_BLOCK = 4328345; // Around 11PM GMT on 9/30/17
    uint256 public constant CROWDSALE_PRICE = 700; // 700 GML / ETH
    uint256 public constant VESTING_1_AMOUNT = 15 * MILLION_GML; // TODO
    uint256 public constant VESTING_1_BLOCK = 5539673; // Around start + 1 year
    uint256 public constant VESTING_2_AMOUNT = 15 * MILLION_GML; // TODO
    uint256 public constant VESTING_2_BLOCK = 6801113; // Around start + 2 years
    bool public vesting1Withdrawn = false;
    bool public vesting2Withdrawn = false;
    bool public crowdsaleCanceled = false;
    uint256 public soldAmount;

    uint8 public constant decimals = 8;
    string public constant name = "Gimli Token";
    string public constant symbol = "GIM";
    string public constant versoin = 'v1';

    /// total amount of tokens
    uint256 public constant UNIT = 10**decimals;
    uint256 constant MILLION_GML = 10**6 * UNIT; // can't use `safeMul` with constant
    /// Should include CROWDSALE_AMOUNT and VESTING_X_AMOUNT
    uint256 public constant TOTAL_SUPPLY = 150 * MILLION_GML; // can't use `safeMul` with constant;

    /// balances indexed by address
    mapping (address => uint256) balances;

    /// allowances indexed by owner and spender
    mapping (address => mapping (address => uint256)) allowed;

    /*********************
    **** Transactions ****
    *********************/


    /// @notice send `_value` token to `_to` from `msg.sender`
    /// @param _to The address of the recipient
    /// @param _value The amount of token to be transferred
    /// @return Whether the transfer was successful or not
    function transfer(address _to, uint256 _value) returns (bool success) {
        require(block.number > CROWDSALE_END_BLOCK);

        if (balances[msg.sender] < _value || _value <= 0)
            return false;

        balances[msg.sender] = safeSub(balances[msg.sender], _value);
        balances[_to] = safeAdd(balances[_to], _value);
        Transfer(msg.sender, _to, _value);

        return true;
    }

    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
    /// @param _from The address of the sender
    /// @param _to The address of the recipient
    /// @param _value The amount of token to be transferred
    /// @return Whether the transfer was successful or not
    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
        require(block.number > CROWDSALE_END_BLOCK);

        if (balances[_from] < _value || allowed[_from][msg.sender] < _value || _value <= 0)
            return false;

        balances[_from] = safeSub(balances[_from], _value);
        balances[_to] = safeAdd(balances[_to], _value);
        allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);
        Transfer(_from, _to, _value);

        return true;
    }

    /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
    /// @param _spender The address of the account able to transfer the tokens
    /// @param _value The amount of tokens to be approved for transfer
    /// @return Whether the approval was successful or not
    function approve(address _spender, uint256 _value) returns (bool success) {
        // To change the approve amount you first have to reduce the addresses`
        //  allowance to zero by calling `approve(_spender, 0)` if it is not
        //  already 0 to mitigate the race condition described here:
        //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
        require((_value == 0) || (allowed[msg.sender][_spender] == 0));

        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }

    /****************
    **** Getters ****
    ****************/

    /// @notice Get balance of an address
    /// @param _owner The address from which the balance will be retrieved
    /// @return The balance
    function balanceOf(address _owner) constant returns (uint256 balance) {
        return balances[_owner];
    }

    /// @notice Get tokens allowed to spent by `_spender`
    /// @param _owner The address of the account owning tokens
    /// @param _spender The address of the account able to transfer the tokens
    /// @return Amount of remaining tokens allowed to spent
    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }

}
