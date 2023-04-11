# For Delegators (+100 pts)

## 1) Stake at least 1 NIBI to a validator ##
```
nibid tx staking delegate nibivaloper1xkxzmxqzv8ys8lfs06ph83dj5gw6rq37kvqpnz 10000000unibi --from=$WALLET --chain-id=$NIBIRU_CHAIN_ID --gas=auto -y
```
## 2) Claim rewards ##
```
nibid tx distribution withdraw-all-rewards --from=$WALLET --chain-id=$NIBIRU_CHAIN_ID --gas=auto -y
```
## 3) Redelegate your stake from one validator to another ##
```
nibid tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000unibi --from=$WALLET --chain-id=$NIBIRU_CHAIN_ID --gas=auto -y
```
## 4) Stake to an oracle ##
```
nibid tx staking delegate nibivaloper1uuvuzu70mq6qkhu335ysg4cfthvad6hwsq3250 10000000unibi --from=$WALLET --chain-id=$NIBIRU_CHAIN_ID --gas=auto -y
```
## 5) Unstake your tokens ## 
```
nibid tx staking unbond $(nibid keys show wallet --bech val -a) 1000000unibi --from wallet --chain-id nibiru-itn-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.025unibi -y
```
