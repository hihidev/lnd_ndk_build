#!/bin/bash
set -e
export NDK_VERSION=android-ndk-r19b
export NDK_FILENAME=${NDK_VERSION}-linux-x86_64.zip

sha256_file=0fbb1645d0f1de4dde90a4ff79ca5ec4899c835e729d692f433fda501623257a

apt-get -yqq update &> /dev/null
apt-get -yqq upgrade &> /dev/null
apt-get install -y unzip wget xz-utils

mkdir -p /opt
cd /opt

wget https://github.com/upx/upx/releases/download/v3.95/upx-3.95-i386_linux.tar.xz
echo "962e29fc01490a2a2da25a170f28a5d5933f3d7a695e8b2807c3eab1a4b66d05  upx-3.95-i386_linux.tar.xz" | shasum -a 256 --check

tar -xJf upx-3.95-i386_linux.tar.xz

curl -sSO https://dl.google.com/android/repository/${NDK_FILENAME} &> /dev/null
echo "${sha256_file}  ${NDK_FILENAME}" | shasum -a 256 --check
unzip -qq ${NDK_FILENAME} &> /dev/null
rm ${NDK_FILENAME}

if [ -f /.dockerenv ]; then
    apt-get -yqq --purge autoremove unzip
    apt-get -yqq clean
    rm -rf /var/lib/apt/lists/* /var/cache/* /tmp/* /usr/share/locale/* /usr/share/man /usr/share/doc /lib/xtables/libip6*
fi
