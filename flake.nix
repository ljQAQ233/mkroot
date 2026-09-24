{
  description = "mkroot";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    {
      self,
      nixpkgs,
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };

      textosToolchain = pkgs.callPackage ./nix/toolchain.nix { };
      gnuAutomake115 = pkgs.callPackage ./nix/automake115.nix { };
    in
    {
      packages.${system} = {
        default = textosToolchain;
        textos-toolchain = textosToolchain;
        newlib-automake = gnuAutomake115;
        newlib-autoconf = pkgs.autoconf269;
      };

      devShells.${system}.default = pkgs.mkShellNoCC {
        nativeBuildInputs = with pkgs; [
          stdenv
          gnumake
          patchelf
          gcc
          binutils
          gdb
          perl
          python3Packages.python
          python3Packages.kconfiglib
          self.packages.${system}.textos-toolchain
          self.packages.${system}.newlib-automake
          self.packages.${system}.newlib-autoconf
        ];
        CONFIG_TOOLCHAIN_EXTERNAL_BINUTILS = "${textosToolchain}/bin";
        CONFIG_TOOLCHAIN_EXTERNAL_COMPILER = "${textosToolchain}/bin";
      };
    };
}
