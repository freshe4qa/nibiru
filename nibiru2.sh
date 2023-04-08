#!/bin/bash

while true
do

# Logo

echo -e '\e[40m\e[91m'
echo -e '  ____                  _                    '
echo -e ' / ___|_ __ _   _ _ __ | |_ ___  _ __        '
echo -e '| |   |  __| | | |  _ \| __/ _ \|  _ \       '
echo -e '| |___| |  | |_| | |_) | || (_) | | | |      '
echo -e ' \____|_|   \__  |  __/ \__\___/|_| |_|      '
echo -e '            |___/|_|                         '
echo -e '\e[0m'

sleep 2

# Menu

PS3='Select an action: '
options=(
"Install"
"Create Wallet"
"Create Validator"
"Exit")
select opt in "${options[@]}"
do
case $opt in

"Install")
echo "============================================================"
echo "Install start"
echo "============================================================"

# set vars
if [ ! $NODENAME ]; then
	read -p "Enter node name: " NODENAME
	echo 'export NODENAME='$NODENAME >> $HOME/.bash_profile
fi
if [ ! $WALLET ]; then
	echo "export WALLET=wallet" >> $HOME/.bash_profile
fi
echo "export NIBIRU_CHAIN_ID=nibiru-itn-1" >> $HOME/.bash_profile
source $HOME/.bash_profile

# update
sudo apt update && sudo apt upgrade -y

# packages
sudo apt install curl build-essential git wget jq make gcc tmux chrony -y

# install go
if ! [ -x "$(command -v go)" ]; then
  ver="1.18.2"
cd $HOME
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
source ~/.bash_profile
fi

# download binary
cd $HOME && rm -rf nibiru
git clone https://github.com/NibiruChain/nibiru
cd nibiru
git checkout v0.19.2
make install

# config
nibid config chain-id $NIBIRU_CHAIN_ID
nibid config keyring-backend test

# init
nibid init $NODENAME --chain-id $NIBIRU_CHAIN_ID

# download genesis and addrbook
curl -s https://rpc.itn-1.nibiru.fi/genesis | jq -r .result.genesis > $HOME/.nibid/config/genesis.json
curl -s https://snapshots2-testnet.nodejumper.io/nibiru-testnet/addrbook.json > $HOME/.nibid/config/addrbook.json

# set minimum gas price
sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"0.0001unibi\"|" $HOME/.nibid/config/app.toml

# set peers and seeds
SEEDS="3f472746f46493309650e5a033076689996c8881@nibiru-testnet.rpc.kjnodes.com:39659,a431d3d1b451629a21799963d9eb10d83e261d2c@seed-1.itn-1.nibiru.fi:26656,6a78a2a5f19c93661a493ecbe69afc72b5c54117@seed-2.itn-1.nibiru.fi:26656"
PEERS="a1b96d1437fb82d3d77823ecbd565c6268f06e34@nibiru-testnet.nodejumper.io:27656,57adeadec1939df8cb6cebb665beb13f3c370ea0@89.117.58.213:26656,19f6588df6e489a3e512ebac805c5250cdc9fbb7@84.46.249.14:26656,6ec27a0783cc1b482db94d3bf0a00a6744dc9e8e@217.76.60.224:26656,0a8feb7558b5f77fcb2abd9c3d8b1230bcf2ae64@95.216.33.149:26656,68eeaeffe22c68b035ea40c81a1470c42343bea1@81.0.218.145:26651,7ab4f18d9745548b1005be91cb1a96785a0abf32@185.135.137.123:26656,d7ad256b785cb4acac8904db316f96ba708d55c9@217.76.49.78:26656,496436418a8cecadb3986412ced34e57d86cf506@94.190.90.38:35656,c9ac3f6cd08e7e69beb3ee3de1176a3e6ea4a01d@65.108.2.46:26656,ecce2915168483b889b26ae69038b84dc2d58529@31.187.74.224:26656,2479ff4d8c0918b95da280319b179f016b5db814@65.108.199.120:61756,a6302e34313b649505603aaafad3e1d24cbfbc7b@81.0.218.74:26656,a480c13b73c0d08183c0dd327c1393b33dd5ef7c@185.197.195.18:26656,8e471a078b929944d3812c44e7babe06fb32b527@178.18.249.99:26656,879c0d532c818d571df2229dbbb2732a17db7d2f@185.135.137.221:26656,993dfa9c53630fdcfeba56a9f380ef0c5fecad22@113.161.144.108:26656,9920bfdee1f9f61221e0301b1823f050e8fb992f@193.203.203.121:26656,26d712934ef6ffa00c3e12cac206c8a288bc0893@5.9.122.49:11656,68de8dee93d9dd3cefc24c5d180933dade4c03f8@185.215.166.231:26656,ae99caf00be07e9a5358b775c1f3ce1a2d97d152@38.242.234.37:26656,1345836788e850a88dd95d7351bb3b34f3de965e@80.82.215.19:36756,d478d4a34de532833ec1c4df65f3b79f77265f17@35.229.110.80:26656,7863c6d6c3903f214c71773d56ae4c105d0d2803@38.242.239.227:26656,2da0634693164c784a3f4e924805ca481846b318@45.10.154.80:26656,d26e9d2a81ce80328d3a9aeabb0820fbc343b5f4@161.97.170.91:26656,d39e7451f84c3918860954f66ce473cca70ab70e@209.250.242.119:26656,5b3fbf28b3ccf5e4e95d3e2e1a3b22c7afdf24d5@185.135.137.160:26656,13cc216c7c2c29783fae084062f10c68f2999d83@91.229.245.201:26656,c2f061358e28727095730c7040be51a513dc72cd@176.9.65.181:26656,ff4fdb162a01a7e8e36bfdef66d33a9ac7368588@172.105.71.125:39656,8afc84603e28fd698031b1872c9fe87942c5d7f9@81.0.218.84:26656,4dbf76072ba52dd9322724a07991163e27b85877@185.211.6.20:26656,1fcbd84325934e2b001d05b7172d0749600342cf@34.134.38.66:26656,0f8ea9f1dacc680e7074e8019bae16b1e8979977@89.117.58.243:26656,d8653d56d8914e5a26d7ff2f2f930dc44d593e1e@38.242.232.142:26656,59b68485aa643cec437058ccf7913503815371c1@31.220.81.107:26656,857a7bb4ddb71b1fe58ca2dba64f2b98f66486cb@65.108.96.43:26656,30ad7f27c225de1ed881fd355d2d006d445f281a@84.46.248.169:26656,9f993f07f3fe0c788f7d55f88b7a031028a378f5@217.76.60.46:26656,4a70de4fffde46382e70250c06f744570ce72ef9@138.201.124.93:26656,c9591686a6fa9ded61f167a93a4a96580414d3cd@178.141.254.11:26656,5a58fa951f65cd2381d0f9a584fbb76fdafc476c@45.10.154.139:18656,e36ab19d3c46707e9dfec70be31023aed589c06c@161.97.142.54:26656,21935d4c8fd0b3a5819cde63ecb25f5ede0519b1@195.201.195.40:56656,de5bc0400e6f614fcea209e8de4f4487045e361e@62.141.46.82:39656,879637c3c880825087c120a661037341d4bb17e6@184.174.32.224:26656,94daad756341e2d091d1b2926a94650b5acfa0ad@92.38.241.228:26656,4b4948124a02cc7bca85a98904eab884d1af2c7c@65.109.26.21:11656,65a213efcad697afb5a1303c7fe5be4168d9520c@43.154.103.36:26656,da56da9589f09065227ab45b51302f3f66b0462a@65.109.167.129:26656"
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.nibid/config/config.toml

# disable indexing
indexer="null"
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/.nibid/config/config.toml

# config pruning
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.nibid/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.nibid/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.nibid/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.nibid/config/app.toml
sed -i "s/snapshot-interval *=.*/snapshot-interval = 0/g" $HOME/.nibid/config/app.toml

# enable prometheus
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/.nibid/config/config.toml

# create service
sudo tee /etc/systemd/system/nibid.service > /dev/null << EOF
[Unit]
Description=Nibiru Node
After=network-online.target
[Service]
User=$USER
ExecStart=$(which nibid) start
Restart=on-failure
RestartSec=10
LimitNOFILE=10000
[Install]
WantedBy=multi-user.target
EOF

# reset
nibid tendermint unsafe-reset-all --home $HOME/.nibid --keep-addr-book 
curl https://snapshots2-testnet.nodejumper.io/nibiru-testnet/nibiru-itn-1_2023-04-08.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.nibid

# start service
sudo systemctl daemon-reload
sudo systemctl enable nibid
sudo systemctl restart nibid

break
;;

"Create Wallet")
nibid keys add $WALLET
echo "============================================================"
echo "Save address and mnemonic"
echo "============================================================"
NIBIRU_WALLET_ADDRESS=$(nibid keys show $WALLET -a)
NIBIRU_VALOPER_ADDRESS=$(nibid keys show $WALLET --bech val -a)
echo 'export NIBIRU_WALLET_ADDRESS='${NIBIRU_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export NIBIRU_VALOPER_ADDRESS='${NIBIRU_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile

break
;;

"Create Validator")
nibid tx staking create-validator \
--amount=10000000unibi \
--pubkey=$(nibid tendermint show-validator) \
--moniker="$NODENAME" \
--chain-id=nibiru-itn-1 \
--commission-rate=0.1 \
--commission-max-rate=0.2 \
--commission-max-change-rate=0.05 \
--min-self-delegation=1 \
--fees=2000unibi \
--from=wallet \
-y
  
break
;;

"Exit")
exit
;;
*) echo "invalid option $REPLY";;
esac
done
done
