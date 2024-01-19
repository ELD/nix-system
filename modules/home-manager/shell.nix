{
  config,
  lib,
  pkgs,
  ...
}: let
  functions = builtins.readFile ./functions.sh;
  aliases =
    {
      gst = "git status";
      gap = "git add -p";
      gcia = "git commit --amend --no-edit";
    }
    // lib.optionalAttrs pkgs.stdenvNoCC.isDarwin {
      ibrew = "aarch -x86_64 brew";
      abrew = "aarch -arm64 brew";
    };
  atuinZshExtras =
    if config.programs.atuin.enable
    then
      /*
      bash
      */
      ''
        export ATUIN_NOBIND="true"
        bindkey '^r' _atuin_search_widget
        bindkey '^[[A' _atuin_search_widget
        bindkey '^[OA' _atuin_search_widget
      ''
    else "";
in {
  programs = {
    atuin = {
      enable = true;
      enableZshIntegration = true;
    };
    zellij = {
      enable = true;
      enableZshIntegration = true;
    };
    zsh = {
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
      };
      shellAliases = aliases;
      initExtraBeforeCompInit = ''
        fpath+=~/.zfunc
      '';
      initExtra = ''
        ${functions}
        ${atuinZshExtras}
        if [[ -f "$HOME/.config/zsh/.p10k.zsh" ]]; then
          source "$HOME/.config/zsh/.p10k.zsh"
        fi
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
          "prompt"
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
        prompt = {theme = "powerlevel10k";};
      };
    };

    bash = {
      enable = true;
      shellAliases = aliases;
      initExtra = ''
        ${functions}
      '';
    };
  };
}
