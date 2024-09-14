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
vim.o.showmode = false
vim.keymap.set("n", "<Esc>", "<Cmd>nohlsearch<CR>")
vim.o.inccommand = "split"
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
require"lazy".setup{
  { "neovim/nvim-lspconfig",
    config = function ()
      local lspconfig = require"lspconfig"
      lspconfig.clangd.setup{}
      lspconfig.rust_analyzer.setup{}
      lspconfig.hls.setup{}
    end
  },
  { "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function ()
      require"nvim-treesitter.configs".setup{
        ensure_installed = { "c", "lua", "rust", "latex", "python", "html", "css", "javascript" },
        highlight = { enable = true },
        incremental_selection = { enable = true },
        indent = { enable = true },
      }
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
      require"mini.basics".setup{
        options = {
          extra_ui = true,
        }
      }
      require"mini.icons".setup{}
      require"mini.statusline".setup{}
      require"mini.files".setup{}
    end
  },
  { "nvim-cmp",
    dependencies = {
      'neovim/nvim-lspconfig',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/nvim-cmp',
    },
    config = function()
      local cmp = require"cmp"
      cmp.setup{
        mapping = cmp.mapping.preset.insert{
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        },
        sources = cmp.config.sources{
          { name = 'nvim_lsp' },
        },
      }
    end
  }
}
vim.api.nvim_create_autocmd("FileType", {
  pattern = "tex",
  callback = function(args)
    vim.keymap.set("n", "<leader>p", function()
      vim.system{"latexmk", args.file}
    end)
  end
})
