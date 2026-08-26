vim.g.mapleader = ","
vim.g.maplocalleader = ","

local opt = vim.opt

-- Auto-heal corrupted ShaDa (runs before nvim's own shada read at step 12)
local shada = vim.fn.stdpath("state") .. "/shada/main.shada"
for _, f in ipairs(vim.fn.glob(shada .. ".tmp.*", false, true)) do
  local stat = vim.uv.fs_stat(f)
  if stat and os.time() - stat.mtime.sec > 3600 then
    os.remove(f)
  end
end
if not pcall(vim.cmd, "rshada!") then
  os.remove(shada)
  pcall(vim.cmd, "rshada!")
end

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none", "--branch=stable",
    "https://github.com/folke/lazy.nvim.git", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Markdown rendered the way Claude Code renders it in the terminal.
-- Values below are taken from the Claude Code renderer, not approximated:
--   h1 -> bold+italic+underline, h2..h6 -> bold, '#' concealed
--   unordered bullets -> '-' at every depth
--   ordered bullets   -> depth 1 '1.', depth 2 'a.', depth 3 'i.'
--   block quote       -> dim U+258E plus a space, body italic
--   inline code       -> rgb(177,185,249) dark / rgb(87,105,247) light, no background
--   fenced code       -> syntax highlight only, no border, background, or language label
--                        (the ``` lines themselves are kept, see code.border below)
--   thematic break    -> literal '---'
--   tables            -> ASCII pipes, padded cells, no outer border
--   task list         -> literal '[ ]' and '[x]'

local md = {}

-- 1 -> 'a', 26 -> 'z', 27 -> 'aa'
function md.alpha(n)
  local out = ""
  while n > 0 do
    n = n - 1
    out = string.char(97 + n % 26) .. out
    n = math.floor(n / 26)
  end
  return out
end

md.roman_pairs = {
  { 1000, "m" }, { 900, "cm" }, { 500, "d" }, { 400, "cd" },
  { 100, "c" }, { 90, "xc" }, { 50, "l" }, { 40, "xl" },
  { 10, "x" }, { 9, "ix" }, { 5, "v" }, { 4, "iv" }, { 1, "i" },
}

function md.roman(n)
  local out = ""
  for _, pair in ipairs(md.roman_pairs) do
    while n >= pair[1] do
      out = out .. pair[2]
      n = n - pair[1]
    end
  end
  return out
end

-- Claude Code palette, dark and light variants.
md.palette = {
  dark = {
    inline_code = "#b1b9f9",  -- theme key 'permission'
    dim = "#999999",          -- theme key 'inactive', stands in for ANSI dim
  },
  light = {
    inline_code = "#5769f7",
    dim = "#666666",
  },
}

function md.highlights()
  local c = md.palette[vim.o.background == "light" and "light" or "dark"]
  local hl = vim.api.nvim_set_hl

  -- Inline code: foreground only, no background block.
  hl(0, "RenderMarkdownCodeInline", { fg = c.inline_code })
  hl(0, "@markup.raw.markdown_inline", { fg = c.inline_code })

  -- Bullets, heading markers, and table pipes are plain text.
  for _, group in ipairs({
    "RenderMarkdownBullet",
    "RenderMarkdownHeadingIcon",
    "RenderMarkdownTableHead",
    "RenderMarkdownTableRow",
    "@markup.list.markdown",
  }) do
    hl(0, group, { link = "Normal" })
  end

  -- Table header cells are captured as @markup.heading. Claude Code does not
  -- embolden them, and heading levels 1..6 are set explicitly below.
  hl(0, "@markup.heading.markdown", { link = "Normal" })

  -- Quote bar is dim, quote body is italic.
  hl(0, "RenderMarkdownQuote", { fg = c.dim })
  hl(0, "@markup.quote.markdown", { italic = true })

  -- Headings carry no color of their own, only weight.
  hl(0, "@markup.heading.1.markdown", { bold = true, italic = true, underline = true })
  for level = 2, 6 do
    hl(0, ("@markup.heading.%d.markdown"):format(level), { bold = true })
  end

  hl(0, "@markup.strong", { bold = true })
  hl(0, "@markup.italic", { italic = true })
  hl(0, "@markup.strikethrough", { strikethrough = true })
end

require("lazy").setup({
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
    main = "nvim-treesitter.configs",
    opts = {
      ensure_installed = {
        "bash", "c", "css", "diff", "dockerfile", "go", "html", "javascript",
        "json", "lua", "markdown", "markdown_inline", "python", "ruby", "rust",
        "sql", "toml", "tsx", "typescript", "vim", "vimdoc", "yaml",
      },
      highlight = { enable = true },
    },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      sign = { enabled = false },

      heading = {
        -- An empty icon conceals the '#' marker and inlines nothing in its place.
        icons = { "" },
        position = "inline",
        sign = false,
        width = "block",
        backgrounds = {},
        foregrounds = { "RenderMarkdownHeadingIcon" },
        border = false,
      },

      code = {
        sign = false,
        language = false,
        -- Deliberate divergence from Claude Code: keep the ``` lines visible
        -- instead of concealing them and removing the lines they sit on.
        conceal_delimiters = false,
        border = "none",
        disable_background = true,
        width = "block",
        left_pad = 0,
        right_pad = 0,
        inline = true,
        inline_left = "",
        inline_right = "",
        inline_pad = 0,
        highlight_inline = "RenderMarkdownCodeInline",
      },

      bullet = {
        icons = "-",
        ordered_icons = function(ctx)
          local value = vim.trim(ctx.value)
          local n = tonumber(value:sub(1, #value - 1)) or ctx.index
          if n < 1 then
            n = ctx.index
          end
          if ctx.level == 2 then
            return md.alpha(n) .. "."
          elseif ctx.level == 3 and n <= 3999 then
            return md.roman(n) .. "."
          end
          return ("%d."):format(n)
        end,
        left_pad = 0,
        right_pad = 0,
        highlight = "RenderMarkdownBullet",
      },

      quote = {
        icon = "▎",
        repeat_linebreak = true,
        highlight = "RenderMarkdownQuote",
      },

      pipe_table = {
        cell = "padded",
        padding = 1,
        min_width = 3,
        border_enabled = false,
        -- stylua: ignore
        border = {
          "|", "|", "|",
          "|", "|", "|",
          "|", "|", "|",
          "|", "-",
        },
        alignment_indicator = "-",
        head = "RenderMarkdownTableHead",
        row = "RenderMarkdownTableRow",
      },

      -- Claude Code leaves all of these as literal source text.
      dash = { enabled = false },
      checkbox = { enabled = false },
      link = { enabled = false },
      html = { enabled = false },
      latex = { enabled = false },
      inline_highlight = { enabled = false },
    },
  },
}, {
  change_detection = { notify = false },
})

md.highlights()
-- ColorScheme does not always fire when only 'background' changes, so watch both.
vim.api.nvim_create_autocmd({ "ColorScheme", "OptionSet" }, {
  group = vim.api.nvim_create_augroup("markdown_claude_highlights", { clear = true }),
  pattern = { "*", "background" },
  callback = function(args)
    if args.event == "OptionSet" and args.match ~= "background" then
      return
    end
    md.highlights()
  end,
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
    -- Fallback if nvim-treesitter did not attach. render-markdown needs a parser.
    if not vim.b.ts_highlight then
      pcall(vim.treesitter.start)
    end
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.breakindent = true
    -- Claude Code shows no wrap marker. Two spaces also let the quote bar
    -- repeat correctly on wrapped lines.
    vim.opt_local.showbreak = "  "
    vim.opt_local.breakindentopt = ""
    vim.opt_local.list = false
  end,
})
