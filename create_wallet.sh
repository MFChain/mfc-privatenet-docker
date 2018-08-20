#!/bin/bash
echo "Starting script to claim MFF and GAS..."
CLAIM_CMD="python3.6 /neo-python/claim_mff_and_gas_fixedwallet.py"
DOCKER_CMD="docker exec -it mfc-privnet ${CLAIM_CMD}"
echo $DOCKER_CMD
echo
($DOCKER_CMD)

echo
echo "Copying wallet file and wif key out of Docker container..."
docker cp mfc-privnet:/tmp/wif ./mfc-privnet.wif
docker cp mfc-privnet:/tmp/wallet ./mfc-privnet.wallet

echo
echo "--------------------"
echo
echo "All done! You now have 2 files in the current directory:"
echo
echo "  mfc-privnet.wallet .. a wallet you can use with neo-python (pwd: coz)"
echo "  mfc-privnet.wif ..... a wif private key you can import into other clients"
echo
echo "Enjoy!"
