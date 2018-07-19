# Network Geth
This repository contains instructions on how to setup a private Ethereum network, using either the Ethash "Proof of Work" or Clique "Proof of Authority" consensus protocols.

Included are genesis files and accounts, with corresponding private keys, to allow the simple instantiation of an Ethereum network.

## Installation
The instructions are based on the tutorial of [Salanfe](https://hackernoon.com/setup-your-own-private-proof-of-authority-ethereum-network-with-geth-9a0a3750cda8) but has the more complicated parts already initialised.

First install an instance of go-ethereum and clone the repo.

Having cloned and entered the repo,
```
$ git clone git@github.com:maxrobot/network-geth.git
$ cd /path/to/network-geth
```
run the command
```
$ tree -L 2
```
returning if correct:
```
.
├── account1
│   ├── keystore
│   └── password-2be5ab0e43b6dc2908d5321cf318f35b80d0c10d.txt
├── account2
│   ├── keystore
│   └── password-8671e5e08d74f338ee1c462340842346d797afd3.txt
├── accounts.json
├── boot.key
├── genesis
│   ├── clique-multiple.json
│   └── clique-single.json
├── LICENSE
├── Makefile
└── README.md

```

The repository that comes with accounts defined as in `accounts.json`:
```
{
    "account": {
        "address": "0x2be5ab0e43b6dc2908d5321cf318f35b80d0c10d",
        "password": "password1"
    },
    "account": {
        "address": "0x8671e5e08d74f338ee1c462340842346d797afd3",
        "password": "password2"
    }
}
```


### Requirements
Prior to launching any Ethereum network users will need to download and install go-ethereum as either a [binary](https://geth.ethereum.org/) or as a (go package)[https://github.com/ethereum/go-ethereum].

Requirements:
    * golang version: 1.8.x

## Running a Network
All networks here are run with `--gasprice '0'`.

### Proof of Authority - Clique
The repository contains two separate instances of a Clique PoA network, with a one or two validators respectively.

#### Single Validator
Network files are found in the `/path/to/network-geth` directory. Enter the network-geth directory.
```
$ cd /path/to/network-geth
```
If a new chain is being instantiated the data directories must be initialised:
```
$ make clean
$ geth --datadir account1/ init genesis/clique-single.json
```

##### Start and Attach to the Nodes
Each node must be launched either as a background operation or on separate terminal instances. Thus from the network-geth directory for node 1 run:
```
$ geth --datadir account1/ --syncmode 'full' --port 30311 --rpc --rpcaddr 'localhost' --rpcport 8501 --bootnodes 'enode://dcb1dbf8d710eb7d10e0e2db1e6d3370c4b048efe47c7a85c4b537b60b5c11832ef25f026915b803e928c1d93f01b853131e412c6308c4c6141d1504c78823c8@127.0.0.1:30310' --networkid 1515 --gasprice '0' --targetgaslimit 0xFFFFFFFFFFFF --unlock '0x2be5ab0e43b6dc2908d5321cf318f35b80d0c10d' --password ./account1/password-2be5ab0e43b6dc2908d5321cf318f35b80d0c10d.txt --mine
```
then attach:
```
$ geth attach account1/geth.ipc
```
**Note:** IPC has been used to attach to the nodes, this allows the clique module to be used

#### Multiple Validators
```
$ cd /path/to/network-geth
```
If a new chain is being instantiated the data directories must be initialised:
```
$ make clean
$ geth --datadir account1/ init genesis/clique-multiple.json
$ geth --datadir account2/ init genesis/clique-multiple.json
```

##### Launch the Bootnode
Unlike the single validator instance when using multiple peers 
The boot node tells the peers how to connect with each other. In another terminal instance run:
```
$ bootnode -nodekey boot.key -verbosity 9 -addr :30310
$ INFO [06-07|12:16:21] UDP listener up                          self=enode://dcb1dbf8d710eb7d10e0e2db1e6d3370c4b048efe47c7a85c4b537b60b5c11832ef25f026915b803e928c1d93f01b853131e412c6308c4c6141d1504c78823c8@[::]:30310
```
As the peers communicate this terminal should fill with logs.

**Note:** bootnode requires a full go-ethereum [install](https://geth.ethereum.org/install/)

##### Start and Attach to the Nodes
Each node must be launched either as a background operation or on separate terminal instances. Thus from the network-geth directory for node 1 run:
```
$ geth --datadir account1/ --syncmode 'full' --port 30311 --rpc --rpcaddr 'localhost' --rpcport 8501 --bootnodes 'enode://dcb1dbf8d710eb7d10e0e2db1e6d3370c4b048efe47c7a85c4b537b60b5c11832ef25f026915b803e928c1d93f01b853131e412c6308c4c6141d1504c78823c8@127.0.0.1:30310' --networkid 1515 --gasprice '0' --targetgaslimit 0xFFFFFFFFFFFF --unlock '0x2be5ab0e43b6dc2908d5321cf318f35b80d0c10d' --password ./account1/password-2be5ab0e43b6dc2908d5321cf318f35b80d0c10d.txt --mine
$ geth --datadir account2/ --syncmode 'full' --port 30312 --rpc --rpcaddr 'localhost' --rpcport 8502 --bootnodes 'enode://dcb1dbf8d710eb7d10e0e2db1e6d3370c4b048efe47c7a85c4b537b60b5c11832ef25f026915b803e928c1d93f01b853131e412c6308c4c6141d1504c78823c8@127.0.0.1:30310' --networkid 1515 --gasprice '0' --targetgaslimit 0xFFFFFFFFFFFF --unlock '0x8671e5e08d74f338ee1c462340842346d797afd3' --password ./account2/password-8671e5e08d74f338ee1c462340842346d797afd3.txt --mine
```
then attach:
```
$ geth attach account1/geth.ipc
$ geth attach account2/geth.ipc
```
**Note:** IPC has been used to attach to the nodes, this allows the clique module to be used

