import "SafeMath.sol";
import "ERC20.sol";
import "Ownable.sol";

pragma solidity ^0.4.11;

/// @title Gimli Token Contract.
contract GimliToken is ERC20, SafeMath, Ownable {


    /*************************
    **** Global variables ****
    *************************/

    /// total amount of tokens
    uint256 public constant TOTAL_SUPPLY = 150 * MILLION_GML; // can't use `safeMul` with constant
    string public constant NAME = "Gimli Token";
    uint8 public constant DECIMALS = 8;
    string public constant SYMBOL = "GML";
    string public constant VERSION = 'v1';
    uint constant MILLION_GML = 10**6 * DECIMALS; // can't use `safeMul` with constant

    /// balances indexed by address
    mapping (address => uint256) balances;
    // holder position in `holders` indexed by address
    mapping (address => uint256) holderIDs;
    // list of holders
    address[] holders;
    uint256 holderCount; // because holders.length doesn't change after a delete

    /// allowances indexed by owner and spender
    mapping (address => mapping (address => uint256)) allowed;


    /***************
    **** Events ****
    ***************/

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);


    /*********************
    **** Transactions ****
    *********************/


    /// @notice send `_value` token to `_to` from `msg.sender`
    /// @param _to The address of the recipient
    /// @param _value The amount of token to be transferred
    /// @return Whether the transfer was successful or not
    function transfer(address _to, uint256 _value) {
        require(balances[msg.sender] >= _value && _value > 0);

        removeFromBalance(msg.sender, _value);
        addToBalance(_to, _value);
        Transfer(msg.sender, _to, _value);
    }

    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
    /// @param _from The address of the sender
    /// @param _to The address of the recipient
    /// @param _value The amount of token to be transferred
    /// @return Whether the transfer was successful or not
    function transferFrom(address _from, address _to, uint256 _value) {
        require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0);

        removeFromBalance(_from, _value);
        addToBalance(_to, _value);
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

    function addToBalance(address _holder, uint256 delta) internal {
        balances[_holder] = safeAdd(balances[_holder], delta);
        updateHolders(_holder);
    }

    function removeFromBalance(address _holder, uint256 delta) internal {
        balances[_holder] = safeSub(balances[_holder], delta);
        updateHolders(_holder);
    }

    // maintains `holders` array for `getBalanceByIndex()` function
    function updateHolders(address _holder) internal {
        assert(balances[_holder] >= 0);

        // New holder
        if (holderIDs[_holder] == 0 && balances[_holder] > 0) {
            holders.push(_holder);
            holderCount = safeAdd(holderCount, 1);
            holderIDs[_holder] = holderCount; // Start from 1 to not confuse with default value
        }

        // Clean zero balances
        if (balances[_holder] == 0) {
            var holderID = holderIDs[_holder];
            // Decremente holder count
            holderCount = safeSub(holderCount, 1);
            // Move last holder to the deleted position
            holders[holderID] = holders[holderCount];
            // Update ID of the moved holder
            holderIDs[holders[holderCount]] = holderID;
            // Delete last holder
            delete holders[holderCount];
        }
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

    /// @notice Get holder count
    /// @return holder count
    function getHolderCount() returns (uint256) {
        return holderCount;
    }

    /// @notice Get balance by index
    /// @param _holderIndex The holder index
    /// @return The address of the holder and his balance
    function getBalanceByIndex(uint256 _holderIndex) returns (address, uint256) {
        return (holders[_holderIndex], balanceOf(holders[_holderIndex]));
    }

}
