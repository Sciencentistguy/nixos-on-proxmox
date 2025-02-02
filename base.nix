{
  pkgs,
  modulesPath,
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

  environment.systemPackages = with pkgs; [alejandra git];

  security.pam.services.sshd.allowNullPassword = true;

  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PermitRootLogin = "yes";
      PasswordAuthentication = true;
    };
  };
  services.tailscale.enable = true;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };
}
