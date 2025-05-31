{
  description = "User-specific configuration";

  outputs = { self, ... }: {
    config = import ./default.nix;
  };
}

