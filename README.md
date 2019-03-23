## Run Locally

**Bootnode:**
```sh
bootnode -nodekey boot.key -verbosity 9 -addr :30310
```

**Node 1 (Miner):**
```sh
geth \
  --datadir node1/ \
  --syncmode 'full' \
  --port 30311 \
  --rpc --rpcaddr 'localhost' --rpcport 8501 \
  --rpcapi 'personal,db,eth,net,web3,txpool,miner' \
  --bootnodes 'enode://abab5bae9e6fe74793eb1346a76108b47a112384235ee33070a48f1b3ee1049b79188bda42cf29138b356a3ab883b8615533ba4b591f6e661544c8d3b6eb69ce@127.0.0.1:30310' --networkid 1488 \
  --miner.gasprice 0 --txpool.pricelimit 0 \
  --unlock '0xe6bb974d1943b99daf64337b4dc5f3e751269890' --mine \
  --password node1/pwd
```

**Node 2:**
```sh
geth \
  --datadir node2/ \
  --syncmode 'full' \
  --port 30312 --rpc --rpcaddr 'localhost' --rpcport 8502 \
  --rpcapi 'personal,db,eth,net,web3,txpool,miner' \
  --bootnodes 'enode://abab5bae9e6fe74793eb1346a76108b47a112384235ee33070a48f1b3ee1049b79188bda42cf29138b356a3ab883b8615533ba4b591f6e661544c8d3b6eb69ce@127.0.0.1:30310' --networkid 1488 \
  --unlock '0x45a30fddf3ee361b4aeaf864aec6dc5840235640' \
  --password node1/pwd
```

**Geth Console:**
(port 8501 or 8502)
```sh
geth attach http://localhost:8501
```
