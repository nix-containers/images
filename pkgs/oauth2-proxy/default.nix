{ lib, fetchFromGitHub, buildGoModule }:

# https://github.com/oauth2-proxy/oauth2-proxy

buildGoModule rec {
  pname = "oauth2-proxy";
  version = "7.15.4";

  src = fetchFromGitHub {
    owner = "oauth2-proxy";
    repo = "oauth2-proxy";
    rev = "v${version}";
    hash = "sha256-G1luz0CjcAGMCFBzMQMA18mPh02lwQMV4CwSWDCq1gA=";
  };

  vendorHash = "sha256-o4JWhqLbfHmlIY1XhaupIhYLfXJNguFueH+SpAe9xaw=";

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s" "-w"
    "-X main.VERSION=${version}"
  ];

  doCheck = false;

  meta = with lib; {
    description = "A reverse proxy that provides authentication with Google, Azure, OpenID Connect and many more identity providers";
    homepage = "https://oauth2-proxy.github.io/oauth2-proxy/";
    license = licenses.mit;
  };
}
