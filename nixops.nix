{
  network.description = "Steam-Box";
  network.enableRollback = true;
  machine = 
    { config, pkgs, ... }:
    { imports = [
        ./configuration.nix
      ];
    deployment.targetHost = "192.168.1.44";
    };
}