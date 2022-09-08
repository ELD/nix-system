{ config, pkgs, lib, ... }:
let
  functions = builtins.readFile ./functions.sh;
  useSkim = false;
  useFzf = !useSkim;
  fuzz =
    let fd = "${pkgs.fd}/bin/fd";
    in
    rec {
      defaultCommand = "${fd} -H --type f";
      defaultOptions = [ "--height 50%" ];
      fileWidgetCommand = "${defaultCommand}";
      fileWidgetOptions = [
        "--preview '${pkgs.bat}/bin/bat --color=always --plain --line-range=:200 {}'"
      ];
      changeDirWidgetCommand = "${fd} --type d";
      changeDirWidgetOptions =
        [ "--preview '${pkgs.tree}/bin/tree -C {} | head -200'" ];
      historyWidgetOptions = [ ];
    };
  aliases = {
    gst = "git status";
    gap = "git add -p";
    gcia = "git commit --amend --no-edit";
  } // (lib.optionalAttrs pkgs.stdenvNoCC.isDarwin {
    # platform specific aliases
    ibrew = "arch -x86_64 brew";
    abrew = "arch -arm64 brew";
  });
in
{
  home.packages = with pkgs; [ tree ];
  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
      stdlib = ''
        # stolen from @i077; store .direnv in cache instead of project dir
        declare -A direnv_layout_dirs
        direnv_layout_dir() {
            echo "''${direnv_layout_dirs[$PWD]:=$(
                echo -n "${config.xdg.cacheHome}"/direnv/layouts/
                echo -n "$PWD" | shasum | cut -d ' ' -f 1
            )}"
        }

        layout_poetry() {
          if [[ ! -f pyproject.toml ]]; then
            log_error 'No pyproject.toml found. Use `poetry new` or `poetry init` to create one first.'
            exit 2
          fi

          # create venv if it doesn't exist
          poetry run true

          export VIRTUAL_ENV=$(poetry env info --path)
          export POETRY_ACTIVE=1
          PATH_add "$VIRTUAL_ENV/bin"
        }
      '';
    };
    skim = {
      enable = useSkim;
      enableBashIntegration = useSkim;
      enableZshIntegration = useSkim;
      enableFishIntegration = useSkim;
    } // fuzz;
    fzf = {
      enable = useFzf;
      enableBashIntegration = useFzf;
      enableZshIntegration = useFzf;
      enableFishIntegration = useFzf;
    } // fuzz;
    bat = {
      enable = true;
      config = {
        theme = "TwoDark";
        color = "always";
      };
    };
    jq.enable = true;
    htop.enable = true;
    gpg = {
      enable = true;
      scdaemonSettings = { } // (lib.optionalAttrs pkgs.stdenvNoCC.isDarwin {
        disable-ccid = true;
      });
    };
    ssh = {
      enable = true;
    };
    git = {
      enable = true;
      lfs.enable = true;
      delta.enable = true;
      aliases = {
        ignore =
          "!gi() { curl -sL https://www.toptal.com/developers/gitignore/api/$@ ;}; gi";
      };
    };
    go = {
      enable = true;
      package = pkgs.go_1_18;
      goPath = "workspace/go";
      goBin = "workspace/go/bin";
    };
    exa = {
      enable = true;
      enableAliases = true;
    };
    bash = {
      enable = true;
      shellAliases = aliases;
      initExtra = ''
        ${functions}
      '';
    };
    nix-index = {
      enable = true;
      enableZshIntegration = true;
    };
    zsh =
      let
        mkZshPlugin = { pkg, file ? "${pkg.pname}.plugin.zsh" }: rec {
          name = pkg.pname;
          src = pkg.src;
          inherit file;
        };
      in
      {
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
          [[ -d ''${HOME}/.cargo/bin ]] && path+=(''${HOME}/.cargo/bin)
          [[ -d ''${HOME}/workspace/go/bin ]] && path+=(''${HOME}/workspace/go/bin)
          unset RPS1
        '';
        profileExtra = ''
          ${lib.optionalString pkgs.stdenvNoCC.isLinux "[[ -e /etc/profile ]] && source /etc/profile"}
        '';
        prezto = {
          enable = true;
          caseSensitive = false;
          color = true;
          extraModules = [ "attr" "stat" ];
          extraFunctions = [ "zargs" "zmv" ];
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
    zoxide.enable = true;
    starship = {
      enable = true;
    };
  };
  services = {
    gpg-agent.enableScDaemon = if pkgs.stdenvNoCC.isDarwin then false else true;
    gpg-agent.enableSshSupport = true;
  };
}
