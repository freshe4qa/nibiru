# Manual node setup
If you want to setup fullnode manually follow the steps below

## Setting up vars
Here you have to put name of your moniker (validator) that will be visible in explorer
```
NODENAME=<YOUR_MONIKER_NAME>
```

Save and import variables into system
```
echo "export NODENAME=$NODENAME" >> $HOME/.bash_profile
if [ ! $WALLET ]; then
	echo "export WALLET=wallet" >> $HOME/.bash_profile
fi
echo "export NIBIRU_CHAIN_ID=nibiru-itn-1" >> $HOME/.bash_profile
source $HOME/.bash_profile
```

## Update packages
```
sudo apt update && sudo apt upgrade -y
```

## Install dependencies
```
sudo apt install curl build-essential git wget jq make gcc tmux chrony -y
```

## Install go
```
if ! [ -x "$(command -v go)" ]; then
  ver="1.18.2"
  cd $HOME
  wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
  sudo rm -rf /usr/local/go
  sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
  rm "go$ver.linux-amd64.tar.gz"
  echo 'export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin' >> ~/.bash_profile
  source ~/.bash_profile
fi
```

## Download and build binaries
```
cd $HOME && rm -rf nibiru
git clone https://github.com/NibiruChain/nibiru
cd nibiru
git checkout v0.19.2
make install
```

## Config app
```
nibid config chain-id nibiru-itn-1
nibid config keyring-backend test
```

## Init app
```
nibid init $NODENAME --chain-id nibiru-itn-1
```

## Download genesis and addrbook
```
curl -s https://rpc.itn-1.nibiru.fi/genesis | jq -r .result.genesis > $HOME/.nibid/config/genesis.json
curl -s https://snapshots2-testnet.nodejumper.io/nibiru-testnet/addrbook.json > $HOME/.nibid/config/addrbook.json
```

## Set seeds and peers
```
SEEDS=""
PEERS="a1b96d1437fb82d3d77823ecbd565c6268f06e34@nibiru-testnet.nodejumper.io:27656,39cf8864b1f1655a007ece6c579b290a9132082b@65.109.143.6:26656,19f6588df6e489a3e512ebac805c5250cdc9fbb7@84.46.249.14:26656,4910f38f7543dc97a9cfd2e820931ea0b70e00da@135.181.215.116:25656,b9389bfc008335f55c4ee252795e9c2f5d1236ed@49.12.43.94:29656,0a64c3212b135ff92d9d26305e764da5b37dc006@109.123.243.158:26656,11c7655bc96c229a3d18ca3bbe7d8944ce645aab@89.117.59.191:26656,408bfd8b902a1e688c068dae1d247b7324dd240d@185.193.67.136:27656,2dce4b0844754b467ae40c9d6360ac51836fadca@135.181.221.186:29656,65a213efcad697afb5a1303c7fe5be4168d9520c@43.154.103.36:26656,4a7065cb42272653779f41e1a9e63911743e8185@31.220.85.198:26656,8e471a078b929944d3812c44e7babe06fb32b527@178.18.249.99:26656,1c7735c89d8afa3a3adb1353df8a34cd7dcc6f77@78.46.135.37:26656,fc1cac088cad21e1572b80731d2efdff9f09470f@38.242.142.67:26656,982b9b071070f70bf58c41c0ecc8547ff87ba477@81.0.218.96:26656,6bb413df2b72cc61860f1dc06c61d59a23f14e00@65.109.32.139:26656,091ef5d449922e6de2b42039505bbd1c06a3cdc6@194.163.139.34:26656,f8ddd8555ce6837fec0b64e28daa80851bd98723@148.251.43.226:21656,958281e2c828ab54c5c828557becbdad3f346ffb@65.109.87.135:35656,4ae091976ef83403cbbb55345a1af0a06f3ef524@144.76.101.41:26656,a74ec7c34c10f1b2bfe360e595c7242b1e06d888@47.242.41.172:26656,1006710e216396697caf72a561498d1da1f563b4@81.0.218.86:26656,4ae7eeab8b1ec28e9a71365984dbc7fbfbefbdfe@89.163.146.199:26656,c83d16ddab9e16f61e553583f1589b9d24b7e6ac@31.220.87.238:26656,7e65b9d88cbf392906dad41ce9adba774912d60e@185.209.230.187:26656,d0ce7b356e76298ea59aeb78397e9d84f0ed2480@31.220.88.180:26656,e1cb0df376c0f88169cb203b304d7cf26b87d1a3@149.102.158.241:26656,f6626088ab596483d36f44b62f409a35a31757d6@81.0.218.141:26666,9086ceeeb979a8a3f6372a20e61b4d91dce9885c@185.215.165.159:26656,91ad1995b05111c8f9c43cdc7f801bd202de082d@62.171.172.94:26656,ed635eb28d417674a5f551f088772367622e7c92@138.68.99.211:26656,0cbe6d28190e5fee5f41071a622861e378421d16@161.35.17.234:03656,bfa223fc563019d95885b5ef3113011eafea387f@66.94.108.92:26656,d39e7451f84c3918860954f66ce473cca70ab70e@209.250.242.119:26656,0f8ea9f1dacc680e7074e8019bae16b1e8979977@89.117.58.243:26656,d8653d56d8914e5a26d7ff2f2f930dc44d593e1e@38.242.232.142:26656,13cc216c7c2c29783fae084062f10c68f2999d83@91.229.245.201:26656,563b3993420bcbb7226ac1f50ce6cbf9497de1c8@66.94.101.5:26656,02b8386250919fd9b054504eb6dfcd7dd65b5781@65.21.249.114:26656,8d3454b59a677665616d6ad9ee657b02580c8e97@46.101.16.102:26656,4a70de4fffde46382e70250c06f744570ce72ef9@138.201.124.93:26656,1eceb9c1dde5b66693f48eb0830bc8781deee3f3@161.35.19.181:26656,5544f891f1d3676c57809f7d72dcccd2cd15279e@89.163.157.93:39656,7e791abaa171405b699f7a70faed4462212c9f5b@65.21.138.123:29656,3a5d2bd306d6a0b842e5b14dfd1fc5a1069b55d1@14.162.196.251:20156,59816aa7410a331e82014555ff40eb26e86fff44@161.97.166.136:26656,d3dedce485a38433a14faa5ee09e08b23e5e5a03@109.123.244.57:26656,ec225abef682fa50f987d0c71573ec69a5e6ad97@86.48.30.243:26656,62ac888bf5af9b3a3fc3b32400fc9108f81a24da@77.120.115.141:39656,24d4d29dd2780b30fdf5772b39d2103aa225342d@93.183.211.195:26656,5376d83843b4f52501c1e8929e68e1fc89a0c761@92.243.165.37:26656"
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.nibid/config/config.toml
```

## Config pruning
```
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
```

## Set minimum gas price and timeout commit
```
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.0001unibi\"/" $HOME/.nibid/config/app.toml
```

## Enable prometheus
```
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/.nibid/config/config.toml
```

## Reset chain data
```
nibid tendermint unsafe-reset-all
```

## Create service
```
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
```

## Register and start service
```
sudo systemctl daemon-reload
sudo systemctl enable nibid
sudo systemctl restart nibid && sudo journalctl -u nibid -f -o cat
```
