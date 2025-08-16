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

-- Automatically display type information in the status line when
-- holding the cursor over an identifier
vim.g.go_auto_type_info = 1

-- Enable hybrid line numbering
vim.o.number = true
vim.o.relativenumber = true

-- Enable sign column
vim.o.signcolumn = "yes"

-- Set termguicolors to enable highlight groups (for nvim-tree)
vim.opt.termguicolors = true

-- Set tabs to be 4 spaces in width (seemed to be 8 by default)
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

local keyset = vim.keymap.set

-- GoTo code navigation
keyset("n", "gd", "<Plug>(coc-definition)", {silent = true})
keyset("n", "gy", "<Plug>(coc-type-definition)", {silent = true})
keyset("n", "gi", "<Plug>(coc-implementation)", {silent = true})
keyset("n", "gr", "<Plug>(coc-references)", {silent = true})

-- Use K to show documentation in preview window
function _G.show_docs()
    local cw = vim.fn.expand('<cword>')
    if vim.fn.index({'vim', 'help'}, vim.bo.filetype) >= 0 then
        vim.api.nvim_command('h ' .. cw)
    elseif vim.api.nvim_eval('coc#rpc#ready()') then
        vim.fn.CocActionAsync('doHover')
    else
        vim.api.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
    end
end
keyset("n", "K", '<CMD>lua _G.show_docs()<CR>', {silent = true})

-- Use K to show documentation in preview window
function _G.show_docs()
    local cw = vim.fn.expand('<cword>')
    if vim.fn.index({'vim', 'help'}, vim.bo.filetype) >= 0 then
        vim.api.nvim_command('h ' .. cw)
    elseif vim.api.nvim_eval('coc#rpc#ready()') then
        vim.fn.CocActionAsync('doHover')
    else
        vim.api.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
    end
end
keyset("n", "K", '<CMD>lua _G.show_docs()<CR>', {silent = true})

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
    },
    sections = {
      lualine_c = {
		{
	      'filename',
		  path = 3,
	    },
	  },
	},
  }

  -- Git messenger floating window (shows commit message for particular code line)
  use {"rhysd/git-messenger.vim"}

  -- Git signs in sign column
  use {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup()
    end
  }

  -- Markdown previews withing nvim (does not support images)
  use {"ellisonleao/glow.nvim"}

  -- In-browser Markdown previews (supports images)
  use({
    "iamcco/markdown-preview.nvim",
    run = function() vim.fn["mkdp#util#install"]() end,
  })

  -- nvim-tree requires a patched font to display file icons in the file tree
  -- "patched font": a font that has had a bunch of extra icons and glyphs added to it
  -- https://github.com/ryanoasis/nerd-fonts/releases/download/v2.2.2/DroidSansMono.zip is a good one
  use {
    'nvim-tree/nvim-tree.lua',
    requires = {
      'nvim-tree/nvim-web-devicons', -- optional, for file icons
    },
  }

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

  -- Provides syntax highlighting, goto functionality, etc. for Python;
  -- requires the pynvim Python module to be available in the active Python
  -- environment while nvim is running
  use 'davidhalter/jedi-vim'

  -- HCL syntax highlighting and commands
  use 'hashivim/vim-terraform'

  use 'lervag/vimtex'

  -- For Rust LSP support via rust-analyzer: https://rust-analyzer.github.io/book/other_editors.html#vimneovim
  use {
	  'neoclide/coc.nvim',
	  branch = 'release'
  }
 
  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)
