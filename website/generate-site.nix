{ pkgs, lib }:

let
  imagesPath = ../images;
  allFiles = lib.filesystem.listFilesRecursive imagesPath;
  imageFiles = builtins.filter (path:
    let
      pathStr = toString path;
      relativePath = lib.removePrefix (toString imagesPath + "/") pathStr;
      parts = lib.splitString "/" relativePath;
    in
      builtins.length parts == 2 &&
      builtins.elemAt parts 1 == "default.nix" &&
      !(builtins.any (part: part == "fake_nixpkgs" || part == "root" || part == "patches") parts)
  ) allFiles;

  imageNames = lib.lists.unique (map (path:
    let
      pathStr = toString path;
      relativePath = lib.removePrefix (toString imagesPath + "/") pathStr;
      parts = lib.splitString "/" relativePath;
    in
      builtins.elemAt parts 0
  ) imageFiles);

  extractLabel = nixContent: label: default:
    let
      pattern = "\"${label}\"\\s*=\\s*\"([^\"]+)\"";
      match = builtins.match ".*${pattern}.*" nixContent;
    in if match != null then builtins.head match else default;

  generateImageData = imageName:
    let
      readmePath = imagesPath + "/${imageName}/README.md";
      nixPath = imagesPath + "/${imageName}/default.nix";
      testPath = imagesPath + "/${imageName}/test.nix";

      readmeContent = if builtins.pathExists readmePath
        then builtins.readFile readmePath
        else "";

      nixContent = if builtins.pathExists nixPath
        then builtins.readFile nixPath
        else "";

      version =
        let
          staticMatch = builtins.match ".*\"org\\.opencontainers\\.image\\.version\"\\s*=\\s*\"([^\"]+)\".*" nixContent;
          dynamicMatch = builtins.match ".*\"org\\.opencontainers\\.image\\.version\"\\s*=\\s*pkgs\\.([^;]+)\\.version.*" nixContent;
        in
          if staticMatch != null then builtins.head staticMatch
          else if dynamicMatch != null then "dynamic-${builtins.head dynamicMatch}"
          else "latest";
    in {
      name = imageName;
      description = extractLabel nixContent "org\\.opencontainers\\.image\\.description"
                       "Container image for ${imageName}";
      version = version;
      category = extractLabel nixContent "io\\.nix-containers\\.image\\.category" "utility";
      upstream = extractLabel nixContent "io\\.nix-containers\\.image\\.upstream" "";
      aliases = extractLabel nixContent "io\\.nix-containers\\.image\\.aliases" imageName;
      hasTest = builtins.pathExists testPath;
      readme = readmeContent;
      pullCommand = "docker pull ghcr.io/nix-containers/images/${imageName}:latest";
      nixCode = nixContent;
    };

  imagesData = map generateImageData imageNames;

  imagesJsonFull = pkgs.writeText "images-data-full.json" (builtins.toJSON {
    images = imagesData;
    totalCount = builtins.length imagesData;
  });

in
pkgs.stdenv.mkDerivation {
  name = "nix-containers-website";
  src = ./.;

  buildInputs = [
    pkgs.tailwindcss
    pkgs.cmark
    pkgs.python3
    pkgs.python3Packages.pygments
  ];

  buildPhase = ''
    runHook preBuild

    export HOME=$TMPDIR
    OUT_DIR=$out
    mkdir -p $OUT_DIR

    echo "-> Compiling Tailwind CSS..."
    mkdir -p $OUT_DIR/static/css
    tailwindcss -c tailwind/tailwind.config.js \
      -i tailwind/input.css \
      -o $OUT_DIR/static/css/site.css \
      --minify

    echo "-> Copying static assets..."
    mkdir -p $OUT_DIR/static/fonts
    cp -r static/fonts/* $OUT_DIR/static/fonts/
    cp static/app.js $OUT_DIR/static/app.js

    echo "-> Rendering pages..."
    python3 render.py \
      --data ${imagesJsonFull} \
      --templates ./templates \
      --out $OUT_DIR \
      --cmark ${pkgs.cmark}/bin/cmark \
      --pygmentize ${pkgs.python3Packages.pygments}/bin/pygmentize

    echo "-> Build complete. Output:"
    ls -la $OUT_DIR/
    echo "Image pages: $(ls $OUT_DIR/images/ | wc -l)"

    runHook postBuild
  '';

  dontInstall = true;
}
