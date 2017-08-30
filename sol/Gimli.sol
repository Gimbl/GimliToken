pragma solidity ^0.4.11;

import "GimliStreamers.sol";
import "GimliCrowdsale.sol";

/// @title Main Gimli contract.
contract Gimli is GimliStreamers, GimliCrowdsale {

    /// @notice Gimli Contract constructor. `msg.sender` is the owner.
    function Gimli() {
        // `msg.sender` becomes the owner
        owner = msg.sender;
        // Give the creator initial tokens
        balances[msg.sender] = safeAdd(balances[msg.sender], TOTAL_SUPPLY - CROWDSALE_AMOUNT - VESTING_1_AMOUNT - VESTING_2_AMOUNT);
        // Give the contract crowdsale amount
        balances[this] = CROWDSALE_AMOUNT;
        // For ERC20 compatibility
        totalSupply = TOTAL_SUPPLY;
    }

}
