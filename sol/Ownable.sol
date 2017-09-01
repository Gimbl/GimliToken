pragma solidity ^0.4.11;

/// @title Base contract with an owner.
/// @dev Provides onlyOwner modifier, which prevents function from running if
/// it is called by anyone other than the owner.
contract Ownable {
    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    /// @notice Transfer ownership from `owner` to `newOwner`
    /// @param newOwner The new contract owner
    function transferOwnership(address newOwner) onlyOwner {
        if (newOwner != address(0)) {
            owner = newOwner;
        }
    }

}
