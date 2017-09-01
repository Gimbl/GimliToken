# Main Gimli contract.

### `addAdministrators(address)`

Add an administrator

**Parameters:**

  - `_adminAddress`: The new administrator address

### `allowance(address,address)`

Get tokens allowed to spent by `_spender`

**Parameters:**

  - `_owner`: The address of the account owning tokens
  - `_spender`: The address of the account able to transfer the tokens

**Returns:**

Amount of remaining tokens allowed to spent

### `approve(address,uint256)`

`msg.sender` approves `_spender` to spend `_value` tokens

**Parameters:**

  - `_spender`: The address of the account able to transfer the tokens
  - `_value`: The amount of tokens to be approved for transfer

**Returns:**

Whether the approval was successful or not

### `authorizeStreamer(address,address,uint256,uint256,uint256)`

authorize an address to create Gimli game (bet, vote, etc.)

`_streamerFeesPpm + _gimliFeesPpm` must be equal to 1000

**Parameters:**

  - `_contractAddress`: Contract address (GimliBetting, GimliVoting, etc.)
  - `_streamerFeesPpm`: Share of fees for the streamer (ppm, ex: 5 for 0.5%)
  - `_gimliFeesPpm`: Share of fees for Gimli (ppm, ex: 5 for 0.5%)
  - `_maxAmount`: The maximum fee or escrow a Streamer can claim to users for a game
  - `_streamerAddress`: Authorized address

### `balanceOf(address)`

Get balance of an address

**Parameters:**

  - `_owner`: The address from which the balance will be retrieved

**Returns:**

The balance

### `claimGMLFees(address,address,uint256)`

Called by a Gimli contract to claim game payment

`msg.sender` and `_streamerAddress` must be authorized with the function `authorizeStreamer()`. `_userAddress` must be the origin of the transaction.

**Parameters:**

  - `_amount`: Price paid by `_userAddress`
  - `_userAddress`: User address who pays the game
  - `_streamerAddress`: Streamer address who created the game

### `escrowGML(address,address,uint256)`

Called by a Gimli contract to put GML in escrow, for instance by GimliBetting when a stake is placed by _userAddress. To unescrow the funds the contract must use the function `transfer`.

`msg.sender` and `_streamerAddress` must be authorized with the function `authorizeStreamer()`. `_userAddress` must be the origin of the transaction.

**Parameters:**

  - `_amount`: Amount put in escrow
  - `_userAddress`: User address who pays the game
  - `_streamerAddress`: Streamer address who created the game

### `getContractPermissions(address,address)`

Get information about a contract authorized for a streamer

**Parameters:**

  - `_contractAddress`: The contract address
  - `_streamerAddress`: The streamer address

**Returns:**

Share of fees for streamer and Gimli, the maximum price authorized and a boolean to indicate if the permission exists.

### `isAuthorizedStreamer(address)`

Checks if a streamer is authorized

**Parameters:**

  - `_streamerAddress`: The streamer address

**Returns:**

A boolean

### `preAllocate(address,uint256)`

Pre-allocate tokens to advisor or partner

**Parameters:**

  - `_to`: The pre-allocation destination
  - `_value`: The amount of token to be allocated

### `releaseVesting(address)`

Send vested amount to _destination

**Parameters:**

  - `_destination`: The address of the recipient

**Returns:**

Whether the release was successful or not

### `removeAdministrators(address)`

Remove an administrator

**Parameters:**

  - `_adminAddress`: The administrator address to remove

### `revokeStreamer(address)`

Revoke a streamer for all contracts

**Parameters:**

  - `_streamerAddress`: Streamer address to revoke

### `transfer(address,uint256)`

send `_value` token to `_to` from `msg.sender`

**Parameters:**

  - `_to`: The address of the recipient
  - `_value`: The amount of token to be transferred

**Returns:**

Whether the transfer was successful or not

### `transferFrom(address,address,uint256)`

send `_value` token to `_to` from `_from` on the condition it is approved by `_from`

**Parameters:**

  - `_to`: The address of the recipient
  - `_from`: The address of the sender
  - `_value`: The amount of token to be transferred

**Returns:**

Whether the transfer was successful or not

### `transferOwnership(address)`

Transfer ownership from `owner` to `newOwner`

**Parameters:**

  - `newOwner`: The new contract owner

