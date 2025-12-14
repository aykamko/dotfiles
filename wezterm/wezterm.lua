-- Pull in the wezterm API
local wezterm = require 'wezterm'
local act = wezterm.action

local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
  config:set_strict_mode(true)
end

config.leader = { key = 'Space', mods = 'CTRL', timeout_milliseconds = 1000 }
config.keys = {-- Create panes tmux-style
  {
    -- Claude Code Shift+Enter
    key = "Enter", mods = "SHIFT",
    action = wezterm.action { SendString="\x1b\r" }
  },
  {
    mods = 'LEADER', key = 'h',
    action = wezterm.action.SplitPane { direction = 'Left' },
  },
  {
    mods = 'LEADER', key = 'j',
    action = wezterm.action.SplitPane { direction = 'Down' },
  },
  {
    mods = 'LEADER', key = 'k',
    action = wezterm.action.SplitPane { direction = 'Up' },
  },
  {
    mods = 'LEADER', key = 'l',
    action = wezterm.action.SplitPane { direction = 'Right' },
  },
  -- Move panes tmux style
  {
    mods = 'CTRL', key = 'h',
    action = act.ActivatePaneDirection 'Left',
  },
  {
    mods = 'CTRL', key = 'j',
    action = act.ActivatePaneDirection 'Down',
  },
  {
    mods = 'CTRL', key = 'k',
    action = act.ActivatePaneDirection 'Up',
  },
  {
    mods = 'CTRL', key = 'l',
    action = act.ActivatePaneDirection 'Right',
  },
  {
    mods = 'CTRL', key = 'LeftArrow',
    action = act.ActivatePaneDirection 'Left',
  },
  {
    mods = 'CTRL', key = 'DownArrow',
    action = act.ActivatePaneDirection 'Down',
  },
  {
    mods = 'CTRL', key = 'UpArrow',
    action = act.ActivatePaneDirection 'Up',
  },
  {
    mods = 'CTRL', key = 'RightArrow',
    action = act.ActivatePaneDirection 'Right',
  },
  -- Close pane
  {
    mods = 'LEADER', key = 'x',
    action = wezterm.action.CloseCurrentPane { confirm = true },
  },
  -- Zoom pane
  {
    mods = 'LEADER', key = 'z',
    action = wezterm.action.TogglePaneZoomState,
  },
  -- Rebind OPT-Left, OPT-Right to move between words
  {
    key = 'LeftArrow',
    mods = 'OPT',
    action = act.SendKey { key = 'b', mods = 'META' },
  },
  {
    key = 'RightArrow',
    mods = 'OPT',
    action = act.SendKey { key = 'f', mods = 'META' },
  },
}

config.window_decorations = 'INTEGRATED_BUTTONS|RESIZE|MACOS_FORCE_DISABLE_SHADOW'
config.color_scheme = 'Arthur (Gogh)'

-- This function returns the suggested title for a tab.
-- It prefers the title that was set via `tab:set_title()`
-- or `wezterm cli set-tab-title`, but falls back to the
-- title of the active pane in that tab.
local function tab_title(tab_info)
    local title = tab_info.tab_title
    -- if the tab title is explicitly set, take that
    if title and #title > 0 then
        return title
    end
    -- Otherwise, use the title from the active pane
    -- in that tab
    return tab_info.active_pane.title
end

-- function tab_bar.on_format_tab_title(tab, _tabs, _panes, _config, _hover, _max_width)
--     local zoomed = ''
--     local index = tab.tab_index + 1
--     local title = tab_title(tab)
--     if tab.active_pane.is_zoomed then
--         zoomed = '[Z]'
--     end
--     return {
--         { Text = string.format(' %d %s%s ', index, title, zoomed) }
--     }
-- end
--
-- wezterm.on('format-tab-title', tab_bar.on_format_tab_title)

return config
