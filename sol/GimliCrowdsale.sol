pragma solidity ^0.4.11;

import 'SafeMath.sol';
import "GimliToken.sol";

/// @title Gimli Crowdsale Contract.
contract GimliCrowdsale is SafeMath, GimliToken {

    /// @notice `msg.sender` invest `msg.value`
    function() payable {
        require(msg.value > 0);
        // check date
        require(block.number >= CROWDSALE_START_BLOCK && block.number <= CROWDSALE_END_BLOCK);

        // calculate and check quantity
        uint256 quantity = safeDiv(msg.value, CROWDSALE_PRICE);
        if (safeSub(balances[this], quantity) < 0)
            return;

        // update balances
        balances[this] = safeSub(balances[this], quantity);
        balances[msg.sender] = safeAdd(balances[msg.sender], quantity);

        Transfer(this, msg.sender, quantity);
    }

    /// @notice returns non-sold tokens to owner
    function closeCrowdsale() onlyOwner {
        // check date
        require(block.number > CROWDSALE_END_BLOCK);

        // update balances
        uint256 unsoldQuantity = balances[this];
        balances[owner] = safeAdd(balances[owner], unsoldQuantity);
        balances[this] = 0;

        Transfer(this, owner, unsoldQuantity);
    }

    /// @notice Send GML payments  to `_to`
    /// @param _to The withdrawal destination
    function withdrawalCrowdsale(address _to) onlyOwner {
        _to.transfer(this.balance);
    }

    /// @notice Pre-allocate tokens to advisor or partner
    /// @param _to The pre-allocation destination
    /// @param _value The amount of token to be allocated
    function preAllocate(address _to, uint256 _value) onlyOwner {
        require(block.number < CROWDSALE_START_BLOCK);

        balances[_to] = safeAdd(balances[_to], _value);
        balances[this] = safeSub(balances[this], _value);
        preAllocatedAmount = safeAdd(preAllocatedAmount, _value);
    }
}
