{
  inputs,
  config,
  user,
  ...
}:

{
  imports = [
    inputs.nix-homebrew.darwinModules.nix-homebrew
  ];

  nix-homebrew = {
    # Install Homebrew under the default prefix
    enable = true;

    # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
    enableRosetta = false;

    # User owning the Homebrew prefix
    user = "${user}";

    # Declarative tap management
    taps = {
      "homebrew/homebrew-core" = inputs.homebrew-core;
      "homebrew/homebrew-cask" = inputs.homebrew-cask;
      "homebrew/homebrew-bundle" = inputs.homebrew-bundle;
    };

    # Optional: Enable fully-declarative tap management
    # With mutableTaps disabled, taps can no longer be added imperatively with `brew tap`.
    mutableTaps = false;
  };

  homebrew = {
    enable = true;
    onActivation.autoUpdate = true;
    #onActivation.cleanup = "zap";
    onActivation.upgrade = true;

    # https://github.com/zhaofengli/nix-homebrew/issues/5#issuecomment-1878798641
    taps = builtins.attrNames config.nix-homebrew.taps;

    # brews = [
    #   "nicotine-plus"
    # ];

    casks = [
      "tailscale-app"
      "keepingyouawake"
      "orbstack"
      "betterdisplay"
      "appcleaner"
      "grandperspective"
      "hammerspoon"
      "iterm2"
      "keka"
      "qbittorrent"
      "sloth"
      "stats"

      "oversight"
      "blockblock"
      "netiquette"
      "reikey"
      "taskexplorer"
      "dhs"
      "knockknock"
      "lulu"

      "ungoogled-chromium"
      "firefox"
    ];

    # masApps = {
    #   "grabit" = 450166997;
    #   "macfamilytree" = 6480510488;
    #   "keynote" = 409183694;
    #   "pages" = 409201541;
    #   "xcode" = 497799835;
    #   "blackmagicdiskmark" = 425264550;
    #   "perplexity" = 6714467650;
    #   "configurator" = 1037126344;
    # };
  };
}
