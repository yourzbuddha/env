{ config, lib, pkgs, ... }:

# References:
#
# https://daiderd.com/nix-darwin/manual/index.html#sec-options
# https://github.com/jwiegley/nix-config/blob/master/config/darwin.nix
# https://github.com/cmacrae/config/blob/master/modules/macintosh.nix

let
  fullName       = "Andrii Butko";
  user           = builtins.getEnv "USER";
  home           = builtins.getEnv "HOME";
  xdg_configHome = "${home}/.config";
in {
  time.timeZone = "Europe/Warsaw";

  nix = {
    package = pkgs.nixFlakes;

    extraOptions = ''
experimental-features = nix-command flakes
    '';

    configureBuildUsers = true;
    settings = {
      max-jobs = "auto";
      cores = 0;

      trusted-users = [ "root" "andriib" ];

# TODO: what is public keys?
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
# TODO: what is substituters?
      trusted-substituters = [
        "https://cachix.org/api/v1/cache/nix-community"
        "https://cachix.org/api/v1/cache/deploy-rs"
        "https://hydra.iohk.io"
      ];
    };
  };

  environment = {
    shells = [
      pkgs.fish
      pkgs.zsh
      pkgs.bash
    ];
  };

  home-manager = {
    useGlobalPkgs = true;
    users.d12frosted = lib.mkMerge [
      (import ./home.nix)
      {
        imports = [
          ./darwin/yabai.nix
        ];
      }
    ];
  };

  system = {
    stateVersion = 4;

    defaults = {
      NSGlobalDomain = {
        AppleKeyboardUIMode = 3;
        ApplePressAndHoldEnabled = false;
        InitialKeyRepeat = 12;
        KeyRepeat = 2;
        AppleShowAllExtensions = true;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticDashSubstitutionEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
        NSTableViewDefaultSizeMode = 2;
        _HIHideMenuBar = false;
        "com.apple.keyboard.fnState" = true;
        "com.apple.mouse.tapBehavior" = 1;
        "com.apple.sound.beep.volume" = 0.0;
        "com.apple.sound.beep.feedback" = 0;
      };

      dock = {
        autohide = true;
        launchanim = false;
        minimize-to-application = true;
        mru-spaces = false;
        orientation = "left";
        show-recents = false;
        static-only = true;
        tilesize = 32;
      };

      finder = {
        AppleShowAllExtensions = true;
      };

      trackpad = {
        Clicking = true;
      };
    };

    keyboard = {
      # enableKeyMapping = true;
      # remapCapsLockToControl = true;
    };
  };

  networking.hostName = "andriib";
  users = {
    users.d12frosted = {
     shell = pkgs.fish;
     home = "/Users/andriib";
    };
  };

  programs.fish.enable = true;

  programs.gnupg.agent.enable = true;
  programs.gnupg.agent.enableSSHSupport = true;

  services = {
    nix-daemon.enable = true;
    activate-system.enable = true;
  };

  homebrew = {
    enable = true;
    onActivation.autoUpdate = true;
    onActivation.cleanup = "uninstall"; # removes manually install brews and casks
    brews = [
      {
        name = "yabai";
        args = [];
      }
      {
        name = "skhd";
        args = [];
      }
    ];
    casks = [
      # multimedia
      "spotify"
      "vlc"

      # social
      "telegram"

      # other
      "appcleaner"
    ];
    taps = [
      "homebrew/bundle"
      "homebrew/cask"
      "homebrew/cask"
      "homebrew/cask-drivers"
      "homebrew/core"
      "homebrew/services"
      "koekeishiya/formulae"
    ];
  };

}

# nix build --impure \
#         ./#darwinConfigurations.andriib.system
#       result/sw/bin/darwin-rebuild switch \
#         --impure \
#         --flake ./andriib
