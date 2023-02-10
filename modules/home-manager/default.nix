{
  self,
  inputs,
  config,
  pkgs,
  ...
}: let
  homeDir = config.home.homeDirectory;
in {
  imports = [
    ./bat.nix
    ./direnv.nix
    ./dotfiles
    ./exa.nix
    ./fzf.nix
    ./git.nix
    ./go.nix
    ./gpg.nix
    ./helix.nix
    ./nvim
    ./rust.nix
    ./shell.nix
    ./ssh.nix
  ];

  nixpkgs.config = {
    allowUnfree = true;
  };

  home = let
    NODE_GLOBAL = "${config.home.homeDirectory}/.node-packages";
  in {
    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "22.05";
    sessionVariables = {
      GPG_TTY = "/dev/ttys000";
      EDITOR = "nvim";
      VISUAL = "nvim";
      CLICOLOR = 1;
      LSCOLORS = "ExFxBxDxCxegedabagacad";
      NODE_PATH = "${NODE_GLOBAL}/lib";
      JAVA_HOME = "${pkgs.jdk11}";
    };
    sessionPath = [
      "${NODE_GLOBAL}/bin"
      "${config.home.homeDirectory}/.rd/bin"
    ];

    # define package definitions for current user environment
    packages = with pkgs;
      [
        alejandra
        age
        cachix
        comma
        circleci-cli
        cirrus-cli
        coreutils-full
        curl
        fd
        flyctl
        gawk
        git
        gnugrep
        gnupg
        gnused
        jdk11
        luajit
        mold
        neofetch
        nix
        nixfmt
        nixpkgs-fmt
        nodejs_latest
        openssh
        postgresql_14
        pre-commit
        ranger
        ripgrep
        ripgrep-all
        sccache
        sysdo
        tealdeer
        terraform
        tree
        treefmt
        vagrant
        yarn
        yt-dlp
        yq
        yubikey-manager
      ]
      ++ (lib.lists.optionals (pkgs.system == "x86_64-linux") [
        # _1password-gui
        alacritty
        cider
        efitools
        openssl
        sbctl
      ]);
  };

  programs = {
    home-manager = {
      enable = true;
      path = "${config.home.homeDirectory}/.nixpkgs/modules/home-manager";
    };
    dircolors.enable = true;
    htop.enable = true;
    jq.enable = true;
    less.enable = true;
    man.enable = true;
    nix-index.enable = true;
    starship.enable = true;
    yt-dlp.enable = true;
    zathura.enable = true;
    zoxide.enable = true;
  };
}
