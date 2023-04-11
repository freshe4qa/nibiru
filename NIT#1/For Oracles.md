# For Oracles (+200)

## For price data external to the blockchain, Nibiru relies on its participants from the validator set to vote on exchange rates.

Vote in at least 10000 VotePeriods.

Provide prices on all whitelisted pairs for those VotePeriods.

Note: An oracle is a validator that provides prices rather than abstaining. Delegating to an oracle counts for completion of an action.

# Set up a pricefeeder

To run pricefeeder you validator should be in active set. Otherwise price feeder will not vote on periods.

1) Install the pricefeeder binary

```
curl -s https://get.nibiru.fi/pricefeeder! | bash
```

2) Create new wallet for pricefeeder and save 24 word mnemonic phrase

```
nibid keys add pricefeeder-wallet
```

3) Top up the pricefeeder-wallet going to Nibiru Discord #faucet channel.
In order to make pricefeeder work, it needs some testnet tokens to pay for transaction fees

4) Export pricefeeder mnemonic into environment variable

```
export FEEDER_MNEMONIC="my pricefeeder 24 word mnemonic phrase goes here ..."
```

5) Setup the systemd service
 
```
export CHAIN_ID="nibiru-itn-1"
```

```
export GRPC_ENDPOINT="localhost:39090"
```

```
export WEBSOCKET_ENDPOINT="ws://localhost:39657/websocket"
```

```
export EXCHANGE_SYMBOLS_MAP='{ "bitfinex": { "ubtc:uusd": "tBTCUSD", "ueth:uusd": "tETHUSD", "uusdt:uusd": "tUSTUSD" }, "binance": { "ubtc:uusd": "BTCUSD", "ueth:uusd": "ETHUSD", "uusdt:uusd": "USDTUSD", "uusdc:uusd": "USDCUSD", "uatom:uusd": "ATOMUSD", "ubnb:uusd": "BNBUSD", "uavax:uusd": "AVAXUSD", "usol:uusd": "SOLUSD", "uada:uusd": "ADAUSD", "ubtc:unusd": "BTCUSD", "ueth:unusd": "ETHUSD", "uusdt:unusd": "USDTUSD", "uusdc:unusd": "USDCUSD", "uatom:unusd": "ATOMUSD", "ubnb:unusd": "BNBUSD", "uavax:unusd": "AVAXUSD", "usol:unusd": "SOLUSD", "uada:unusd": "ADAUSD" } }'
```

```
export VALIDATOR_ADDRESS=$(nibid keys show wallet --bech val -a)
```

```
sudo tee /etc/systemd/system/pricefeeder.service<<EOF
[Unit]
Description=Nibiru Pricefeeder
Requires=network-online.target
After=network-online.target

[Service]
Type=exec
User=$USER
Group=$USER
ExecStart=/usr/local/bin/pricefeeder
Restart=on-failure
ExecReload=/bin/kill -HUP $MAINPID
KillSignal=SIGTERM
PermissionsStartOnly=true
LimitNOFILE=65535
Environment=CHAIN_ID='$CHAIN_ID'
Environment=GRPC_ENDPOINT='$GRPC_ENDPOINT'
Environment=WEBSOCKET_ENDPOINT='$WEBSOCKET_ENDPOINT'
Environment=EXCHANGE_SYMBOLS_MAP='$EXCHANGE_SYMBOLS_MAP'
Environment=FEEDER_MNEMONIC='$FEEDER_MNEMONIC'
Environment=VALIDATOR_ADDRESS='$VALIDATOR_ADDRESS'

[Install]
WantedBy=multi-user.target
EOF 
```

6) Delegate pricefeeder responsibility

As a validator, if you'd like another account to post prices on your behalf (i.e. you don't want your validator mnemonic sending txs), you can delegate pricefeeder responsibilities to another nibi address

```
nibid tx oracle set-feeder $(nibid keys show pricefeeder-wallet -a) --from wallet
```

7) Register and start the systemd service

```
sudo systemctl daemon-reload && \
sudo systemctl enable pricefeeder && \
sudo systemctl start pricefeeder
```

8) View pricefeeder logs

```
journalctl -fu pricefeeder
```

Successfull Log examples:

Feb 27 19:09:33 pricefeeder[3632198]: {"level":"info","voting-period-height":405780,"tx-hash":"8FC418510A2BBFEF6E2FF17108B5D1C909B14DC0AFB22129A73C7373E649329F","time":1677521373,"message":"successfully forwarded prices"}

Feb 27 19:09:48 pricefeeder[3632198]: {"level":"info","voting-period":{"Height":405790},"time":1677521388,"message":"new voting period"}

Feb 27 19:09:48 pricefeeder[3632198]: {"level":"info","voting-period-height":405790,"vote":{"salt":"337","exchange_rates":"(unibi:unusd,0.066667000000000000)|(ubtc:unusd,23296.630000000000000000)|(ueth:unusd,1628.900000000000000000)|(uatom:unusd,12.760000000000000000)|(ubnb:unusd,301.740800000000000000)|(uusdc:unusd,0.999900000000000000)|(uusdt:unusd,1.000100000000000000)|(unibi:uusd,0.066667000000000000)|(ubtc:uusd,23314.000000000000000000)|(ueth:uusd,1629.900000000000000000)|(uatom:uusd,12.760000000000000000)|(ubnb:uusd,301.740800000000000000)|(uusdc:uusd,0.999900000000000000)|(uusdt:uusd,1.000100000000000000)","feeder":"nibi1w9d0u9ln9tx9dnn5qku9977jn2rtrupxxx0lrn","validator":"nibivaloper195w5wxp8hgqgz7schdukq7u5kadc2tnrsc00a0"},"time":1677521388,"message":"prepared vote message"}

Feb 27 19:09:50 pricefeeder[3632198]: {"level":"info","voting-period-height":405790,"tx-hash":"ACB94C8421AE056468BDAAE68655D86CEB87FB6881A526A31A7A2E98234C8D13","time":1677521390,"message":"successfully forwarded prices"}

Feb 27 19:10:05 pricefeeder[3632198]: {"level":"info","voting-period":{"Height":405800},"time":1677521405,"message":"new voting period"}

Feb 27 19:10:05 pricefeeder[3632198]: {"level":"info","voting-period-height":405800,"vote":{"salt":"3334","exchange_rates":"(unibi:unusd,0.066667000000000000)|(ubtc:unusd,23296.680000000000000000)|(ueth:unusd,1628.780000000000000000)|(uatom:unusd,12.760000000000000000)|(ubnb:unusd,301.740800000000000000)|(uusdc:unusd,0.999900000000000000)|(uusdt:unusd,1.000100000000000000)|(unibi:uusd,0.066667000000000000)|(ubtc:uusd,23296.680000000000000000)|(ueth:uusd,1628.780000000000000000)|(uatom:uusd,12.760000000000000000)|(ubnb:uusd,301.740800000000000000)|(uusdc:uusd,0.999900000000000000)|(uusdt:uusd,1.000100000000000000)","feeder":"nibi1w9d0u9ln9tx9dnn5qku9977jn2rtrupxxx0lrn","validator":"nibivaloper195w5wxp8hgqgz7schdukq7u5kadc2tnrsc00a0"},"time":1677521405,"message":"prepared vote message"}

Feb 27 19:10:06 pricefeeder[3632198]: {"level":"info","voting-period-height":405800,"tx-hash":"1E85AD6307DD8D734AAB6565CC57FB09F0EA0F7CFE0B8EE8AB50FC8A08B4111A","time":1677521406,"message":"successfully forwarded prices"}

Feb 27 19:10:22 pricefeeder[3632198]: {"level":"info","voting-period":{"Height":405810},"time":1677521422,"message":"new voting period"}

Feb 27 19:10:22 pricefeeder[3632198]: {"level":"info","voting-period-height":405810,"vote":{"salt":"9672","exchange_rates":"(unibi:unusd,0.066667000000000000)|(ubtc:unusd,23310.000000000000000000)|(ueth:unusd,1630.010000000000000000)|(uatom:unusd,12.760000000000000000)|(ubnb:unusd,301.737500000000000000)|(uusdc:unusd,0.999900000000000000)|(uusdt:unusd,1.000000000000000000)|(unibi:uusd,0.066667000000000000)|(ubtc:uusd,23307.000000000000000000)|(ueth:uusd,1629.200000000000000000)|(uatom:uusd,12.760000000000000000)|(ubnb:uusd,301.737500000000000000)|(uusdc:uusd,0.999900000000000000)|(uusdt:uusd,1.000000000000000000)","feeder":"nibi1w9d0u9ln9tx9dnn5qku9977jn2rtrupxxx0lrn","validator":"nibivaloper195w5wxp8hgqgz7schdukq7u5kadc2tnrsc00a0"},"time":1677521422,"message":"prepared vote message"}

Feb 27 19:10:23 pricefeeder[3632198]: {"level":"info","voting-period-height":405810,"tx-hash":"24B3B16FB8B6B047885928FB6A254D7B0B44E17E0DC6AF37B1F077F78C7099A9","time":1677521423,"message":"successfully forwarded prices"}

Also you can check that your pricefeeder-wallet is doing transactions on chain at Chain Explorer
