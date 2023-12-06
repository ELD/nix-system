{pkgs, ...}: {
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    clock24 = true;
    historyLimit = 10000;
    keyMode = "vi";
    mouse = true;
    newSession = true;
    plugins = [];
    prefix = "C-a";
    shell = "${pkgs.zsh}/bin/zsh";
    terminal = "xterm-256color";
    tmuxinator.enable = true;
    extraConfig = ''
      bind -n S-k clear-history
    '';
  };
}
