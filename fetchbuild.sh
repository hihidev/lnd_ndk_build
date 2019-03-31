#! /bin/bash
set -e

repo=$1
commit=$2
target_host=$3
bits=$4
root_dir=$5

git clone $repo lnd
cd lnd
git checkout $commit

if [ "$bits" -eq "64" ]; then
	goarmarch="GOARCH=arm64"
else
	goarmarch="GOARCH=arm GOARM=7"
fi

export PATH=/opt/android-ndk-r19b/toolchains/llvm/prebuilt/linux-x86_64/bin:${PATH}
export PATH=$PATH:/opt/upx-3.95-i386_linux
export NDK_CC=${target_host}21-clang

sed -i -e "s~GOINSTALL := GO111MODULE=on go install -v~GOINSTALL := GO111MODULE=on CGO_ENABLED=1 CC=$NDK_CC GOOS=android ${goarmarch} go build -buildmode=pie -v~g" Makefile
sed -i -e 's~LDFLAGS := -ldflags "~LDFLAGS := -ldflags "-s -w ~g' Makefile

tags=linux make
tags=linux make install

upx -9 -q ./lnd
upx -9 -q ./lncli

if [ "$root_dir" == '/repo' ]; then
	repo_name=$(basename $(dirname ${repo}))

	tar -zcf /repo/lnd.tar.gz lnd lncli
fi