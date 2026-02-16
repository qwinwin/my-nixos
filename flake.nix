{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    antigravity-nix = {
      url = "github:jacopone/antigravity-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dms = {
      url = "github:AvengeMedia/DankMaterialShell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, antigravity-nix, dms, ... }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      
      # Pass specialArgs to be available in modules (needed for dms in packages.nix)
      specialArgs = { inherit dms; };

      modules = [
        # Main System Configuration
        ./modules/nixos/default.nix
        
        # Additional Overlays if needed
        ({ config, pkgs, ... }: {
          nixpkgs.overlays = [
            (final: prev: {
            })
          ];
        })

        # Home Manager Module
        home-manager.nixosModules.home-manager
        dms.nixosModules.default
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";
          home-manager.users.kwin = import ./modules/home-manager/default.nix;
          home-manager.extraSpecialArgs = { inherit antigravity-nix; };
        }
      ];
    };
  };
}
