{
  description = "neutralinsomniac's nix config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    jujutsu.url = "github:jj-vcs/jj";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nix-index-database,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
      };
    in
    {
      nixosConfigurations."gaming" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          { networking.hostName = "gaming"; }
          { nix.nixPath = [ "nixpkgs=${nixpkgs}" ]; }
          inputs.disko.nixosModules.disko
          ./hw/gaming
          ./configuration.nix
          nix-index-database.nixosModules.nix-index
          { programs.nix-index-database.comma.enable = true; }
          { system.configurationRevision = self.rev or "dirty"; }
        ];
      };

      apps.x86_64-linux.update = {
        type = "app";
        program = "${
          pkgs.writeShellScriptBin "update" (
            builtins.readFile (
              pkgs.replaceVars ./.scripts/update.sh {
                bash = "${pkgs.bash}/bin/bash";
              }
            )
          )
        }/bin/update";
      };
    };
}
