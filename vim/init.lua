vim.g.mapleader = ","
vim.g.maplocalleader = ","

local opt = vim.opt

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none", "--branch=stable",
    "https://github.com/folke/lazy.nvim.git", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    opts = {
      heading = {
        icons = { "", "", "", "", "", "" },
        position = "inline",
        sign = false,
        width = "full",
      },
      code = {
        conceal_delimiters = false,
        language = false,
        sign = false,
        border = "none",
        width = "block",
        right_pad = 2,
      },
    },
  },
}, {
  change_detection = { notify = false },
})


-- UI
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"      -- avoid layout shift
opt.cursorline = true
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.termguicolors = true
opt.showmode = false        -- statusline shows mode
opt.laststatus = 3          -- global statusline
opt.splitright = true
opt.splitbelow = true
opt.wrap = false
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Indent
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.smartindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true
opt.inccommand = "split"    -- live preview for :s

-- Files / undo
opt.undofile = true
opt.swapfile = false
opt.backup = false
opt.confirm = true          -- ask instead of failing on unsaved buffers

-- Performance
opt.updatetime = 250
opt.timeoutlen = 400
opt.lazyredraw = false      -- can break some plugins; off by default

-- Behavior
opt.mouse = "a"
opt.clipboard = "unnamedplus"

if os.getenv("SSH_TTY") or os.getenv("SSH_CONNECTION") then
  vim.g.clipboard = {
    name = "OSC 52",
    copy = {
      ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
      ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
    },
    paste = {
      ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
      ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
    },
  }
end
opt.completeopt = { "menu", "menuone", "noselect" }
opt.shortmess:append("cI")  -- less noisy, no intro screen

-- Diagnostics (used if you later add LSP)
vim.diagnostic.config({ virtual_text = true, severity_sort = true })

-- Keymaps
local map = vim.keymap.set
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })
map("n", "<leader>w", "<cmd>write<CR>", { desc = "Save" })
map("n", "<leader>q", "<cmd>quit<CR>", { desc = "Quit" })

-- Better up/down with wrapped lines
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Window/tmux pane navigation (no plugin needed)
local function tmux_nav(dir, tmux_dir)
  local win = vim.api.nvim_get_current_win()
  vim.cmd("wincmd " .. dir)
  if vim.api.nvim_get_current_win() == win then
    vim.fn.system("tmux select-pane -" .. tmux_dir)
  end
end
map("n", "<C-h>", function() tmux_nav("h", "L") end)
map("n", "<C-j>", function() tmux_nav("j", "D") end)
map("n", "<C-k>", function() tmux_nav("k", "U") end)
map("n", "<C-l>", function() tmux_nav("l", "R") end)

-- Keep selection when indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Move highlighted lines
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")

-- Yank without overwriting register on paste/delete-into-clipboard
map("x", "<leader>p", [["_dP]], { desc = "Paste without yank" })
map({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete without yank" })

-- Autocommands
local aug = vim.api.nvim_create_augroup("user", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
  group = aug,
  callback = function() vim.highlight.on_yank({ timeout = 150 }) end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  group = aug,
  callback = function()
    local save = vim.fn.winsaveview()
    vim.cmd([[%s/\s\+$//e]])      -- strip trailing whitespace
    vim.fn.winrestview(save)
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    pcall(vim.treesitter.start)
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.breakindent = true
    vim.opt_local.showbreak = "↳ "
    vim.opt_local.list = false
  end,
})
