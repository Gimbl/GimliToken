import "SafeMath.sol";
import "GimliToken.sol";

pragma solidity ^0.4.11;

contract GimliStreamers is SafeMath, GimliToken {

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

    /// @notice authorize an address to proceed fees payment
    function authorizeStreamer(
        address _streamerAddress,
        address _contractAddress,
        uint256 _streamerFeesPpm,
        uint256 _gimliFeesPpm,
        uint256 _maxPrice) onlyOwner
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

    // Revoke a streamer
    function revokeStreamer(address _streamerAddress) onlyOwner {
        authorizedStreamerAllowances[_streamerAddress].authorized = false;
    }

    /// @notice fees payment called by Gimli contracts
    function claimGMLPayment(address _streamerAddress, address _userAddress, uint256 price) {

        // only authorized streamer can claim payment
        require(authorizedStreamerAllowances[_streamerAddress].authorized);

        contractAllowance allowance = authorizedStreamerAllowances[_streamerAddress].allowances[msg.sender];

        // only allowed contract can claim payment
        require(allowance.maxPrice >= price);

        // only _user can be the origin of this transaction
        require(tx.origin == _userAddress);

        // check user balance
        require(balances[_userAddress] >= price);

        // Calculates fees
        uint256 gimliFees = safeDiv(safeMul(allowance.gimliFeesPpm, price), 1000);
        uint256 streamerFees = safeDiv(safeMul(allowance.streamerFeesPpm, price), 1000);

        // update balances
        updateBalance(_userAddress, -price);
        updateBalance(owner, gimliFees);
        updateBalance(_streamerAddress, streamerFees);
    }

     /// @return authorized contract count
    function getAuthorizedStreamerCount() returns (uint256) {
        return authorizedStreamers.length;
    }

    /// @param _streamerAddress The streamer address
    /// @return authorized streamer
    function getAuthorizedStreamer(address _streamerAddress) returns (bool, uint256) {
        return (authorizedStreamerAllowances[_streamerAddress].authorized,
                authorizedStreamerAllowances[_streamerAddress].allowedContracts.length);
    }

    /// @param _streamerIndex The contract index
    /// @return authorized streamer
    function getAuthorizedStreamerByIndex(uint256 _streamerIndex) returns (address, bool, uint256) {
        bool authorized;
        uint allowedCountractCount;
        (authorized, allowedCountractCount) = getAuthorizedStreamer(authorizedStreamers[_streamerIndex]);
        return (authorizedStreamers[_streamerIndex], authorized, allowedCountractCount);
    }

    /// @param _streamerAddress The streamer address
    /// @param _contractAddress The contract address
    /// @return authorized fees and max price allowed
    function getAllowedContract(address _streamerAddress, address _contractAddress)
        returns (uint256, uint256, uint256, bool) {
        contractAllowance a = authorizedStreamerAllowances[_streamerAddress].allowances[_contractAddress];
        return (a.streamerFeesPpm, a.gimliFeesPpm, a.maxPrice, a.exists);
    }

    /// @param _streamerAddress The streamer address
    /// @param _contractIndex The contract index
    /// @return authorized fees and max price allowed
    function getAllowedContracByIndex(address _streamerAddress, uint256 _contractIndex)
        returns (uint256, uint256, uint256, bool) {
        return getAllowedContract(_streamerAddress, authorizedStreamerAllowances[_streamerAddress].allowedContracts[_contractIndex]);
    }
}
