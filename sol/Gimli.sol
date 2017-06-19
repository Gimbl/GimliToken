import "GimliStreamers.sol";
import "GimliCrowdsale.sol";

pragma solidity ^0.4.11;

/// @title Main Gimli contract.
contract Gimli is GimliStreamers, GimliCrowdsale {

    /// @notice Gimli Contract constructor. `msg.sender` is the owner.
    function Gimli() {
        // `msg.sender` becomes the owner
        owner = msg.sender;
        // Give the creator initial tokens
        addToBalance(msg.sender, TOTAL_SUPPLY - CROWDSALE_AMOUNT);
        // For ERC20 compatibility
        totalSupply = TOTAL_SUPPLY;
    }

}
