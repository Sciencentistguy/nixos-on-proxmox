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
    --arch=amd64 --swap=1024 --memory=2048 \
    --storage=$storage

pct resize $id rootfs +8G # your number may vary
pct start $id
pct enter $id # note: cannot login using the UI yet

## now in the container:

source /etc/set-environment
passwd --delete root
nix channel --update
nix-shell -p git
(cd /etc/nixos \
    && git init \
    && git remote add origin https://github.com/Sciencentistguy/nixos-on-proxmox.git \
    && git fetch origin \
    && git checkout -b master --track origin/master)
nixos-rebuild --flake /etc/nixos switch
```

---

[https://web.archive.org/web/20250108204555/https://nixos.wiki/wiki/Proxmox_Linux_Container]
