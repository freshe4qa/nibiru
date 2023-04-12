# Smart Contract Tasks (+300)

## Open the terminal and install the nibid binary. This holds the Nibiru CLI application.
```
curl -s https://get.nibiru.fi/! | bash
```

## Point the config of the nibid binary to the incentivized testnet.

```
nibid config node https://rpc.itn-1.nibiru.fi:443
nibid config chain-id nibiru-itn-1
nibid config broadcast-mode block
nibid config keyring-backend
```

## Download a smart contract's .wasm binary from the NibiruChain/cw-nibiru repo, or compile your own if you know how to do so.
```
git clone https://github.com/NibiruChain/cw-nibiru
```

## Loading the contract
```
nibid tx wasm store $HOME/cw-nibiru/artifacts-cw-plus/cw20_base.wasm --from wallet --gas-adjustment 1.5 --gas auto --fees 90000unibi  -y 
```

### Logs
```
logs:
- events:
  - attributes:
    - key: action
      value: /cosmwasm.wasm.v1.MsgStoreCode
    - key: module
      value: wasm
    - key: sender
      value: nibi1xxn6tgdc75gdh9l9tlvncy45dytshkvxcl0m6a
    type: message
  - attributes:
    - key: code_checksum
      value: 1525a17a5b98438a26b019ffa184b2a355d225485fcfc87ccbcd524d4a24be18
    - key: code_id
      value: "1337"
    type: store_code
  log: ""
  msg_index: 0
raw_log: '[{"events":[{"type":"message","attributes":[{"key":"action","value":"/cosmwasm.wasm.v1.MsgStoreCode"},{"key":"module","value":"wasm"},{"key":"sender","value":"nibi1xxn6tgdc75gdh9l9tlvncy45dytshkvxcl0m6a"}]},{"type":"store_code","attributes":[{"key":"code_checksum","value":"1525a17a5b98438a26b019ffa184b2a355d225485fcfc87ccbcd524d4a24be18"},{"key":"code_id","value":"1417"}]}]}]'
timestamp: ""
tx: null
txhash: 5F77C7F812D6981E918314BD83BBC1723E2628104CC9AD81E9CEB7D9D2E1F06E
```

## Write down the code ID and txhash somewhere. If you want to know where it is written, look at the last lines of the example output above, it will be written there as cod_id.

## If you forget your code ID, you can find it out with this command.

```
nibid q tx 5F77C7F812D6981E918314BD83BBC1723E2628104CC9AD81E9CEB7D9D2E1F06E -o json |  jq -r '.raw_log'
```

## Complete and use the command according to the command example below.
```
INIT='{"name":"YOUR_NAME","symbol":"YOUR_SYMBOL","decimals":6,"initial_balances":[{"address":"WALLET_ADDRESS","amount":"5000000"}],"mint":{"minter":"WALLET_ADDRESS"},"marketing":{}}'
nibid tx wasm instantiate 1337 $INIT --from wallet --label "test" --gas-adjustment 1.2 --gas auto --fees 80000unibi --no-admin -y
```

## Let's set a variable containing the address of your contract.
```
CONTRACT=$(nibid query wasm list-contract-by-code 1337 --output json | jq -r '.contracts[-1]')
```

### You can change the amount in the Amount section.
```
TRANSFER='{"transfer":{"recipient":"CONTRACT_ADDRESS","amount":"100"}}'
```

## Executing the contract
```
nibid tx wasm execute $CONTRACT $TRANSFER --gas-adjustment 1.5 --gas auto --fees 6000unibi --from wallet -y
```
