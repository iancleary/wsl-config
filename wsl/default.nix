{ _, ... }:

{
  home = {
    username = "iancleary";
    stateVersion = "25.05";
  };

  myTerminal = {
    cli.personalGitEnable = true;
    tmux.enable = true;
    zsh.enable = true;
  };

}
