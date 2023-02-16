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
PEERS="b32bb87364a52df3efcbe9eacc178c96b35c823a@nibiru-testnet.nodejumper.io:27656,1d5f4f0313cad96580cb350bf4992d53412714da@185.245.183.190:26656,7f8bd4eaf6b9b213fd7b89ceefc517bcaa517d24@5.9.147.22:22656,224c85918ea98d62daab63ba9eceab195b676760@144.91.71.1:26656,62f26443c930a02f3e166b9db4ecd37b65b042f2@49.12.8.255:26656,ae0036bf4c7d33412a655b036d5bfd37a2aa1b72@65.21.237.241:46656,bcceb73119b08bdaf83121f11a00121cbcbbfe59@185.135.137.244:26656,c101b872586f96f0879143651471bafdff611aa5@167.86.112.234:26656,507e09ffa4899d931de427fd7747c34f46cfb5ab@95.216.156.7:26656,03db976e747df6312b1ee6dc0bd2ad9123348127@65.108.226.26:28656,b28b1488f769acc32d7f4a9dae1d9b4e1d6ba2b8@138.201.53.44:26656"
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
