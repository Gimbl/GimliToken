import "GimliStreamers.sol";
import "GimliICO.sol";

pragma solidity ^0.4.11;


contract Gimli is GimliStreamers, GimliICO {

    function Gimli() {
        owner = msg.sender;
        updateBalance(msg.sender, TOTAL_SUPPLY - ICO_AMOUNT); // Give the creator initial tokens
    }

}
