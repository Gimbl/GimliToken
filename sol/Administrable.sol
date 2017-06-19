pragma solidity ^0.4.11;

import "Ownable.sol";

/// @title Manages Gimli administrators.
contract Administrable is Ownable {
  mapping (address => bool) public administrators;

  modifier onlyAdministrator() {
    require(administrators[msg.sender] || owner == msg.sender); // owner is an admin by default
    _;
  }

  /// @notice Add an administrator
  /// @param _adminAddess The new administrator address
  function addAdministrators(address _adminAddess) onlyOwner {
    administrators[_adminAddess] = true;
  }

  /// @notice Remove an administrator
  /// @param _adminAddess The administrator address to remove
  function removeAdministrators(address _adminAddess) onlyOwner {
    administrators[_adminAddess] = false;
  }
}
