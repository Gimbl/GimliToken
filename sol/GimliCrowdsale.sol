pragma solidity ^0.4.11;

import 'SafeMath.sol';
import "GimliToken.sol";

/// @title Gimli Crowdsale Contract.
contract GimliCrowdsale is SafeMath, GimliToken {

    uint256 public constant CROWDSALE_AMOUNT = 100 * MILLION_GML;
    uint256 public constant CROWDSALE_START_BLOCK = 0; // TODO
    uint256 public constant CROWDSALE_END_BLOCK = 10**10; // TODO
    uint256 public constant CROWDSALE_PRICE = 10**15 / UNIT; // 0.001 ETH / GML

    /// @notice `msg.sender` invest `msg.value`
    function() payable {
        require(msg.value > 0);
        // check date
        require(block.number >= CROWDSALE_START_BLOCK && block.number <= CROWDSALE_END_BLOCK);

        // calculate and check quantity
        uint256 quantity = safeDiv(msg.value, CROWDSALE_PRICE);
        require(safeSub(balances[this], quantity) >= 0);

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
}
