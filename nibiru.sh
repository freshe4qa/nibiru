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
echo "export NIBIRU_CHAIN_ID=nibiru-testnet-1" >> $HOME/.bash_profile
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
git checkout v0.15.0
make install

# config
nibid config chain-id $NIBIRU_CHAIN_ID
nibid config keyring-backend test
nibid config node tcp://localhost:${NIBIRU_PORT}657

# init
nibid init $NODENAME --chain-id $NIBIRU_CHAIN_ID

# download genesis and addrbook
curl -s https://rpc.testnet-1.nibiru.fi/genesis | jq -r .result.genesis > $HOME/.nibid/config/genesis.json

# set minimum gas price
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0unibi\"/" $HOME/.nibid/config/app.toml

# set peers and seeds
SEEDS=""
PEERS="968472e8769e0470fadad79febe51637dd208445@65.108.6.45:60656,b32bb87364a52df3efcbe9eacc178c96b35c823a@nibiru-testnet.nodejumper.io:27656,5c30c7e8240f2c4108822020ae95d7b5da727e54@65.108.75.107:19656,dd8b9d6b2351e9527d4cac4937a8cb8d6013bb24@185.165.240.179:26656,cc78da5d7aadb085ec7835e90396b70c30bb5e02@194.233.85.199:39656,31b592b7b8e37af2a077c630a96851fe73b7386f@138.201.251.62:26656,714dd5d212a642bd20d931a0764303acf75d8f88@154.53.32.169:29656,5eecfdf089428a5a8e52d05d18aae1ad8503d14c@65.108.141.109:19656,7ddc65049ebdab36cef6ceb96af4f57af5804a88@77.37.176.99:16656,9007f52d9f46c581bf4a0fc6f4a108699caa4676@135.181.83.112:39656,5be94d5bfb2ac047c969b143c0d8f0c401b55961@194.163.141.50:26656,2fc98a228dee1826d67e8a2dbd553989118a49cc@5.9.22.14:60656,788c6a287dc7c9b406e5f0d7b8379d47ff65f693@38.242.234.72:26656,ff597c3eea5fe832825586cce4ed00cb7798d4b5@65.109.53.53:26656,ab5255a0607b7bdde58b4c7cd090c25255503bc6@199.175.98.111:36656,6369e3aefce2560b2073913d9317b3e9a0b06ab5@65.108.9.25:39656,16a5f0db538cafa0399c5a2b32b1d014b17932d4@162.55.27.100:39656,ccd5d612d1b1aeff8d412dc497eb3faf00a19030@43.156.10.6:26656,35d8f676cf4db0f4ed7f3a8750daf8010797bdc4@135.181.116.109:20086,0883145a35eaec47638c70decdf0e3a99751ccf9@194.163.171.130:39656,ac8e43ccbdf25be95d7b85178c66f45453df0c7d@94.103.91.28:39656,139f31fa2208513a8bb91b0b85b619dfdf6069c3@43.134.177.35:26656,1004b58a7925cec67a36e41222474e44f0719ff5@5.161.124.79:39656,e977310b55bf8d50644647d0e30f272eddac12e8@65.108.58.98:36656,db62a6994cca4f8716c5fbeec8fa1f37f66435b0@31.163.202.105:26656,c9dcc45a1c3183f0df5751da6f5f7ae6f08138fd@188.134.69.27:26656,e42accb6f1b2e7fb4c0e63154e4e7f175c9868a0@109.123.245.225:39656,6d889e913f670ebdeaf3aa19fbf747611e94eb59@45.94.209.252:39656,c5f3caef6a57b28b0a136c80c3b6165dd6d57fe2@65.109.27.156:26656,ca0a85a0145f91448cb3172195eb35de0ad668d8@128.199.141.153:26656,0a2419dd6c8a1c7e041f698495b11ba3c3cd4701@194.67.106.75:26656,d7c33fa15ad00c1773f225276980702a2619e645@65.21.237.241:46656,78d122192f7cb85c78303c16a4ceae0691012039@144.91.89.158:29656,c3efbf90e5d85b989dd4abc7314d00cb29814e32@80.82.222.221:39656,addb22e3f2e4e79bbbfdd9394b127e97fded623e@164.92.213.61:26656,8db425e1e80097c2281d35dad79de40e0c3ba033@154.53.40.178:26656,03010515fbba01893754eabe0f309866f3d68edf@85.114.132.101:26656,54b6aca5a55c84423d6885da79e95d267641e2bb@93.170.117.141:26656,5c38d58ce4a5960ca65ce0e8030d3d087254285f@167.235.145.85:26656,822611ebd0e93059eb3c5deadc4854b9fca29aa5@185.180.199.240:26656,2a3bbb85269425894be623e5f70453fd8a00313f@5.161.128.224:26656,e46dcf317312ec89a3c2fb1cc2e55d3fd9b20534@217.160.25.118:39656,ff40013f607581e2b3e754b8bec0f88d30f4691e@164.92.116.106:26656,ef22e4f853600eaafd00c62e4a058849ace64670@185.244.180.84:26656,4f2eba61778fa79b3abe98b21c9eda97a7e392b6@95.216.163.41:26656,3f294652d5ecac9497a9c3f8a96147bcf5ba43ec@95.111.238.216:26656,cef69c568708f49ebff69e980ebcf97b01379e55@8.219.198.12:39656,451d7c1cbc3bc0f075129c4524c4d7caa649c6a9@109.123.242.221:26656,e08dabf2adf7afc01d7c9ece805160b566b30db4@43.156.12.37:26656,59b8c9700e68851491b82f2e82bd7634c11fa410@65.21.237.156:26656,25c8f3c8ecf99c5d69c24df59701a2b78160baa1@109.123.241.32:26656,a2162bd42fdb011eb821d62fcaed3276142cf4d4@142.132.139.101:26656,7ab15fc4c8331fd4b0ea7c360b5b2687750eb92d@82.115.21.18:26656,6473c6d5fd1e946cd74b844c99bc8a9fd198c853@75.119.151.40:26656,095cc77588be94bc2988b4dba86bfb001ec925ff@135.181.111.204:26656,951489a291cd77b453169b8d959a3160c9972690@185.173.39.123:26656,ed32ab97e917e0c9f3149af0c1885d05fdcd7a96@45.77.8.217:26656,8b476c96819a53d0ca785abb9d265ece651b5f9f@88.210.3.30:39656,faa3bcc37a43c1a8de879650215417bf27039086@157.90.252.194:16656,95c69b390f7adfc23b682a420bc54f63741071ab@164.68.110.151:39656,6aee086dc69deb1e2bcc79a654cff6e36b94c8ab@178.63.8.245:46656,08585fd88bc658e2896d9c0d944f058be66e7d04@164.68.110.167:39656,e7ce67bf8a0294ebf4e585418168cf2d5074d1dc@95.216.196.140:36656,710e0dc1fbd020d61bfb32e3fab2763fba2ce146@185.135.137.249:26656,4c33eb73dec3d8a4da2c41f63e374cd5bdac5701@194.146.13.224:26656,cff0fec120a0026435f2a6203c9a92f7d8916f81@167.172.146.28:39656,18b0c561138b4a1e84c01315c09bfb866404c28a@135.181.223.165:39656,f8863b4e0afc4861183b5e1bc2de262dc672b82e@65.21.91.50:60856,de29ceedb6e7e7f1606c9b3ae9266da8d2e82d38@45.140.185.206:26656,433a3c1406efcdf53a244700bcff7c9d9a725ce7@199.175.98.120:26656,a0079a4ae9a17547a4f57d515d67f8d9ad94484f@149.102.146.142:39656,23804c5bdb618a81ffca0a308cc7f2fb10a2da06@194.35.120.162:26656,89ae2da5026aee3033e3c13d6296a276c7878867@157.90.205.183:26656,607721253f0b7275c5bf28bf2a244e5115282f67@144.126.138.161:29656,1275f7794724aeafdbe22c6d2aba722145111ce3@164.68.110.36:39656,b135db9dc9d4b95bfae4f1ffbe095a91442dc3dc@167.235.145.49:26656,e2d7153833930824626201a94bf5f93b1d9dba11@167.235.145.86:26656,2cd56c7b5d19b60246960a92b928a99d5c272210@154.26.138.94:26656,320c67f0183627315a70c944695152742d54243d@119.91.192.249:39656,9e3755210f471716f9cbafca4f7bdbfdff25fb83@194.67.106.72:26656,e10b69acdff34054d9c41a5a11c30b4105d14a93@20.121.120.173:39656,f1001582f5c0b9b67e220d1d53432333917d247d@62.171.149.136:39656,509d6bfee12d4ff10f754fb7af4f0058f7c426b7@185.214.134.89:26656,573946fee0377eb9448bfb7cb731ffbb41b2b078@38.242.214.172:2486,bd933da5925e386776fc6bcaeb604c6d54f14fc5@45.85.250.65:39656,7a462d07fbba56aa773a105aba232916395cd184@167.86.115.153:16656,6692cf5cc5ad3568d3195a5b009f5d6b05ccfc82@135.181.178.53:28656,fe4e8a0688820808981aefda5c12fe41bba8e54a@78.47.141.222:26656,cbf8aaac7644050c8d13030ae7fe26b602aea821@195.201.164.125:28656,436d07e831f6399d893d22a1048c0cc759ae6e47@128.199.116.94:39656,d5db3e07270dcfd98fe5f4e9def17c4e9cc2f1d8@89.163.155.216:26656,0c44502d84add3366dc98ed96e162c9120e7b18b@167.235.206.164:26656,8641bef617e5b38290be2eee2ea031a36855c901@65.108.216.139:26656,6feab732832b06516795938d585d1b77dc7ebbe4@154.53.54.11:29656,6a92105f6a391d05af6cff5ecb6c74dd65748312@38.242.202.178:26656,7633f5845c9d738e34315393ffb5bf1315549857@43.155.117.14:26656,65e7b45e919bac536e998119d80a16a807bdce5b@213.202.231.29:26656,932ceb4e66f2d926acfd2c7c5a26a08f07e19231@20.247.94.106:39656,658aad14a81925c8d8eeb13ebafb883bac0855ec@91.122.47.36:26656,67fa991e201f4088fc711336aff66e24b1cf5e2b@65.108.129.104:21656,afe1a8d392b2caaa02c51165dd2b37e0181dacf9@65.108.72.233:21656"
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.nibid/config/config.toml

# disable indexing
indexer="null"
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/.uptickd/config/config.toml

# config pruning
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="50"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.nibid/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.nibid/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.nibid/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.nibid/config/app.toml

# set custom ports
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${NIBIRU_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${NIBIRU_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${NIBIRU_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${NIBIRU_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${NIBIRU_PORT}660\"%" $HOME/.nibid/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${NIBIRU_PORT}317\"%; s%^address = \":8080\"%address = \":${NIBIRU_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${NIBIRU_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${NIBIRU_PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${NIBIRU_PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${NIBIRU_PORT}546\"%" $HOME/.nibid/config/app.toml

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
  --amount 2000000unibi \
  --from $WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(nibid tendermint show-validator) \
  --moniker $NODENAME \
  --chain-id $NIBIRU_CHAIN_ID
  
break
;;

"Exit")
exit
;;
*) echo "invalid option $REPLY";;
esac
done
done
