{
  default = { config, lib, ... }: {
    home = rec {
      username = lib.mkDefault "iancleary";
      homeDirectory = lib.mkDefault "/home/${username}";
      stateVersion = lib.mkDefault "23.11";
    };
  };
  myHome = import ./myHome;
}
