# Main Gimli contract.

### `addAdministrators(address)`

Add an administrator

**Parameters:**

  - `_adminAddress`: The new administrator address

### `allowance(address,address)`

Get tokens allowed to spent by `_spender`

**Parameters:**

  - `_spender`: The address of the account able to transfer the tokens
  - `_owner`: The address of the account owning tokens

**Returns:**

Amount of remaining tokens allowed to spent

### `approve(address,uint256)`

`msg.sender` approves `_spender` to spend `_value` tokens

**Parameters:**

  - `_value`: The amount of tokens to be approved for transfer
  - `_spender`: The address of the account able to transfer the tokens

**Returns:**

Whether the approval was successful or not

### `balanceOf(address)`

Get balance of an address

**Parameters:**

  - `_owner`: The address from which the balance will be retrieved

**Returns:**

The balance

### `preAllocate(address,uint256,uint256)`

Pre-allocate tokens to advisor or partner

**Parameters:**

  - `_value`: The amount of token to be allocated
  - `_price`: ETH paid for these tokens
  - `_to`: The pre-allocation destination

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

### `setStreamerContract(address,uint256)`

authorize an address to transfer GIM on behalf an user

**Parameters:**

  - `_maxAmount`: The maximum amount that can be transfered by the contract
  - `_contractAddress`: Address of GimliStreamer contract

### `transfer(address,uint256)`

send `_value` token to `_to` from `msg.sender`

**Parameters:**

  - `_value`: The amount of token to be transferred
  - `_to`: The address of the recipient

**Returns:**

Whether the transfer was successful or not

### `transferFrom(address,address,uint256)`

send `_value` token to `_to` from `_from` on the condition it is approved by `_from`

**Parameters:**

  - `_from`: The address of the sender
  - `_value`: The amount of token to be transferred
  - `_to`: The address of the recipient

**Returns:**

Whether the transfer was successful or not

### `transferGIM(address,address,uint256)`

Called by a Gimli contract to transfer GIM

**Parameters:**

  - `_from`: The address of the sender
  - `_amount`: The amount of token to be transferred
  - `_to`: The address of the recipient

**Returns:**

Whether the transfer was successful or not

### `transferOtherERC20Token(address,uint256)`

transfer out any accidentally sent ERC20 tokens

**Parameters:**

  - `amount`: The amount of token to be transfered
  - `tokenAddress`: Address of the ERC20 contract

### `transferOwnership(address)`

Transfer ownership from `owner` to `newOwner`

**Parameters:**

  - `_newOwner`: The new contract owner

