# Main Gimli contract.

### `transferOwnership(address)`

Transfer ownership from `owner` to `newOwner`

**Parameters:**

  - `newOwner`: The new contract owner

### `getHolderCount()`

Get holder count

**Returns:**

holder count

### `getAuthorizedStreamerByIndex(uint256)`

Return information about a streamer

The number of contracts can be greater than zero even if the streamer is not anymore authorized.

**Parameters:**

  - `_streamerIndex`: The streamer address position in `authorizedStreamers`

**Returns:**

The streamer address, a boolean to indicate if the streamer is authorized and the number of contract allowed.

### `authorizeStreamer(address,address,uint256,uint256,uint256)`

authorize an address to create Gimli game (bet, vote, etc.)

`_streamerFeesPpm + _gimliFeesPpm` must be equal to 1000

**Parameters:**

  - `_streamerAddress`: Authorized address
  - `_maxPrice`: The maximum price a Streamer can claim to users for a game
  - `_gimliFeesPpm`: Share of fees for Gimli (ppm, ex: 5 for 0.5%)
  - `_contractAddress`: Contract address (GimliBetting, GimliVoting, etc.)
  - `_streamerFeesPpm`: Share of fees for the streamer (ppm, ex: 5 for 0.5%)

### `getBalanceByIndex(uint256)`

Get balance by index

**Parameters:**

  - `_holderIndex`: The holder index

**Returns:**

The address of the holder and his balance

### `withdrawalCrowdsale(address)`

Send GML payments  to `_to`

**Parameters:**

  - `_to`: The withdrawal destination

### `allowance(address,address)`

Get tokens allowed to spent by `_spender`

**Parameters:**

  - `_owner`: The address of the account owning tokens
  - `_spender`: The address of the account able to transfer the tokens

**Returns:**

Amount of remaining tokens allowed to spent

### `getAuthorizedStreamerCount()`

Get authorized streamers count

**Returns:**

Authorized streamers count

### `removeAdministrators(address)`

Remove an administrator

**Parameters:**

  - `_adminAddess`: The administrator address to remove

### `getAuthorizedStreamer(address)`

Return information about a streamer

The number of contracts can be greater than zero even if the streamer is not anymore authorized.

**Parameters:**

  - `_streamerAddress`: The streamer address

**Returns:**

A boolean to indicate if the streamer is authorized and the number of contract allowed.

### `approve(address,uint256)`

`msg.sender` approves `_spender` to spend `_value` tokens

**Parameters:**

  - `_spender`: The address of the account able to transfer the tokens
  - `_value`: The amount of tokens to be approved for transfer

**Returns:**

Whether the approval was successful or not

### `addAdministrators(address)`

Add an administrator

**Parameters:**

  - `_adminAddess`: The new administrator address

### `getAllowedContracByIndex(address,uint256)`

Get information about a contract allowed to a streamer

**Parameters:**

  - `_contractIndex`: The contract address position in `authorizedStreamerAllowances[_streamerAddress].allowedContracts`
  - `_streamerAddress`: The streamer address

**Returns:**

Share of fees for streamer and Gimli, the maximum price allowed and a boolean to indicate if the allowance exists.

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
  - `_value`: The amount of token to be transferred
  - `_from`: The address of the sender

**Returns:**

Whether the transfer was successful or not

### `claimGMLPayment(address,address,uint256)`

Called by a Gimli contract to claim game payment

`msg.sender` and `_streamerAddress` must be authorized with the function `authorizeStreamer()`. `_userAddress` must be the origin of the transaction.

**Parameters:**

  - `_price`: Price paid by `_userAddress`
  - `_userAddress`: User address who pays the game
  - `_streamerAddress`: Streamer address who created the game

### `balanceOf(address)`

Get balance of an address

**Parameters:**

  - `_owner`: The address from which the balance will be retrieved

**Returns:**

The balance

### `getAllowedContract(address,address)`

Get information about a contract allowed to a streamer

**Parameters:**

  - `_streamerAddress`: The streamer address
  - `_contractAddress`: The contract address

**Returns:**

Share of fees for streamer and Gimli, the maximum price allowed and a boolean to indicate if the allowance exists.

### `revokeStreamer(address)`

Revoke a streamer for all contracts

**Parameters:**

  - `_streamerAddress`: Streamer address to revoke

