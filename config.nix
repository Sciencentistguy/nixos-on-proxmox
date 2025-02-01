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

  nix.settings = {sandbox = false;};

  proxmoxLXC = {
    manageNetwork = false;
    privileged = true;
  };

  security.pam.services.sshd.allowNullPassword = true;

  environment.systemPackages = [pkgs.vim];

  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PermitRootLogin = "yes";
      PasswordAuthentication = true;
      PermitEmptyPasswords = "yes";
    };
  };

}
