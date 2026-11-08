{
  description = "macOS system configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";
    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nix-darwin, ... }:
    let
      mac = extraModules: nix-darwin.lib.darwinSystem {
        modules = [
          ./darwin/configuration.nix
          { system.configurationRevision = self.rev or self.dirtyRev or null; }
        ] ++ extraModules;
      };
    in
    {
      darwinConfigurations = {
        work = mac [ ];
        personal = mac [ ./darwin/personal.nix ];
      };
    };
}
