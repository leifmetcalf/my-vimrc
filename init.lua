local lazypath = vim.fn.stdpath"data" .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system{
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)
vim.g.mapleader = " "
require"lazy".setup{
  { "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function ()
      require"nvim-treesitter.configs".setup{
        ensure_installed = { "c", "lua", "rust" },
        highlight = { enable = true },
        incremental_selection = { enable = true },
        indent = { enable = true },  
      }
    end
  },
  { "neovim/nvim-lspconfig",
    config = function ()
      local lspconfig = require"lspconfig"
      lspconfig.clangd.setup{}
      lspconfig.rust_analyzer.setup{}
    end
  },
  { "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {"nvim-lua/plenary.nvim"}
  },
}
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
local builtin = require"telescope.builtin"
vim.keymap.set("n", "<leader>f", builtin.find_files, {})
vim.keymap.set("n", "<leader>b", builtin.buffers, {})
