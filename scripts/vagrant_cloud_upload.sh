#!/usr/bin/env bash
# Simply a wrapper for "vagrant cloud publish command"
# uploads a virtualbox box package to vagrant cloud and releases it.

BOX="slavrd/golang"
BOX_PATH="output-ubuntu-golang/package.box"
BOX_DESC="An Ubuntu box with golang and some basic tools installed"

#usage <vc_box_ver>

# check prerequsites - passed parameters and vagrant installation
if [ "$1" ]; then
    BOX_VER=${1}
else
    BOX_VER=$(date +%y.%m.%d)
fi 

which vagrant > /dev/null || {
    echo "vagrant is not installed. Visit www.vagrantup.com and install it."
    exit 1
}

vagrant cloud publish \
    -s "${BOX_DESC}" \
    --description "${BOX_DESC}" \
    --force --release \
    ${BOX} ${BOX_VER} virtualbox ${BOX_PATH}
