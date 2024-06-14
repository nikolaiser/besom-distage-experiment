{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs:
    inputs.flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import inputs.nixpkgs {
            inherit system;
            # config = {
            #   permittedInsecurePackages = [
            #     "openssl-1.1.1w"
            #   ];
            # };
          };

          java-pkg = pkgs.jdk21;

          java-env = rec {
            JAVA_HOME = "${java-pkg}/lib/openjdk";
            JDK_HOME = JAVA_HOME;
          };

          packages = {
            buildInputs = [
              java-pkg
              (pkgs.sbt.override { jre = java-pkg; })
              (pkgs.metals.override { jre = java-pkg; })
              (pkgs.scala-cli.override { jre = java-pkg; })
            ];
          };

        in
        {
          devShells.default = pkgs.mkShell (java-env // packages);
        }

      );
}
