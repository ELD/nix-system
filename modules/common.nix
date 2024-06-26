{
  self,
  inputs,
  config,
  pkgs,
  ...
}: {
  imports = [./primaryUser.nix ./nixpkgs.nix];

  nixpkgs.overlays = builtins.attrValues self.overlays;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableBashCompletion = true;
  };

  user = {
    description = "Eric Dattore";
    home = "${
      if pkgs.stdenvNoCC.isDarwin
      then "/Users"
      else "/home"
    }/${config.user.name}";
    shell = pkgs.zsh;
  };

  # bootstrap home manager using system config
  hm = import ./home-manager;

  # let nix manage home-manager profiles and use global nixpkgs
  home-manager = {
    extraSpecialArgs = {inherit self inputs;};
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
  };

  # environment setup
  environment = {
    systemPackages = with pkgs; [
      # standard toolset
      coreutils-full
      curl
      wget
      git
      jq

      # helpful shell stuff
      bat
      fzf
      ripgrep
      zsh

      # languages
      python3Full
      python3Packages.pip
      python3Packages.jupyter_core
      python3Packages.ipython
      python3Packages.ipykernel
      python3Packages.fonttools
      pylint
      pipenv
      ruby
      rustup
    ];
    etc = {
      home-manager.source = "${inputs.home-manager}";
      nixpkgs.source = "${inputs.nixpkgs}";
      stable.source = "${inputs.stable}";
    };
    # list of acceptable shells in /etc/shells
    shells = with pkgs; [bash zsh fish];
  };

  fonts = {
    packages = with pkgs; [
      open-sans
      (nerdfonts.override {
        fonts = [
          "JetBrainsMono"
          "Recursive"
          "Monaspace"
        ];
      })
    ];
  };
}
