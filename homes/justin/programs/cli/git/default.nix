{
  keys,
  config,
  ...
}: {
  programs.git = {
    enable = true;
    userName = "Justin Oh";
    userEmail = "justinoh4116@gmail.com";

    signing = {
      key = keys.justin;
      signByDefault = true;
      format = "ssh";
    };
  };
}
