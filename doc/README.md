# Main Gimli contract.

### `addAdministrators(address)`

Add an administrator

**Parameters:**

  - `_adminAddess`: The new administrator address

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

  - `_value`: The amount of tokens to be approved for transfer
  - `_spender`: The address of the account able to transfer the tokens

**Returns:**

Whether the approval was successful or not

### `authorizeStreamer(address,address,uint256,uint256,uint256)`

authorize an address to create Gimli game (bet, vote, etc.)

`_streamerFeesPpm + _gimliFeesPpm` must be equal to 1000

**Parameters:**

  - `_streamerAddress`: Authorized address
  - `_streamerFeesPpm`: Share of fees for the streamer (ppm, ex: 5 for 0.5%)
  - `_contractAddress`: Contract address (GimliBetting, GimliVoting, etc.)
  - `_gimliFeesPpm`: Share of fees for Gimli (ppm, ex: 5 for 0.5%)
  - `_maxPrice`: The maximum price a Streamer can claim to users for a game

### `balanceOf(address)`

Get balance of an address

**Parameters:**

  - `_owner`: The address from which the balance will be retrieved

**Returns:**

The balance

### `claimGMLPayment(address,address,uint256)`

Called by a Gimli contract to claim game payment

`msg.sender` and `_streamerAddress` must be authorized with the function `authorizeStreamer()`. `_userAddress` must be the origin of the transaction.

**Parameters:**

  - `_streamerAddress`: Streamer address who created the game
  - `_userAddress`: User address who pays the game
  - `_price`: Price paid by `_userAddress`

### `getAllowedContract(address,address)`

Get information about a contract authorized for a streamer

**Parameters:**

  - `_streamerAddress`: The streamer address
  - `_contractAddress`: The contract address

**Returns:**

Share of fees for streamer and Gimli, the maximum price authorized and a boolean to indicate if the permission exists.

### `removeAdministrators(address)`

Remove an administrator

**Parameters:**

  - `_adminAddess`: The administrator address to remove

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

  - `_from`: The address of the sender
  - `_to`: The address of the recipient
  - `_value`: The amount of token to be transferred

**Returns:**

Whether the transfer was successful or not

### `transferOwnership(address)`

Transfer ownership from `owner` to `newOwner`

**Parameters:**

  - `newOwner`: The new contract owner

### `withdrawalCrowdsale(address)`

Send GML payments  to `_to`

**Parameters:**

  - `_to`: The withdrawal destination

