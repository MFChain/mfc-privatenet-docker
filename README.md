# mfc-privatenet-docker

This is a convenient way to run a private MFC blockchain. The image is based on microsoft/dotnet:2.0-runtime,
please review Dockerfile for details.

This image is meant to skip the overhead of having to wait to get enough gas for smart contract testing on testnet and to bypass the steps of creating your own private chain.

See the section below on extracting MFF and Gas as the private chain in this Docker image starts at block height 0.

You will also need to install and configure your MFC client to use this private network, which involves editing the protocol.json file to point the seeds at your docker IP addresses.

## Instructions to build the image yourself

Clone the repository and build the Docker image:

    git clone https://github.com/MFChain/mfc-privatenet-docker.git    
    cd mfc-privatenet-docker
    ./docker_build.sh

`docker_build.sh` has a few possible arguments:

* Disable Docker image caching with `docker_build.sh --no-cache`
* Use a custom mfc-cli zip file `docker_build.sh --mfc-cli <zip-fn>`
* Show the help with `docker_build.sh -h`

After the image is built, you can start the private network like this:

    ./docker_run.sh

Start the private network, create a wallet and automatically claim the initial MFF and 48 GAS (takes about 5 minutes):

    ./docker_run_and_create_wallet.sh

_or_, if you prefer `docker-compose`, you can start the nodes with:

    docker-compose up -d

You can now claim the initial MFF and GAS:

    ./create_wallet.sh

`./create_wallet` will display several internal error messages, which is expected as long as at the end you still get a success message.

If you call `./create_wallet.sh` or `./docker_run_and_create_wallet.sh`, it will create 2 files in your current directory:

- `mfc-privnet.wallet`: a wallet you can use with neo-python
- `mfc-privnet.wif`: a wif private key you can import into other clients (mfc-gui for example).

Those files will get you access to the wallet containing all the MFF and GAS for your private network.

## Install neo-gui or neo-gui-developer

Install one of the following:

https://github.com/neo-project/neo-gui

https://github.com/CityOfZion/neo-gui-developer

Edit the protocol.json in your respective neo-gui installation to point to the IP of the system running your docker.
Please note the ports listed match the private chain ports in the current docker build.

If you copy the protocol.json file from the configs directory of this repo and replace your neo-gui protocol.json you will only need to find and edit the section that looks like the following:

"SeedList": [
    "127.0.0.1:20333",
    "127.0.0.1:20334",
    "127.0.0.1:20335",
    "127.0.0.1:20336"
],

Change each occurrence of 127.0.0.1 to the IP of the system or vm running your docker image.

If you don't copy the protocol.json from the docker configs directory of this repo, in addition to the "SeedList" modifications mentioned above, you will also need to edit the following:

1. Change value "Magic" to 56753
2. Copy the public keys of each of your node wallets into the "StandbyValidators" section

---

##### For users who use docker machine (i.e Windows Home Edition users without Hyper-V)

 You'll need your docker machine IP. First, get the name of your machine:

    docker-machine ls

And get the ip with:

    docker-machine ip "Nameofyourmachine"

(By default, the machine name is "default"). Use this ip to replace each occurence of 127.0.0.1 in the SeedList array.

## Copy wallets from docker image to mfc-gui

Note: You won't need this step if you used `./create_wallet.sh` or `./docker_run_and_create_wallet.sh` in the previous step (The multiparty signature and mff/gas extraction should already be done).

Once your docker image is running, use the following commands to copy each node's wallet to your neo-gui home directory in preparation for multiparty signature and mff/gas extraction.
Note: all four must be copied.

The following will copy each wallet from the docker image to the current working directory.

    docker cp mfc-privnet:/opt/node1/mfc-cli/wallet1.json .
    docker cp mfc-privnet:/opt/node2/mfc-cli/wallet2.json .
    docker cp mfc-privnet:/opt/node3/mfc-cli/wallet3.json .
    docker cp mfc-privnet:/opt/node4/mfc-cli/wallet4.json .

## Wallet Passwords

node1: one

node2: two

node3: three

node4: four

## Extracting MFF and Gas
Check out the docs at https://mfchain.com/en-us/node/private-chain.html for instructions on how to claim MFF and Gas for testing.
