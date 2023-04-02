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
PEERS="a1b96d1437fb82d3d77823ecbd565c6268f06e34@nibiru-testnet.nodejumper.io:27656,19f8333cbcaf4f946d20a91d9e19d5fc91899023@167.235.74.22:26656,9e9a8ffb07318c9d5237274bb32711b008b46348@91.107.233.192:26656,6f29a743ad237d435aac29b62528cea01ceb3ca9@46.4.91.90:26656,fe17db7c9a5f8478a2d6a39dbf77c4dc2d6d7232@5.75.189.135:26656,b300cdfbbd9af83bab94fcfc493d43a88ab01acc@80.82.215.214:39656,f9e2c35f5da87933bcc092ab9f14d45b08d3e89d@65.108.145.226:26656,1d2d3e8353043b25675040258912fb04cfc3eff9@162.55.242.81:26656,aafe706e7bb9aac7e8ec2878d775252652594b3e@78.46.97.242:26656,7b8da020f7cf7b4928e34b3ba8d47d1ee5ed5944@45.151.123.51:26656,e08089921baf39382920a4028db9e5eebd82f3d7@142.132.199.236:21656,7ab4f18d9745548b1005be91cb1a96785a0abf32@185.135.137.123:26656,8ebed484e09f93b12be00b9f6faa55ea9b13b372@45.84.138.66:39656,9f993f07f3fe0c788f7d55f88b7a031028a378f5@217.76.60.46:26656,4f1af4f62f76c095d844384a3dfa1ad76ad5c078@65.108.206.118:60656,3060a899170ccb3d787d6fd840c5e8b6805f4b4d@155.133.22.140:26656,5dd26cc6a2778cea7c0daed0a53a39c6165a790f@168.119.101.224:26656,f2e99f5a68adfb08c139944a193e2e3a4864b038@167.235.132.74:26656,233e6b3ac72409d301830d98db66d3ced6b366e0@135.181.92.180:26656,bb54d4190da91d6a9c1f7322f9e8e38844a9e6b0@173.212.196.242:26656,e74f1204d65d0264547e2c2d917c23c39fcff774@95.217.107.96:36656,d3624259ec8322cd4b6bce5b39aaf6074f90a2ab@173.212.248.126:26656,aa166a62f6983edccd5a2619b036fe83cb4eb57e@168.119.248.238:26656,30ad7f27c225de1ed881fd355d2d006d445f281a@84.46.248.169:26656,22f1bf214da6c0c1e6c6b78bc6005ac4fc4456da@46.228.205.211:26656,cd44f2d2fc1ded3a63c64f46ed67f783c2d93d57@144.76.223.24:36656,e9b25db508b31cb9d48b1f0b67147faf8c2b7b0b@65.108.199.206:27656,23307798ac9ad05dd36e2eeef063d701b213cbbb@185.215.167.62:26656,bccc58a0b1a87a702b13b0e87c394120066b0ce8@138.201.130.234:26656,5a58fa951f65cd2381d0f9a584fbb76fdafc476c@45.10.154.139:18656,dae6ab8d1a8da0b87e94ceb83d08a324d2c2f7bb@79.137.203.226:26656,013c07456f39a2ca2de7ceb30ef9d0f2bc2f2d21@65.21.228.226:26656,81351ddd64122e553cf2c10efbd979c8c6e97529@161.97.166.105:26656,4a70de4fffde46382e70250c06f744570ce72ef9@138.201.124.93:26656,1d3df0877e2f75877f0f612e326876f895d02464@104.248.39.62:26656,5f3394bae3791bcb71364df80f99f22bd33cc2c0@95.216.7.169:60556,d622efcde775f33bd8c14fa5757ee9fa95d4149e@135.181.203.53:26656,7736aeb85e6dc91d0c952a25ab73b09da49d03ca@136.243.136.241:22656,4ae091976ef83403cbbb55345a1af0a06f3ef524@144.76.101.41:26656,d9bea9db5daa0e2be0c2ee9ccda5168fe80f12d3@45.85.249.73:26656,c7e5a2f8e127db2a4fe6f0c3bfbcd136be699004@89.117.59.158:26656,eddd4e1775b222e2d52f5207d35d4f28417d09ec@31.220.87.37:26656,7b71facfb46ccd860d4d71696b3a077676a6f2b5@65.109.166.8:26656,b6f2235952069566b0fe4372c46d90b1e5b0e6d3@154.12.249.208:26656,adcb0c33d521b5a26e83834454ed126988493573@95.216.74.4:26656,c275337a6ef175c0936cd2cc9506aaa5d2b5be69@43.156.112.38:26656,d0ce7b356e76298ea59aeb78397e9d84f0ed2480@31.220.88.180:26656,7398f4eb028075c1b82d5ede118537e1fc912459@95.217.128.120:29656,dbb23f85c41805578efe2186b98efe654a245ba8@135.181.250.35:29656"
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
curl https://snapshots2-testnet.nodejumper.io/nibiru-testnet/nibiru-itn-1_2023-04-02.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.nibid

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
