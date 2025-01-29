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
config.keys = {
  -- Create panes tmux-style
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
}

config.window_decorations = 'INTEGRATED_BUTTONS|RESIZE|MACOS_FORCE_DISABLE_SHADOW'
config.color_scheme = 'Arthur (Gogh)'

return config
