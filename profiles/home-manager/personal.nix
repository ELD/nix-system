{...}: {
  programs.git = {
    userEmail = "eric@dattore.me";
    userName = "Eric Dattore";
    signing = {
      key = "0x26CCB5CE8AE20CE0";
      signByDefault = true;
    };
  };
}
