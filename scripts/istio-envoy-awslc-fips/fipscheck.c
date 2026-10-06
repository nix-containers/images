// Links the exact libcrypto.a that Bazel linked into envoy and reports module identity.
#include <stdio.h>
#include <openssl/crypto.h>
#include <openssl/service_indicator.h>
int main(void) {
  printf("FIPS_mode()              = %d\n", FIPS_mode());
  printf("awslc_version_string()   = %s\n", awslc_version_string());
  printf("OpenSSL_version()        = %s\n", OpenSSL_version(OPENSSL_VERSION));
  printf("BORINGSSL_integrity_test = %d\n", BORINGSSL_integrity_test());
  return FIPS_mode() == 1 ? 0 : 1;
}
