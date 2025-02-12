{ _, ... }:

{
  home = {
    username = "iancleary";
    stateVersion = "24.11";
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
