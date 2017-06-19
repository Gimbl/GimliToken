import "GimliStreamers.sol";
import "GimliCrowdsale.sol";

pragma solidity ^0.4.11;


contract Gimli is GimliStreamers, GimliCrowdsale {

    function Gimli() {
        owner = msg.sender;
        updateBalance(msg.sender, TOTAL_SUPPLY - CROWDSALE_AMOUNT); // Give the creator initial tokens
    }

}
