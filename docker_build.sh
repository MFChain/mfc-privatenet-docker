#!/bin/bash
set -e

# To use a newer mfc-cli version, just update this variable:
MFC_CLI_VERSION="2.7.6.1"

function usage {
    echo "Usage: $0 [--no-cache] [--mfc-cli <zip-fn>]"
}

while [[ "$#" > 0 ]]; do case $1 in
    -h)
        usage
        exit 0
        ;;
    --no-cache)
        DISABLE_CACHE=1
        shift
        ;;
    --mfc-cli)
        # Custom mfc-cli zip filename
        MFC_CLI_CUSTOM_ZIPFN=$2
        if [[ -z $MFC_CLI_CUSTOM_ZIPFN ]]; then
            echo "Error: Please specify a mfc-cli zip file"
            usage
            exit 1
        fi
        echo "Custom mfc-cli zip: $MFC_CLI_CUSTOM_ZIPFN"
        shift; shift
        ;;
    *)
        usage
        exit 1
        ;;
  esac;
done

# Definition of standard mfc-cli filenames and URL based on the version
MFC_CLI_ZIPFN="mfc-release-${MFC_CLI_VERSION}.zip"
MFC_CLI_URL="https://github.com/MFChain/mfc-cli/releases/download/v${MFC_CLI_VERSION}/mfc-cli-linux-x64.zip"

if [ -z "$MFC_CLI_CUSTOM_ZIPFN" ]; then
    echo "Using downloaded mfc-cli v${MFC_CLI_VERSION}"

    if [ -e "${MFC_CLI_ZIPFN}" ] && [ -z "$DISABLE_CACHE" ]
    then
        echo "- release already downloaded: ${MFC_CLI_ZIPFN}"
    else
        echo "- downloading ${MFC_CLI_URL}..."
        wget --no-check-certificate -O $MFC_CLI_ZIPFN $MFC_CLI_URL || (rm -f $MFC_CLI_ZIPFN && exit 1)
    fi
    cp $MFC_CLI_ZIPFN ./mfc-cli.zip
else
    echo "Using custom mfc-cli.zip: $MFC_CLI_CUSTOM_ZIPFN"
    cp $MFC_CLI_CUSTOM_ZIPFN ./mfc-cli.zip
fi

if [ -z "$DISABLE_CACHE" ]; then
  docker build -t mfc-privnet .
else
  echo "docker build no cache"
  docker build --no-cache -t mfc-privnet .
fi
