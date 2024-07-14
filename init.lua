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
vim.g.maplocalleader = " "
vim.o.number = true
vim.o.showmode = false
vim.o.undofile = true
vim.o.undodir = vim.fn.stdpath"state" .. "/undo"
vim.o.ignorecase = true
vim.o.smartcase = true
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.keymap.set("n", "<Esc>", "<Cmd>nohlsearch<CR>")
vim.o.inccommand = "split"
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
require"lazy".setup{
  { "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function ()
      require"nvim-treesitter.configs".setup{
        ensure_installed = { "c", "lua", "rust", "latex", "python" },
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
    dependencies = {"nvim-lua/plenary.nvim"},
    config = function()
      local builtin = require"telescope.builtin"
      vim.keymap.set("n", "<leader>f", builtin.find_files)
      vim.keymap.set("n", "<leader>b", builtin.buffers)
    end
  },
  { "echasnovski/mini.nvim",
    version = false,
    config = function()
      require"mini.icons".setup{}
      require"mini.statusline".setup{}
    end
  },
}
vim.o.foldmethod = "expr"
vim.o.foldexpr = "nvim_treesitter#foldexpr()"
vim.api.nvim_create_autocmd("FileType", {
  pattern = "tex",
  callback = function(args)
    vim.keymap.set("n", "<leader>p", function()
      vim.system{"latexmk", args.file}
    end)
  end
})
