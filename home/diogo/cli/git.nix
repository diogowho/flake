{ pkgs, config, ... }:
{
  programs.git = {
    package = pkgs.gitMinimal;
    enable = true;

    signing = {
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMT6iIuLEVTZh0XgYxD5pqAthx1JuiE8M7SwQo+wFBC+";
      format = "ssh";
      signByDefault = true;
    };

    ignores = [
      ".DS_Store"
      "*~"
      "*.swp"
      "*.bak"
      "*.tmp"
      "*.log"
      ".idea"
      "changes.txt"
      "*freeze.png"
      ".crush"
      "**/.terraform/*"
      "*.tfvars"
      "*.tfvars.json"
      "*.tfstate"
      "*.tfstate.*"
      ".env*"
    ];

    attributes = [
      "* text=auto"
      "*.sh text eol=lf"
      "tsconfig.json linguist-language=JSON-with-Comments"
      "*.lock text -diff"
    ];

    settings = {
      user = {
        name = "Diogo";
        email = "hello" + "@" + "diogocastro" + "." + "net";
      };

      aliases = {
        s = "status -s";
        undo = "reset --soft HEAD^";
        cleanup = ''
          git fetch upstream; \
          git checkout main; \
          git pull upstream main; \
          git push origin main; \
          git branch -r --merged | grep -v main | grep origin | sed 's/origin\\///' | gxargs -r -n 1 git push --delete origin; \
          git branch --merged | grep -v main | gxargs -r -n 1 git branch -d; \
          git branch -vv | grep ': gone]'|  grep -v '\\*' | awk '{ print $1; }' | gxargs -r git branch -D; \
          git fetch --all --prune; \
          git prune; \
          git gc --aggressive;
        '';
        wopsy = "commit -a --amend --no-edit";
      };

      init.defaultBranch = "main";

      commit.verbose = true;

      push.autoSetupRemote = true;

      merge = {
        stat = "true";
        conflictstyle = "zdiff3";
        tool = "meld";
      };

      rebase = {
        updateRefs = true;
        autoSquash = true;
        autoStash = true;
      };
    };

    lfs.enable = true;
  };

  programs.delta = {
    inherit (config.programs.git) enable;
    enableGitIntegration = true;
    options = {
      line-numbers = true;
      hyperlinks = true;
      side-by-side = true;
      navigate = true;
    };
  };
}
