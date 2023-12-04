{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./bat.nix
    ./direnv.nix
    ./dotfiles
    ./eza.nix
    ./fzf.nix
    ./git.nix
    ./go.nix
    ./gpg.nix
    ./helix.nix
    ./kitty.nix
    ./nvim
    ./rust.nix
    ./shell.nix
    ./ssh.nix
    ./tmux.nix
  ];

  nixpkgs.config = {
    allowUnfree = true;
  };

  home = let
    NODE_GLOBAL = "${config.home.homeDirectory}/.node-packages";
    PNPM_DIR =
      if (pkgs.system == "x86_64-linux" || pkgs.system == "aarch64-linux")
      then "${config.home.homeDirectory}/.local/share/pnpm"
      else "${config.home.homeDirectory}/Library/pnpm";
  in {
    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "24.05";
    sessionVariables = {
      GPG_TTY = "/dev/ttys000";
      EDITOR = "nvim";
      VISUAL = "nvim";
      CLICOLOR = 1;
      LSCOLORS = "ExFxBxDxCxegedabagacad";
      NODE_PATH = "${NODE_GLOBAL}/lib";
      JAVA_HOME = "${pkgs.jdk11}";
      PNPM_HOME = "${PNPM_DIR}";
    };
    sessionPath = [
      "${NODE_GLOBAL}/bin"
      "${config.home.homeDirectory}/.rd/bin"
      "${PNPM_DIR}"
      "${config.home.homeDirectory}/.local/bin"
    ];

    # define package definitions for current user environment
    # TODO: Extract the conditionals below to separate modules based on target system?
    packages = with pkgs;
      [
        alejandra
        age
        bun
        cachix
        colima
        comma
        circleci-cli
        cirrus-cli
        coreutils-full
        curl
        deadnix
        devenv
        fd
        findutils
        flyctl
        fontforge
        gawk
        git
        gnugrep
        gnupg
        gnused
        jdk11
        luajit
        luajitPackages.luarocks
        neofetch
        nix
        nixfmt
        nixpkgs-fmt
        nodejs_latest
        nodePackages.pnpm
        nushell
        openssh
        postgresql_14
        pre-commit
        ranger
        ripgrep
        ripgrep-all
        sccache
        sniffnet
        statix
        sysdo
        tealdeer
        tectonic
        terraform
        tree
        treefmt
        unzip
        yarn
        yt-dlp
        yq
        yubikey-manager
        zellij
      ]
      ++ (lib.lists.optionals (pkgs.system == "x86_64-linux") [
        _1password-gui
        alacritty
        cider
        cmake
        efitools
        gcc
        gnumake
        sbctl
      ])
      ++ (lib.lists.optionals (pkgs.system == "aarch64-darwin" || pkgs.system == "x86_64-darwin") [
        dockutil
      ]);
  };

  programs = {
    home-manager = {
      enable = true;
    };
    dircolors.enable = true;
    htop.enable = true;
    jq.enable = true;
    less.enable = true;
    man.enable = true;
    nix-index.enable = true;
    yt-dlp.enable = true;
    zathura.enable = true;
    zoxide.enable = true;
  };
}
