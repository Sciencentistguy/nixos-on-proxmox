{
  config,
  modulesPath,
  pkgs,
  lib,
  ...
}: {
  imports = [(modulesPath + "/virtualisation/proxmox-lxc.nix")];
  system.stateVersion = "24.11";

  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    sandbox = false;
  };
  nix.extraOptions = ''
    auto-optimise-store = true
    experimental-features = flakes nix-command
  '';

  proxmoxLXC = {
    manageNetwork = false;
    privileged = true;
  };

  security.pam.services.sshd.allowNullPassword = true;

  environment.systemPackages = with pkgs; [vim alejandra git];

  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PermitRootLogin = "yes";
      PasswordAuthentication = true;
      PermitEmptyPasswords = "yes";
    };
  };
  services.tailscale.enable = true;
}
