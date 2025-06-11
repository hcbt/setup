{
  self,
  pkgs,
  inputs,
  nix-index-database,
  ...
}:

{
  nix = {
    enable = false;

    settings = {
      experimental-features = "nix-command flakes";
      trusted-users = [
        "root"
        "hcbt"
      ];
    };
  };

  nixpkgs = {
    hostPlatform = "aarch64-darwin";

    config = {
      allowUnfree = true;
      allowBroken = false;
      allowUnsupportedSystem = false;
    };
  };

  # https://github.com/nix-community/home-manager/issues/6557
  # https://github.com/nix-community/home-manager/issues/6036
  # https://stackoverflow.com/questions/79473295/error-trying-to-setup-basic-nix-darwin-with-home-manager-flake
  users = {
    users.hcbt = {
      name = "hcbt";
      home = "/Users/hcbt";
    };
  };

  sops = {
    defaultSopsFile = inputs.secrets + "/secrets.yaml";
    validateSopsFiles = false;

    gnupg = {
      sshKeyPaths = [ ];
    };

    age = {
      keyFile = "/Users/hcbt/.config/sops/age/keys.txt";
      generateKey = false;
      sshKeyPaths = [ ];
    };

    secrets = {
      auth = {
        path = "/run/secrets/auth";
        owner = "hcbt";
        mode = "0600";
      };

      auth_pub = {
        path = "/run/secrets/auth_pub";
        owner = "hcbt";
        mode = "0600";
      };

      git = {
        path = "/run/secrets/git";
        owner = "hcbt";
        mode = "0600";
      };

      git_pub = {
        path = "/run/secrets/git_pub";
        owner = "hcbt";
        mode = "0600";
      };
    };
  };

  programs = {
    nix-index-database = {
      comma = {
        enable = true;
      };
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment = {
    variables = {
      EDITOR = "micro";
      VISUAL = "cursor";
    };

    systemPackages = with pkgs; [
      sops
      ssh-to-age
      ssh-to-pgp
      age
      fh
      micro
      devenv
      rclone
      code-cursor
      gnupg
      nixd
      nixfmt-rfc-style
      (coreutils-full.override { withPrefix = false; })
      htop
      wget
      curl
      zulu17
      ffmpeg
    ];
  };

  networking = {
    #computerName = "${config.home.username}";
    computerName = "kvarcas";
  };

  system = {
    # Set Git commit hash for darwin-version.
    configurationRevision = self.rev or self.dirtyRev or null;

    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    stateVersion = 6;

    # Previously, some nix-darwin options applied to the user running
    # `darwin-rebuild`. As part of a long‐term migration to make
    # nix-darwin focus on system‐wide activation and support first‐class
    # multi‐user setups, all system activation now runs as `root`, and
    # these options instead apply to the `system.primaryUser` user.
    # You currently have the following primary‐user‐requiring options set:
    # * `homebrew.enable`
    # To continue using these options, set `system.primaryUser` to the name
    # of the user you have been using to run `darwin-rebuild`. In the long
    # run, this setting will be deprecated and removed after all the
    # functionality it is relevant for has been adjusted to allow
    # specifying the relevant user separately, moved under the
    # `users.users.*` namespace, or migrated to Home Manager.
    primaryUser = "hcbt";
  };

  services = {
    openssh = {
      enable = false;
    };
  };

  security = {
    pam = {
      services.sudo_local.touchIdAuth = true;
    };
  };
}
