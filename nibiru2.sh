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
PEERS="b32bb87364a52df3efcbe9eacc178c96b35c823a@nibiru-testnet.nodejumper.io:27656,b57a9c1e7c0f597c9ef6a47cc361094f95a22b84@192.9.134.157:27656,72a84166fbd6b92d8a772843026cf6a2cd97ffbe@65.109.60.19:46656,68874e60acc2b864959ab97e651ff767db47a2ea@65.108.140.220:26656,da2eb560cececf861f913629bdeca9f6d72cb74f@192.145.37.152:46656,d5be677e173575164626095210a856c7c2a4db10@65.108.209.79:26656,52479319f5c8c7d540fd8f6b0d91c9f34164bdce@107.155.109.202:31656,d071e951efba77df337f1fe153322d4449e01451@95.216.65.177:36656,2cb1fdc3d01fce95114e0b0bdfd2c8cecb9a88fe@185.135.137.223:26656,f7658c7d0625906c906ec6857e64bf1cb545bc39@95.216.136.130:26656,ce8e7a377ab0517c84a73a894a9e50b793f4e3a0@46.101.205.93:26656,988b3c25c83076e0fc582811ef0bfa02240241d0@5.78.58.199:26656,ea150128fbfcac82e74821b03212c210ab2192d3@154.53.53.60:26657,2d59debfed97c4d0d24ebfe352440b82d8b5a8ad@195.201.237.198:38656,c8c4a6b56105340c119f9e16564de28e91960806@49.12.134.171:46656,9ba9cea2cfd081d05fc603cb3dcf091bf1c28feb@79.137.33.26:26656,9920bfdee1f9f61221e0301b1823f050e8fb992f@193.203.203.121:26656,98032241ea61ca6ac066b8fa508baace6678a7a3@190.2.155.67:31656,3939da5da8d8a31e6af2cb6d7bdcb222ff2487eb@65.109.14.69:39656,8279945c6b0b6382274b69cb8b006c56a7eb7de0@82.146.32.254:26656,da4fde3ce759598baea41212d0f78369705716f5@135.181.253.11:23656,178f7dd47502283f9245d24ffcc0a0acc9f661cc@135.181.145.58:26656,0fc167f54fc0d63369763b1519e79c3b400c4bb4@65.108.97.58:2486,2f35fb311c84dae1ac0a6ec4928307769983fa1f@154.53.44.216:26657,bd0117a9200937887d854b14a7ea53f7ba2c81ea@185.245.183.192:46656,d335ca079b980c51eea7cfcf44244ea7b6a4807b@45.89.127.102:26656,888f65c496c3cb5ca345d227e01996506a52f65e@185.209.223.127:39656,bef7f536be357a2d69c643128c7f1c8245b76809@65.21.91.50:26656,cb402df94e1b121a840cd29f5a346f85f36a4900@155.133.22.141:39656,0184ae5d296547d6e666a24873d4a7ad490721b6@65.108.238.217:11134,26a543448a3313893247adb18481f79d5cf2ddfd@167.86.96.173:26656,c9972ca6cce8355cbf78f4178eb54202968a5779@65.109.167.27:26656,cda3b437970f8a4db6c7503926fdb99da3dde743@129.146.80.192:27656,33e3ccadfcfc4878ba49b9491a3ccbbb65f19367@144.91.88.213:27656,f676e1e1896a2e0934a83362512dccd0b4eaac22@109.206.131.213:40656,35ddc448031492cf13325b92b2cd49200f3faa1c@157.90.208.222:46656,b9322d39e94965820af2bfc42a1501d5ff3951e0@65.108.86.199:26656,2a9278b97c64580cff5949546c79156f7865c302@172.105.115.16:26656,de23c79226f40b91b03af5610635c5eefcc6655e@142.132.248.253:26656,8fc35f8c603f2d7752ad3af0a93b12beffc556bb@144.76.30.36:15652,73c2805511a8fb700eae740299005c2ff33ec855@45.89.127.44:26656,061c45b1253416dca8fd678b7e421061b151f9d2@65.108.46.177:46656,891b4ef95905ad6bbf8e9274feb5c3897c51c078@65.108.226.111:36656,bd5ec98a09b278a01f1f1a201ba22eea807d2731@65.21.170.3:36656,c31bebbb86e3c439b98dceea4c6485ce54e81d68@38.242.234.180:26656,58ca7c649728e82dbfac5805117dcb3e5e253582@135.181.254.224:26656,5ad114dc1c121f4a286d9e1b36ed7f3a8b7a2eed@109.123.252.190:26656,38d128d24e7d9cbdd80227004a7ca0fa129109b5@65.109.92.148:60656,e2b8b9f3106d669fe6f3b49e0eee0c5de818917e@213.239.217.52:32656,53b08686f6882a77a462f06616edb77cbff9980d@142.132.253.112:13656"
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
