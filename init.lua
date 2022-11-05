-- Additional syntax highlighting functionality for Go via vim-go;
-- vim-go leaves a lot of syntax highlighting off by default because
-- the additional highlighting can affect vim's performance
vim.g.go_highlight_types = 1
vim.g.go_highlight_fields = 1
vim.g.go_highlight_functions = 1
vim.g.go_highlight_function_calls = 1
vim.g.go_highlight_operators = 1
vim.g.go_highlight_extra_types = 1
vim.g.go_highlight_build_constraints = 1
vim.g.go_highlight_generate_tags = 1

-- Enable hybrid line numbering
vim.o.number = 1
vim.o.relativenumber = 1

-- Set termguicolors to enable highlight groups (for nvim-tree)
vim.opt.termguicolors = true

-- This code installs packer and came from https://github.com/wbthomason/packer.nvim#bootstrapping
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  -- Dracula theme
  use 'Mofiqul/dracula.nvim'
  vim.cmd[[colorscheme dracula]]

  -- lualine (status line plugin)
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }

  -- Use lualine and use dracula-nvim color scheme
  require('lualine').setup {
    options = {
      theme = 'dracula-nvim'
    }
  }

  -- nvim-tree requires a patched font to display file icons in the file tree
  -- "patched font": a font that has had a bunch of extra icons and glyphs added to it
  -- https://github.com/ryanoasis/nerd-fonts/releases/download/v2.2.2/DroidSansMono.zip is a good one
  use {
    'nvim-tree/nvim-tree.lua',
    requires = {
      'nvim-tree/nvim-web-devicons', -- optional, for file icons
    },
  }

  -- setup() function can be used to configure as desired
  require("nvim-tree").setup()

  -- When setting up on new machine, need to run :GoInstallBinaries to install dependencies 
  use 'fatih/vim-go'

  use {
    "Pocco81/true-zen.nvim",
    config = function()
      -- setup() function can be used to configure as desired
      require("true-zen").setup()
    end
  }

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)
