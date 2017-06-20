pragma solidity ^0.4.11;

import "./SafeMath.sol";
import "./GimliToken.sol";
import "./Administrable.sol";

/// @title Gimli Crowdsale Contract.
/// @dev This contract manages streamer authorizations. To make a streamer able to create
/// a game (Bet, vote, etc.), the owner must authorize him with the function :
/// `authorizeStreamer()`. When a user plays (bet or vote), the game contract (GimliBetting, GimliVoting, ..),
/// calls the function `claimGMLPayment()`.
contract GimliStreamers is SafeMath, GimliToken, Administrable {

    struct Streamer {
        bool       authorized;
        mapping    (address => contractAllowance) allowances; // Contract allowances indexed by contract address
        address[]  allowedContracts; // List of allowed contracts
        bool       exists;
    }

    struct contractAllowance {
        uint256    streamerFeesPpm; // ppm, ex: 5 for 0.5%
        uint256    gimliFeesPpm; // ppm, ex: 5 for 0.5%
        uint256    maxPrice;
        bool       exists;
    }

    /// Authorized streamers
    mapping (address => Streamer) authorizedStreamerAllowances;
    address[] authorizedStreamers;

    /// @notice authorize an address to create Gimli game (bet, vote, etc.)
    /// @param _streamerAddress Authorized address
    /// @param _contractAddress Contract address (GimliBetting, GimliVoting, etc.)
    /// @param _streamerFeesPpm Share of fees for the streamer (ppm, ex: 5 for 0.5%)
    /// @param _gimliFeesPpm Share of fees for Gimli (ppm, ex: 5 for 0.5%)
    /// @param _maxPrice The maximum price a Streamer can claim to users for a game
    /// @dev `_streamerFeesPpm + _gimliFeesPpm` must be equal to 1000
    function authorizeStreamer(
        address _streamerAddress,
        address _contractAddress,
        uint256 _streamerFeesPpm,
        uint256 _gimliFeesPpm,
        uint256 _maxPrice) onlyAdministrator
    {
        // The whole GML payment must be shared
        require(safeAdd(_streamerFeesPpm, _gimliFeesPpm) == 1000);

        if (!authorizedStreamerAllowances[_streamerAddress].exists) {
             authorizedStreamers.push(_streamerAddress);
        }

        Streamer streamer = authorizedStreamerAllowances[_streamerAddress];
        contractAllowance allowance = streamer.allowances[_contractAddress];

        if (!allowance.exists) {
            streamer.allowedContracts.push(_contractAddress);
        }

        streamer.authorized = true;
        streamer.exists = true;
        allowance.streamerFeesPpm = _streamerFeesPpm;
        allowance.gimliFeesPpm = _gimliFeesPpm;
        allowance.maxPrice = _maxPrice;
        allowance.exists = true;
    }

    /// @notice Revoke a streamer for all contracts
    /// @param _streamerAddress Streamer address to revoke
    function revokeStreamer(address _streamerAddress) onlyAdministrator {
        authorizedStreamerAllowances[_streamerAddress].authorized = false;
    }

    /// @notice Called by a Gimli contract to claim game payment
    /// @param _streamerAddress Streamer address who created the game
    /// @param _userAddress User address who pays the game
    /// @param _price  Price paid by `_userAddress`
    /// @dev `msg.sender` and `_streamerAddress` must be authorized with the
    /// function `authorizeStreamer()`. `_userAddress` must be the origin of
    /// the transaction.
    function claimGMLPayment(address _streamerAddress, address _userAddress, uint256 _price) {

        // only authorized streamer can claim payment
        require(authorizedStreamerAllowances[_streamerAddress].authorized);

        contractAllowance allowance = authorizedStreamerAllowances[_streamerAddress].allowances[msg.sender];

        // only allowed contract can claim payment
        require(allowance.maxPrice >= _price);

        // only _user can be the origin of this transaction
        require(tx.origin == _userAddress);

        // check user balance
        require(balances[_userAddress] >= _price);

        // Calculates fees
        uint256 gimliFees = safeDiv(safeMul(allowance.gimliFeesPpm, _price), 1000);
        uint256 streamerFees = safeDiv(safeMul(allowance.streamerFeesPpm, _price), 1000);

        // update balances
        removeFromBalance(_userAddress, _price);
        addToBalance(owner, gimliFees);
        addToBalance(_streamerAddress, streamerFees);
    }

    /// @notice Get authorized streamers count
    /// @return Authorized streamers count
    function getAuthorizedStreamerCount() returns (uint256) {
        return authorizedStreamers.length;
    }

    /// @notice Return information about a streamer
    /// @param _streamerAddress The streamer address
    /// @return A boolean to indicate if the streamer is authorized and the
    /// number of contract allowed.
    /// @dev The number of contracts can be greater than zero even if the streamer
    /// is not anymore authorized.
    function getAuthorizedStreamer(address _streamerAddress) returns (bool, uint256) {
        return (authorizedStreamerAllowances[_streamerAddress].authorized,
                authorizedStreamerAllowances[_streamerAddress].allowedContracts.length);
    }

    /// @notice Return information about a streamer
    /// @param _streamerIndex The streamer address position in `authorizedStreamers`
    /// @return The streamer address, a boolean to indicate if the streamer is
    /// authorized and the number of contract allowed.
    /// @dev The number of contracts can be greater than zero even if the streamer
    /// is not anymore authorized.
    function getAuthorizedStreamerByIndex(uint256 _streamerIndex) returns (address, bool, uint256) {
        bool authorized;
        uint allowedCountractCount;
        (authorized, allowedCountractCount) = getAuthorizedStreamer(authorizedStreamers[_streamerIndex]);
        return (authorizedStreamers[_streamerIndex], authorized, allowedCountractCount);
    }

    /// @notice Get information about a contract allowed to a streamer
    /// @param _streamerAddress The streamer address
    /// @param _contractAddress The contract address
    /// @return Share of fees for streamer and Gimli, the maximum price allowed
    /// and a boolean to indicate if the allowance exists.
    function getAllowedContract(address _streamerAddress, address _contractAddress)
        returns (uint256, uint256, uint256, bool) {
        contractAllowance a = authorizedStreamerAllowances[_streamerAddress].allowances[_contractAddress];
        return (a.streamerFeesPpm, a.gimliFeesPpm, a.maxPrice, a.exists);
    }

    /// @notice Get information about a contract allowed to a streamer
    /// @param _streamerAddress The streamer address
    /// @param _contractIndex The contract address position in `authorizedStreamerAllowances[_streamerAddress].allowedContracts`
    /// @return Share of fees for streamer and Gimli, the maximum price allowed
    /// and a boolean to indicate if the allowance exists.
    function getAllowedContracByIndex(address _streamerAddress, uint256 _contractIndex)
        returns (uint256, uint256, uint256, bool) {
        return getAllowedContract(_streamerAddress, authorizedStreamerAllowances[_streamerAddress].allowedContracts[_contractIndex]);
    }
}
