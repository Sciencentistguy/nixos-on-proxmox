# NixOS on Proxmox

## Create the container
```bash
# $id is the container id in proxmox
# $template-path is the path to the nixos template, can be tab-completed
# $storage is the storage to use for the container

pct create $id $template-path \
    --hostname nixos \
    --ostype=nixos --unprivileged=0 --features nesting=1 \
    --net0 name=eth0,bridge=vmbr0,ip=dhcp \
    --arch=amd64 --swap=0 --memory=2048 \
    --storage=$storage

# needed for tailscale
cat >>/etc/pve/lxc/$id.conf <<EOF 
lxc.cgroup2.devices.allow: c 10:200 rwm
lxc.mount.entry: /dev/net/tun dev/net/tun none bind,create=file
EOF

pct resize $id rootfs +8G # your number may vary
pct start $id
pct enter $id # note: cannot login using the UI yet

```

## In the container
```bash
source /etc/set-environment
passwd root
nix --extra-experimental-features 'flakes nix-command' shell github:nixos/nixpkgs/nixos-24.11#git --command bash -c "\
    (cd /etc/nixos \
        && git init \
        && git remote add origin https://github.com/Sciencentistguy/nixos-on-proxmox.git \
        && git fetch origin \
        && git checkout -b master --track origin/master \
        && nix --extra-experimental-features 'flakes nix-command' flake update)"
nix --extra-experimental-features 'flakes nix-command' run github:nixos/nixpkgs/nixos-24.11#neovim /etc/nixos/flake.nix
nixos-rebuild --flake /etc/nixos switch
```

---

[https://web.archive.org/web/20250108204555/https://nixos.wiki/wiki/Proxmox_Linux_Container]
