{ nix2container, pkgs, lib, ... }:

# akhq — mirror of OSS upstream docker.io/tchiotludo/akhq (auto-generated, #618).
nix2container.pullImage {
  imageName = "docker.io/tchiotludo/akhq";
  imageDigest = "sha256:66a43e84a3355f0a13f3b165a48f515c72a5344ea7ea0575a3e4efe2d3ac9a91";
  sha256 = "sha256-dCrvI3qksQuAUt9IxYxgcI+8ZUYZDdwPY3+2dvIqlNI=";
}
