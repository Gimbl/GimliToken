pragma solidity ^0.4.11;

import "Ownable.sol";

contract Administrable is Ownable {
  mapping (address => bool) public administrators;

  modifier onlyAdministrator() {
    require(administrators[msg.sender] || owner == msg.sender); // owner is an admin by default
    _;
  }

  function addAdministrators(address _adminAddess) onlyOwner {
    administrators[_adminAddess] = true;
  }

  function removeAdministrators(address _adminAddess) onlyOwner {
    administrators[_adminAddess] = false;
  }
}
