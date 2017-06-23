pragma solidity ^0.4.11;

import "SafeMath.sol";
import "GimliToken.sol";
import "Administrable.sol";

/// @title Gimli Crowdsale Contract.
/// @dev This contract manages streamer authorizations. To make a streamer able to create
/// a game (Bet, vote, etc.), the owner must authorize him with the function :
/// `authorizeStreamer()`. When a user plays (bet or vote), the game contract (GimliBetting, GimliVoting, ..),
/// calls the function `claimGMLPayment()`.
contract GimliStreamers is SafeMath, GimliToken, Administrable {

    struct Streamer {
        bool       authorized;
        mapping    (address => contractPermissions) permissions; // Contract permissions indexed by contract address
        bool       exists;
    }

    struct contractPermissions {
        uint256    streamerFeesPpm; // ppm, ex: 5 for 0.5%
        uint256    gimliFeesPpm; // ppm, ex: 5 for 0.5%
        uint256    maxPrice;
        bool       exists;
    }

    event StreamerAuthorized(address indexed streamerAddress, address indexed contractAddress, uint maxPrice);
    event StreamerRevoked(address indexed streamerAddress);

    /// Authorized streamers
    mapping (address => Streamer) authorizedStreamers;

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

        Streamer streamer = authorizedStreamers[_streamerAddress];
        contractPermissions permissions = streamer.permissions[_contractAddress];

        streamer.authorized = true;
        streamer.exists = true;
        permissions.streamerFeesPpm = _streamerFeesPpm;
        permissions.gimliFeesPpm = _gimliFeesPpm;
        permissions.maxPrice = _maxPrice;
        permissions.exists = true;

        StreamerAuthorized(_streamerAddress, _contractAddress, _maxPrice);
    }

    /// @notice Revoke a streamer for all contracts
    /// @param _streamerAddress Streamer address to revoke
    function revokeStreamer(address _streamerAddress) onlyAdministrator {
        authorizedStreamers[_streamerAddress].authorized = false;

        StreamerRevoked(_streamerAddress);
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
        require(authorizedStreamers[_streamerAddress].authorized);

        contractPermissions permissions = authorizedStreamers[_streamerAddress].permissions[msg.sender];

        // only authorized contract can claim payment
        require(permissions.maxPrice >= _price);

        // only _user can be the origin of this transaction
        require(tx.origin == _userAddress);

        // check user balance
        require(balances[_userAddress] >= _price);

        // Calculates fees
        uint256 gimliFees = safeDiv(safeMul(permissions.gimliFeesPpm, _price), 1000);
        uint256 streamerFees = safeDiv(safeMul(permissions.streamerFeesPpm, _price), 1000);

        // update balances
        balances[_userAddress] = safeSub(balances[_userAddress], _price);
        balances[owner] = safeAdd(balances[owner], gimliFees);
        balances[_streamerAddress] = safeAdd(balances[_streamerAddress], streamerFees);

        Transfer(_userAddress, owner, gimliFees);
        Transfer(_streamerAddress, owner, streamerFees);
    }

    /// @notice Get information about a contract authorized for a streamer
    /// @param _streamerAddress The streamer address
    /// @param _contractAddress The contract address
    /// @return Share of fees for streamer and Gimli, the maximum price authorized
    /// and a boolean to indicate if the permission exists.
    function getAllowedContract(address _streamerAddress, address _contractAddress)
        returns (uint256, uint256, uint256, bool) {
        contractPermissions a = authorizedStreamers[_streamerAddress].permissions[_contractAddress];
        return (a.streamerFeesPpm, a.gimliFeesPpm, a.maxPrice, a.exists);
    }

}
