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
PEERS="a1b96d1437fb82d3d77823ecbd565c6268f06e34@nibiru-testnet.nodejumper.io:27656,19f8333cbcaf4f946d20a91d9e19d5fc91899023@167.235.74.22:26656,9e9a8ffb07318c9d5237274bb32711b008b46348@91.107.233.192:26656,6f29a743ad237d435aac29b62528cea01ceb3ca9@46.4.91.90:26656,ca5805d8553b99d6e226deecd9c28a9bcb380651@161.97.163.208:26656,1c6f50dfeb2187f38e8dea2e1bae00e8b5bf6b16@161.97.102.159:26656,f9e2c35f5da87933bcc092ab9f14d45b08d3e89d@65.108.145.226:26656,1d2d3e8353043b25675040258912fb04cfc3eff9@162.55.242.81:26656,aafe706e7bb9aac7e8ec2878d775252652594b3e@78.46.97.242:26656,8e01bceecf0965c6e9f1cbce95063ae9de931ada@144.91.65.161:26656,e08089921baf39382920a4028db9e5eebd82f3d7@142.132.199.236:21656,dfdfca675e009578b775d7febace9d15d97c3755@207.180.224.21:26656,a9fd9fa7733333fa0b1f9d0868e394dd73c103da@89.116.28.98:26656,333b77ac522d86819d341cd675f962dd0ee3ae79@85.190.246.188:26656,4f1af4f62f76c095d844384a3dfa1ad76ad5c078@65.108.206.118:60656,5a58fa951f65cd2381d0f9a584fbb76fdafc476c@45.10.154.139:18656,5dd26cc6a2778cea7c0daed0a53a39c6165a790f@168.119.101.224:26656,f2e99f5a68adfb08c139944a193e2e3a4864b038@167.235.132.74:26656,bc2f0d7d7284ae91db72665d9fe154be4c2adae9@91.230.110.106:26656,a2d2ba190f32700f44e9dbe990c814f46abfc96f@81.0.221.31:26656,fc622de0732fb4ed75319c31dc83e22517a48c1c@144.91.75.58:26656,d3624259ec8322cd4b6bce5b39aaf6074f90a2ab@173.212.248.126:26656,aa166a62f6983edccd5a2619b036fe83cb4eb57e@168.119.248.238:26656,e052d62551e51b986572ea0c2e7c49ebb080b108@89.163.132.44:26656,22f1bf214da6c0c1e6c6b78bc6005ac4fc4456da@46.228.205.211:26656,cd44f2d2fc1ded3a63c64f46ed67f783c2d93d57@144.76.223.24:36656,5f794b4b6f1232e5814c66f4bd7307adcdd206cb@104.248.61.162:26656,e74f1204d65d0264547e2c2d917c23c39fcff774@95.217.107.96:36656,d12c686810ecfa63d55ac47715a542d0d73648ac@144.91.107.153:26656,79e2bfc202e39ba2a168becc4c75cb6a56803e38@135.181.57.104:11656,595a8f93897710cacc3173c9ae4d0bafda5b3879@141.94.73.93:36656,8ebed484e09f93b12be00b9f6faa55ea9b13b372@45.84.138.66:39656,81351ddd64122e553cf2c10efbd979c8c6e97529@161.97.166.105:26656,3060a899170ccb3d787d6fd840c5e8b6805f4b4d@155.133.22.140:26656,8bd4bbda5a778f362e8d848eedc0e7aa0a85f776@38.242.253.73:26656,5f3394bae3791bcb71364df80f99f22bd33cc2c0@95.216.7.169:60556,a141b286f68f88fa41b1e12cbf5ab079610fabd4@149.102.155.48:26656,226cc92db67523820735c939c1dde96892ad1c6d@194.163.147.65:26656,4ae091976ef83403cbbb55345a1af0a06f3ef524@144.76.101.41:26656,5b2d7ccdf924ff16c3d0e3b55c4547a71c99dc42@161.97.122.167:39656,d6121e2eb0842e03529b3a093204bebe637fa5aa@149.102.140.245:26656,455631724cc9596a3f1ca99fe6874125d050a983@38.242.225.208:26656,7b71facfb46ccd860d4d71696b3a077676a6f2b5@65.109.166.8:26656,be58621ecdf7dae1ff6fa5123793ddbc794427b1@65.21.248.137:26656,adcb0c33d521b5a26e83834454ed126988493573@95.216.74.4:26656,9f993f07f3fe0c788f7d55f88b7a031028a378f5@217.76.60.46:26656,cbab105572dda2e1fd343c95e29aa4c7a7336196@194.163.166.62:26656,abd7cc73f45fd10c87f90ce2e7c2b63d8d7dd28e@91.189.129.99:26656"
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
curl https://snapshots2-testnet.nodejumper.io/nibiru-testnet/nibiru-itn-1_2023-03-12.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.nibid

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
