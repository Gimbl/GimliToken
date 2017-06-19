import 'SafeMath.sol';
import "GimliToken.sol";

pragma solidity ^0.4.11;

contract GimliICO is SafeMath, GimliToken {

    uint256 public constant ICO_AMOUNT = 100 * MILLION_GML;
    uint256 public constant ICO_START_BLOCK = 0; // TODO
    uint256 public constant ICO_END_BLOCK = 10**10; // TODO
    uint256 public constant ICO_PRICE = 10**15 / DECIMALS; // 0.001 ETH / GML

    uint256 public ICOGMLSold = 0;
    bool public ICOClosed = false;

    /// @notice `msg.sender` invest msg.value
    function() payable {
        // check date
        require(block.number >= ICO_START_BLOCK && block.number <= ICO_END_BLOCK);

        // calculate and check quantity
        uint256 quantity = safeDiv(msg.value, ICO_PRICE);
        require(safeAdd(ICOGMLSold, quantity) <= ICO_AMOUNT);

        // update balances
        ICOGMLSold += quantity;
        updateBalance(msg.sender, quantity);
    }

    /// @notice returns non-sold tokens to owner
    function closeICO() onlyOwner {
        // check date
        require(block.number > ICO_END_BLOCK);

        // owner can close the ICO only once
        require(!ICOClosed);
        ICOClosed = true;

        // update balances
        updateBalance(msg.sender, ICO_AMOUNT - ICOGMLSold);
    }

    function getICO() returns (uint256, uint256, uint256, uint256, uint256, uint256, bool) {
        return (totalSupply, ICO_AMOUNT, ICO_START_BLOCK, ICO_END_BLOCK, ICOGMLSold, ICO_PRICE, ICOClosed);
    }

    function withdrawalETH(address _to) onlyOwner {
        _to.transfer(this.balance);
    }
}
