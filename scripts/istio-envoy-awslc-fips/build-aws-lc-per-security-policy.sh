#!/usr/bin/env bash
# Build AWS-LC FIPS 3.1.0 exactly per Security Policy #5314 section 11.1 (Amazon Linux 2023).
set -euxo pipefail
cd /w
sha256sum AWS-LC-FIPS-3.1.0.zip | tee sha256.txt
grep -q fe408fa438850786396faf79eba9ea4116c3802e60f3a95865f0dd2adb64c9f1 sha256.txt
cat /etc/os-release | head -3
yum -y groupinstall "Development Tools"
yum -y install cmake3 golang unzip || yum -y install cmake golang unzip
rm -rf aws-lc-AWS-LC-FIPS-3.1.0 && unzip -q AWS-LC-FIPS-3.1.0.zip
gcc --version | head -1; (cmake3 --version || cmake --version) | head -1; go version
cd aws-lc-AWS-LC-FIPS-3.1.0
mkdir build
cd build
CM=$(command -v cmake3 || command -v cmake)
$CM -DFIPS=1 ..
make -j"$(nproc)"
echo "ISFIPS=$(./tool/bssl isfips)"
ls -la crypto/libcrypto.a ssl/libssl.a
