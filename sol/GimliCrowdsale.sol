pragma solidity ^0.4.11;

import 'SafeMath.sol';
import "GimliToken.sol";

/// @title Gimli Crowdsale Contract.
contract GimliCrowdsale is SafeMath, GimliToken {

    uint256 public constant CROWDSALE_AMOUNT = 100 * MILLION_GML;
    uint256 public constant CROWDSALE_START_BLOCK = 0; // TODO
    uint256 public constant CROWDSALE_END_BLOCK = 10**10; // TODO
    uint256 public constant CROWDSALE_PRICE = 10**15 / DECIMALS; // 0.001 ETH / GML

    uint256 public GMLSold = 0;
    bool public crowdsaleClosed = false;

    /// @notice `msg.sender` invest `msg.value`
    function() payable {
        require(msg.value > 0);
        // check date
        require(block.number >= CROWDSALE_START_BLOCK && block.number <= CROWDSALE_END_BLOCK);

        // calculate and check quantity
        uint256 quantity = safeDiv(msg.value, CROWDSALE_PRICE);
        require(safeAdd(GMLSold, quantity) <= CROWDSALE_AMOUNT);

        // update balances
        GMLSold += quantity;
        addToBalance(msg.sender, quantity);
    }

    /// @notice returns non-sold tokens to owner
    function closeCrowdsale() onlyOwner {
        // check date
        require(block.number > CROWDSALE_END_BLOCK);

        // owner can close the ICO only once
        require(!crowdsaleClosed);
        crowdsaleClosed = true;

        // update balances
        addToBalance(owner, CROWDSALE_AMOUNT - GMLSold);
    }

    /// @notice Send GML payments  to `_to`
    /// @param _to The withdrawal destination
    function withdrawalCrowdsale(address _to) onlyOwner {
        _to.transfer(this.balance);
    }
}
