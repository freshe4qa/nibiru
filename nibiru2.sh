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
NIBIRU_PORT=39
if [ ! $WALLET ]; then
	echo "export WALLET=wallet" >> $HOME/.bash_profile
fi
echo "export NIBIRU_CHAIN_ID=nibiru-testnet-2" >> $HOME/.bash_profile
echo "export NIBIRU_PORT=${NIBIRU_PORT}" >> $HOME/.bash_profile
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
git clone https://github.com/NibiruChain/nibiru.git
cd nibiru
git checkout v0.16.3
make install

# config
nibid config chain-id $NIBIRU_CHAIN_ID
nibid config keyring-backend test
nibid config node tcp://localhost:${NIBIRU_PORT}657

# init
nibid init $NODENAME --chain-id $NIBIRU_CHAIN_ID

# download genesis and addrbook
curl -Ls https://snapshots.kjnodes.com/nibiru-testnet/genesis.json > $HOME/.nibid/config/genesis.json
curl -Ls https://snapshots.kjnodes.com/nibiru-testnet/addrbook.json > $HOME/.nibid/config/addrbook.json

# set minimum gas price
sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"0.025unibi\"|" $HOME/.nibid/config/app.toml

# set peers and seeds
SEEDS=""
PEERS="b32bb87364a52df3efcbe9eacc178c96b35c823a@nibiru-testnet.nodejumper.io:27656,d256380b9344798396e8b1a9c6985f4553a2e0ca@38.242.219.209:26656,52dacee88cf2b6dc8f6e2c1876880bf370796e72@185.219.142.214:39656,32ba0f7eb69b7b984281b1b189bf1aa022915776@142.132.128.132:36656,858ddaf58e566918591802ba04ce3647c5b01707@65.109.106.91:15656,3c68ddbae55f3279efc8a6948cb77cefa384d7b6@5.161.105.29:39656,35b0fd0c923fe48bc44f5af70e999982c2c4bb9b@45.8.133.179:26656,e8633047d8eeebcfcb54f67e9f980c74cad91ed3@217.76.49.64:26656,bd5ec98a09b278a01f1f1a201ba22eea807d2731@65.21.170.3:36656,38d128d24e7d9cbdd80227004a7ca0fa129109b5@65.109.92.148:60656,2ec6cb2a83c178fb490a992a3bd6a5c142c3fc61@135.181.20.30:26656,140221bb147d287a11e6abeb0649c78f8bef2a08@65.109.160.183:12656,ae0036bf4c7d33412a655b036d5bfd37a2aa1b72@65.21.237.241:46656,80030d5945eef7519407d047479d40a2f2bf1fe6@65.109.92.241:11036,977da259c89314700aaadbbe1d9d4da1a50bf643@194.163.135.104:26656,98032241ea61ca6ac066b8fa508baace6678a7a3@190.2.155.67:26656,83626d07e25f75431d09a2d8efe7843128673f5a@65.109.85.170:35656,8ff8d3effc84c1e5d7bdff36d8921875f7436bcd@65.108.13.185:26858,c08c4d5060697a644838403329be5742bdb4c67f@65.109.92.240:11036,c7f3b61275dc16993c39a1ebc9f6cb5895d11d56@148.251.43.226:46656,7643ed772567e8e69ec1dab94bbdb848043d49f2@34.138.219.117:26656,d67d2bae772c3d44123a7495d56c568a185717f8@213.239.216.252:27656,4028996039d167bfff0590c93fecd950b70c7545@144.126.152.61:26656,32c587c3d9329e6c13c5cd7797eb46b30b628bca@95.217.211.70:12656,bfe4fc33622ca87f9dca188d4a205091b2bd5587@194.163.131.165:26656,0e6b2ec046c7652437a4ae9929dc72782e3ff215@149.28.95.188:26656,95fc1114efeb871c8c28e575923f673ab5b4dba6@109.123.241.109:26656,72a84166fbd6b92d8a772843026cf6a2cd97ffbe@65.109.60.19:46656,dea9b447412e84a576ed174a748449be26a3e847@65.109.81.119:39656,676a3ce38875bc0ff3a507c507fafa958b9115d0@5.75.136.149:26656,db8f75471ac073b201e0bd56bdaf1bd6c3760c5c@65.109.87.135:13656,b59cb14086b4861eaef6ba9bb335bd44b0f76119@161.97.150.231:26656,3ab57cd651641e80ce82c7b046931bacf638d3f0@167.235.204.231:26656,baf08cf4803c8a5f7d8d026edf65847ae9f29904@85.190.254.137:26656,d2f74fce9d5f33664ebec534b2557a94e67b5232@154.53.59.87:39656,d1f7c37c2df69166e1ffa2ed1b5870427cd17479@23.92.69.78:27656,4537639e8685efe2382c6de93c25eb4f2cca91f9@207.244.239.218:26656,8d22a2251a5fe84ac136bb7aaada10842d121d43@94.250.252.208:26656,e08089921baf39382920a4028db9e5eebd82f3d7@142.132.199.236:21656,51fa995380dad2abf39b828aeb1d0a710a0029f6@80.79.6.64:26656,e67a32bac3086bced94e28d4489f005a4ce48fca@185.244.180.84:39656,c72e69f79dddf63d5c5d8fda2777d313500e8264@82.208.22.68:26656,c484bcbd2045a63dd6d943319179e856041182e3@142.132.151.35:15652,45a72fda58fcc7d0e1c30271d672884778d3b3da@88.210.6.216:12656,c7ca297adbaa2bb780f6940ad06ca4c1e25bbe01@31.187.74.92:26656,661997f7ab26f6242e95c1336b181e2772c678f5@149.102.142.87:39656,ca26556668b867571d4960bca6c52ada0a7a73c3@146.190.33.56:26656"
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.nibid/config/config.toml

# config pruning
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.nibid/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.nibid/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.nibid/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.nibid/config/app.toml

# set custom ports
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:39658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:39657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:39060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:39656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":39660\"%" $HOME/.nibid/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:39317\"%; s%^address = \":8080\"%address = \":39080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:39090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:39091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:39545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:39546\"%" $HOME/.nibid/config/app.toml

# enable prometheus
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/.nibid/config/config.toml

# reset
nibid tendermint unsafe-reset-all --home $HOME/.nibid

# create service
sudo tee /etc/systemd/system/nibid.service > /dev/null <<EOF
[Unit]
Description=nibi
After=network-online.target
[Service]
User=$USER
ExecStart=$(which nibid) start --home $HOME/.nibid
Restart=on-failure
RestartSec=3
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF

rm -rf $HOME/.nibid/data 

SNAP_NAME=$(curl -s https://snapshots3-testnet.nodejumper.io/nibiru-testnet/ | egrep -o ">nibiru-testnet-2.*\.tar.lz4" | tr -d ">")
curl https://snapshots3-testnet.nodejumper.io/nibiru-testnet/${SNAP_NAME} | lz4 -dc - | tar -xf - -C $HOME/.nibid

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
  --amount 1000000unibi \
  --from $WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.20" \
  --commission-rate "0.05" \
  --min-self-delegation "1" \
  --pubkey  $(nibid tendermint show-validator) \
  --moniker $NODENAME \
  --chain-id $NIBIRU_CHAIN_ID \
  --fees=5000unibi
  
break
;;

"Exit")
exit
;;
*) echo "invalid option $REPLY";;
esac
done
done
