{
  pkgs,
  ...
}:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    withNodeJs = true;
    plugins = with pkgs.vimPlugins; [
      # keep-sorted start
      catppuccin-nvim
      cmp-buffer
      cmp-nvim-lsp
      cmp-path
      conform-nvim
      cord-nvim
      gitsigns-nvim
      lualine-nvim
      mini-nvim
      nvim-cmp
      nvim-lspconfig
      nvim-navic
      nvim-tree-lua
      nvim-treesitter.withAllGrammars
      plenary-nvim
      telescope-file-browser-nvim
      telescope-fzf-native-nvim
      telescope-nvim
      which-key-nvim
      # keep-sorted end
    ];
    extraPackages = with pkgs; [
      # keep-sorted start
      astro-language-server
      bash-language-server
      emmet-language-server
      lua-language-server
      nil
      nixd
      nixfmt-rfc-style
      prettier
      ripgrep
      rust-analyzer
      tailwindcss-language-server
      nodePackages.typescript
      vtsls
      vue-language-server
      yaml-language-server
      # keep-sorted end
    ];

    extraConfig = ''
      set runtimepath^=${./config}
      source ${./config}/.vimrc
      luafile ${./config}/init.lua
    '';
  };
}
