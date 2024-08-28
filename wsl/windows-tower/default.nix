{ _, ... }:

{
  home = rec {
    username = "iancleary";
    stateVersion = "24.05";
  };

  myTerminal = {
    cli.personalGitEnable = true;
    tmux.enable = true;
    zsh.enable = true;
    neovim = {
      enable = true;
      enableLSP = true;
    };
  };

}
