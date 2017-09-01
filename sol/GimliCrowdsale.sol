pragma solidity ^0.4.11;

import 'SafeMath.sol';
import "GimliToken.sol";

/// @title Gimli Crowdsale Contract.
contract GimliCrowdsale is SafeMath, GimliToken {

    /// @notice `msg.sender` invest `msg.value`
    function() payable {
        require(!crowdsaleCanceled);

        require(msg.value > 0);
        // check date
        require(block.number >= CROWDSALE_START_BLOCK && block.number <= CROWDSALE_END_BLOCK);

        // calculate and check quantity
        uint256 quantity = safeMul(msg.value, CROWDSALE_PRICE);
        if (safeSub(balances[this], quantity) < 0)
            return;

        require(MULTISIG_WALLET_ADDRESS.send(msg.value));

        // update balances
        balances[this] = safeSub(balances[this], quantity);
        balances[msg.sender] = safeAdd(balances[msg.sender], quantity);
        soldAmount = safeAdd(soldAmount, quantity);

        Transfer(this, msg.sender, quantity);
    }

    /// @notice returns non-sold tokens to owner
    function  transferAnyERC20Token() onlyOwner {
        // check date
        require(block.number > CROWDSALE_END_BLOCK || crowdsaleCanceled);

        // update balances
        uint256 amount = balances[this];
        balances[owner] = safeAdd(balances[owner], amount);
        balances[this] = 0;

        Transfer(this, owner, amount);
    }

    function cancelCrowdsale() onlyOwner {
        crowdsaleCanceled = true;
    }

    /// @notice Pre-allocate tokens to advisor or partner
    /// @param _to The pre-allocation destination
    /// @param _value The amount of token to be allocated
    function preAllocate(address _to, uint256 _value) onlyOwner {
        require(block.number < CROWDSALE_START_BLOCK);

        balances[_to] = safeAdd(balances[_to], _value);
        balances[this] = safeSub(balances[this], _value);
        soldAmount = safeAdd(soldAmount, _value);
    }

    /// @notice Send vested amount to _destination
    /// @param _destination The address of the recipient
    /// @return Whether the release was successful or not
    function releaseVesting(address _destination) onlyOwner returns (bool success) {
        if (block.number > VESTING_1_BLOCK && vesting1Withdrawn == false) {
            balances[_destination] = safeAdd(balances[_destination], VESTING_1_AMOUNT);
            vesting1Withdrawn = true;
        }
        if (block.number > VESTING_2_BLOCK && vesting2Withdrawn == false) {
            balances[_destination] = safeAdd(balances[_destination], VESTING_2_AMOUNT);
            vesting2Withdrawn = true;
        }
    }
}
