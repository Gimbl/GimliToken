pragma solidity ^0.4.11;

import "Administrable.sol";
import "GimliCrowdsale.sol";

/// @title Main Gimli contract.
contract Gimli is GimliCrowdsale, Administrable {

    address public streamerContract;
    uint256 public streamerContractMaxAmount;

    event StreamerContractChanged(address newContractAddress, uint256 newMaxAmount);

    /// @notice Gimli Contract constructor. `msg.sender` is the owner.
    function Gimli() {
        // Give the multisig wallet initial tokens
        balances[MULTISIG_WALLET_ADDRESS] = safeAdd(balances[owner], TOTAL_SUPPLY - CROWDSALE_AMOUNT - VESTING_1_AMOUNT - VESTING_2_AMOUNT);
        // Give the contract crowdsale amount
        balances[this] = CROWDSALE_AMOUNT;
        // Locked address
        balances[LOCKED_ADDRESS] = VESTING_1_AMOUNT + VESTING_2_AMOUNT;
        // For ERC20 compatibility
        totalSupply = TOTAL_SUPPLY;
    }

    /// @notice authorize an address to transfer GIM on behalf an user
    /// @param _contractAddress Address of GimliStreamer contract
    /// @param _maxAmount The maximum amount that can be transfered by the contract
    function setStreamerContract(
        address _contractAddress,
        uint256 _maxAmount) onlyAdministrator
    {
        // To change the maximum amount you first have to reduce it to 0`
        require(_maxAmount == 0 || streamerContractMaxAmount == 0);

        streamerContract = _contractAddress;
        streamerContractMaxAmount = _maxAmount;

        StreamerContractChanged(streamerContract, streamerContractMaxAmount);
    }

    /// @notice Called by a Gimli contract to transfer GIM
    /// @param _from The address of the sender
    /// @param _to The address of the recipient
    /// @param _amount The amount of token to be transferred
    /// @return Whether the transfer was successful or not
    function transferGIM(address _from, address _to, uint256 _amount) returns (bool success) {
        require(msg.sender == streamerContract);
        require(tx.origin == _from);
        require(_amount <= streamerContractMaxAmount);

        if (balances[_from] < _amount || _amount <= 0)
            return false;

        balances[_from] = safeSub(balances[_from], _amount);
        balances[_to] = safeAdd(balances[_to], _amount);

        Transfer(_from, _to, _amount);

        return true;
    }



}
