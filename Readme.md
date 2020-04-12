## Features:
1. Autologin and autorun Steam Big Picture on boot
1. Open Ports for Steam Stream
1. SSH access via your ssh key to modify the system (via NixOps)
1. KDE Desktop as fallback in case interaction with the desktop is needed
1. Includes fix for Xbox wireless controller via bluetooth

## Setup
### On the gaming box:
1. Manually install a basic NixOS on the gaming box by following the instructions on https://nixos.org/nixos/manual/index.html#sec-obtaining
1. To enable yourself to manage the machine via NixOps, configure ssh access to root for your ssh key.
1. Find and note down the local network's IP addess of your gaming box

### Deploy via NixOps
1. Adapt the `configuration.nix` from this projects for your needs:  
    - Check if `services.xserver.videoDrivers` contains the correct video driver for your GPU.
    - Put your ssh key in `root.openssh.authorizedKeys.keys`. Otherwise you might lock yourself out.
1. Edit `nixops.nix` to contain your steam box' IP address under `deployment.targetHost`
1. Copy the `hardware-configuration.nix` from the gaming rig:
    ```
    scp root@steambox_ip:/etc/nixos/hardware-configuration.nix ./
    ```
1. If the nix package manager is not yet installed on your system, execute as non-root user:
    ```
    curl -L https://nixos.org/nix/install | sh
    ```
1. Enter the nix shell by executing from the root directory of this project:
    ```
    nix-shell
    ```
1. Register the deployment defined in `nixops.nix`:
    ```
      nixops create ./nixops.nix -d steambox
    ```
1. Execute the deployment:
    ```
      nixops deploy -d steambox
    ```
Redo only the last step in case you change anything within the config
