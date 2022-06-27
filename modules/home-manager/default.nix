{ inputs, config, pkgs, ... }:
let
  homeDir = config.home.homeDirectory;
  pyEnv = (pkgs.stable.python3.withPackages
    (ps: with ps; [ typer colorama shellingham ]));
  sysDoNixos =
    "[[ -d /etc/nixos ]] && cd /etc/nixos && ${pyEnv}/bin/python bin/do.py $@";
  sysDoDarwin =
    "[[ -d ${homeDir}/.nixpkgs ]] && cd ${homeDir}/.nixpkgs && ${pyEnv}/bin/python bin/do.py $@";
  sysdo = (pkgs.writeShellScriptBin "sysdo" ''
    (${sysDoNixos}) || (${sysDoDarwin})
  '');

in
{
  imports = [ ./vim ./cli ./dotfiles ./git.nix ./helix ];

  programs.home-manager = {
    enable = true;
    path = "${config.home.homeDirectory}/.nixpkgs/modules/home-manager";
  };

  home =
    let NODE_GLOBAL = "${config.home.homeDirectory}/.node-packages";
    in
    {
      # This value determines the Home Manager release that your
      # configuration is compatible with. This helps avoid breakage
      # when a new Home Manager release introduces backwards
      # incompatible changes.
      #
      # You can update Home Manager without changing this value. See
      # the Home Manager release notes for a list of state version
      # changes in each release.
      stateVersion = "22.11";
      sessionVariables = {
        GPG_TTY = "/dev/ttys000";
        EDITOR = "nvim";
        VISUAL = "nvim";
        CLICOLOR = 1;
        LSCOLORS = "ExFxBxDxCxegedabagacad";
        KAGGLE_CONFIG_DIR = "${config.xdg.configHome}/kaggle";
        JAVA_HOME = "${pkgs.openjdk.home}";
        NODE_PATH = "${NODE_GLOBAL}/lib";
        # HOMEBREW_NO_AUTO_UPDATE = 1;
      };
      sessionPath = [ "${NODE_GLOBAL}/bin" ];

      # define package definitions for current user environment
      packages = with pkgs; [
        cachix
        comma
        circleci-cli
        pkgs.coreutils-full
        curl
        fd
        flyctl
        gawk
        git
        gnugrep
        gnupg
        gnused
        htop
        jq
        lua5_4
        netlify-cli
        neofetch
        nix
        nixfmt
        nixpkgs-fmt
        nodejs_latest
        openjdk
        openssh
        pandoc
        postgresql_14
        pre-commit
        ranger
        ripgrep
        ripgrep-all
        sccache
        sysdo
        tealdeer
        tectonic
        terraform
        treefmt
        vagrant
        yarn
        yt-dlp
        yq
        # yubikey-manager
      ];
    };
}
