{
  inputs,
  config,
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
    user = "hcbt";

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
    onActivation.cleanup = "zap";
    onActivation.upgrade = true;

    # https://github.com/zhaofengli/nix-homebrew/issues/5#issuecomment-1878798641
    taps = builtins.attrNames config.nix-homebrew.taps;

    brews = [ ];

    casks = [
      #"logi-options+"
      #"zerotier-one"
      #"inkscape"
      #"balenaetcher"
      #"proxyman"
      #"kicad"
      #"home-assistant"
      #"cutter"
      "utm"
      "gitkraken"
      "gitbutler"
      #"zenmap"
      "tailscale"
      "keepingyouawake"
      "orbstack"
      "keepassxc"
      "nvidia-geforce-now"
      "mos"
      "betterdisplay"
      "steam"
      "appcleaner"
      "discord"
      "element"
      "fujifilm-x-raw-studio"
      "grandperspective"
      "hammerspoon"
      "jordanbaird-ice"
      "iterm2"
      "keka"
      "obs"
      "qbittorrent"
      "sloth"
      "stats"

      "proton-pass"
      "proton-mail"
      "protonvpn"
      #"proton-drive"
      #"nordvpn"

      "obsidian"
      "readwise-ibooks"
      "reader"
      "zotero"
      "standard-notes"
      #"chatgpt"
      "lm-studio"
      "livebook"
      #"reflect"
      #"heptabase"

      "handbrake"
      "eqmac"
      "iina"
      "tidal"
      "foobar2000"
      "splice"
      "soulseek"
      "spotify"
      #"xld"
      #"musicbrainz-picard"
      #"native-access"
      #"ilok-license-manager"
      #"softube-central"
      #"rekordbox"

      "oversight"
      "blockblock"
      "netiquette"
      "reikey"
      "taskexplorer"
      "dhs"
      "knockknock"
      "lulu"

      "eloston-chromium"
      "firefox"

      "jagex"
      "runelite"

      "ibkr"
      "trader-workstation"
    ];

    masApps = {
      #"grabit" = 450166997;
      "macfamilytree" = 6480510488;
      "keynote" = 409183694;
      "pages" = 409201541;
      "xcode" = 497799835;
      "blackmagicdiskmark" = 425264550;
      "perplexity" = 6714467650;
      "configurator" = 1037126344;
    };
  };
}
