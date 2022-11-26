{
  config,
  lib,
  pkgs,
  ...
}: let
  functions = builtins.readFile ./functions.sh;
  aliases =
    rec {
      gst = "git status";
      gap = "git add -p";
      gcia = "git commit --amend --no-edit";
      # ls = "${pkgs.coreutils}/bin/ls --color=auto -h";
      # la = "${ls} -a";
      # ll = "${ls} -la";
      # lt = "${ls} -lat";
    }
    // lib.optionalAttrs pkgs.stdenvNoCC.isDarwin rec {
      ibrew = "aarch -x86_64 brew";
      abrew = "aarch -arm64 brew";
    };
in {
  programs.zsh = let
    mkZshPlugin = {
      pkg,
      file ? "${pkgs.pname}.plugin.zsh",
    }: rec {
      name = pkg.name;
      src = pkg.src;
      inherit file;
    };
  in {
    enable = true;
    autocd = true;
    dotDir = ".config/zsh";
    localVariables = {
      LANG = "en_US.UTF-8";
      GPG_TTY = "/dev/ttys000";
      DEFAULT_USER = "${config.home.username}";
      CLICOLOR = 1;
      LS_COLORS = "ExFxBxDxCxegedabagacad";
      TERM = "xterm-256color";
      RUSTC_WRAPPER = "${pkgs.sccache}/bin/sccache";
    };
    shellAliases = aliases;
    initExtraBeforeCompInit = ''
      fpath+=~/.zfunc
    '';
    initExtra = ''
      ${functions}
      ${lib.optionalString pkgs.stdenvNoCC.isDarwin ''
        if [[ -d /opt/homebrew ]]; then
          eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
      ''}
      unset RPS1
    '';
    profileExtra = ''
      ${lib.optionalString pkgs.stdenvNoCC.isLinux "[[ -e /etc/profile ]] && source /etc/profile"}
    '';

    prezto = {
      enable = true;
      caseSensitive = false;
      color = true;
      extraModules = ["attr" "stat"];
      extraFunctions = ["zargs" "zmv"];
      pmodules = [
        "environment"
        "terminal"
        "editor"
        "history"
        "directory"
        "spectrum"
        "utility"
        "completion"
        "archive"
        "docker"
        "git"
        "homebrew"
        "osx"
        "autosuggestions"
        "syntax-highlighting"
        "history-substring-search"
        "command-not-found"
        "gpg"
      ];
      editor = {
        keymap = "vi";
        dotExpansion = true;
        promptContext = true;
      };
      gnuUtility.prefix = "g";
      macOS.dashKeyword = "mand";
      terminal = {
        autoTitle = true;
        windowTitleFormat = "%n@%m: %s %d";
        tabTitleFormat = "%m: %s %d";
      };
    };
  };

  programs.bash = {
    enable = true;
    shellAliases = aliases;
    initExtra = ''
      ${functions}
    '';
  };
}