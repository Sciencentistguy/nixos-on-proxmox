{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  }: {
    nixosConfigurations.recv = nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";
      modules = [
        ./config.nix
        ./shell.nix
        home-manager.nixosModules.home-manager
      ];
    };
  };
}
