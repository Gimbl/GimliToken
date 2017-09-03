pragma solidity ^0.4.11;

import "GimliStreamers.sol";
import "GimliCrowdsale.sol";

/// @title Main Gimli contract.
contract Gimli is GimliStreamers, GimliCrowdsale {

    /// @notice Gimli Contract constructor. `msg.sender` is the owner.
    function Gimli() {
        // MULTISIG_WALLET_ADDRESS becomes the owner
        owner = MULTISIG_WALLET_ADDRESS;
        // Give the creator initial tokens
        balances[owner] = safeAdd(balances[owner], TOTAL_SUPPLY - CROWDSALE_AMOUNT - VESTING_1_AMOUNT - VESTING_2_AMOUNT);
        // Give the contract crowdsale amount
        balances[this] = CROWDSALE_AMOUNT;
        // Locked address
        balances[LOCKED_ADDRESS] = VESTING_1_AMOUNT + VESTING_2_AMOUNT;
        // For ERC20 compatibility
        totalSupply = TOTAL_SUPPLY;
    }

}
