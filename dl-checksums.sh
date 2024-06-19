#!/usr/bin/env sh
set -e
DIR=~/Downloads
MIRROR=https://github.com/juicedata/juicefs/releases/download

dl()
{
    local ver=$1
    local lhashes=$2
    local os=$3
    local arch=$4
    local archive_type=${5:-tar.gz}
    local platform="${os}-${arch}"
    # https://github.com/juicedata/juicefs/releases/download/v1.1.2/juicefs-1.1.2-linux-amd64.tar.gz
    local file="juicefs-${ver}-${platform}.${archive_type}"
    local url="${MIRROR}/v${ver}/${file}"
    printf "    # %s\n" $url
    printf "    %s: sha256:%s\n" $platform $(egrep -e "${file}\$" $lhashes | awk '{ print $1 }')
}

dl_ver() {
    local ver=$1

    local lhashes="${DIR}/juicefs-checksums-${ver}.txt"

    # https://github.com/juicedata/juicefs/releases/download/v1.1.2/checksums.txt
    local url="${MIRROR}/v${ver}/checksums.txt"

    if [ ! -e "${lhashes}" ];
    then
        curl -sSLf -o $lhashes $url
    fi

    printf "  # %s\n" $url
    printf "  '%s':\n" $ver
    dl $ver $lhashes darwin amd64
    dl $ver $lhashes darwin arm64
    dl $ver $lhashes linux amd64
    dl $ver $lhashes linux arm64
    dl $ver $lhashes windows amd64
}

dl_ver ${1:-1.2.0}
