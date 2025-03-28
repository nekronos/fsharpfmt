{
  description = "Helix format compatible fantomas wrapper";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      nixpkgs,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        fantomas = pkgs.buildDotnetGlobalTool {
          pname = "fantomas";
          nugetName = "fantomas";
          version = "7.0.1";
          nugetSha256 = "2aGD6Kjh83gmssRqqZ/Uihi7VbNqNUelX4otIfCuhTI=";
          dotnet-sdk = pkgs.dotnet-sdk_9;
        };
      in
      {
        packages = {
          fsharpfmt = pkgs.writeScriptBin "fsharpfmt" ''
            #!/bin/bash
            temp_file=$(mktemp --suffix=.fs)
            cat > "$temp_file"
            ${fantomas}/bin/fantomas "$temp_file" > /dev/null 2>&1
            cat "$temp_file"
            rm "$temp_file"
          '';
        };
      }
    );
}
