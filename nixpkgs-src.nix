rec {
  stable = builtins.fetchGit {
    name = "nixos-19.09";
    url = "https://github.com/nixos/nixpkgs-channels/";
    # `git ls-remote https://github.com/nixos/nixpkgs-channels nixos-19.09`
    ref = "refs/heads/nixos-19.09";
    rev = "60c4ddb97fd5a730b93d759754c495e1fe8a3544";
  };
  unstable = builtins.fetchGit {
    name = "nixos-unstable";
    url = "https://github.com/nixos/nixpkgs-channels/";
    # `git ls-remote https://github.com/nixos/nixpkgs-channels nixos-unstable`
    ref = "refs/heads/nixos-unstable";
    rev = "9b0d2f3fd153167b0c8ce84bb71e766a39ed4c9d";
  };
}