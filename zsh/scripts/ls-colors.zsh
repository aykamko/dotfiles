# vim: set ft=zsh:
# Color `ls` output with directories in bold green. Covers BSD ls (macOS) and
# GNU ls (Linux, devboxes over ssh). Skipped when `ls` is aliased to lsd, which
# colors on its own.
(( $+aliases[ls] )) && return

if [[ $UNAME == darwin ]]; then
  export CLICOLOR=1
  # BSD default scheme, first pair (directory) changed from blue to bold green.
  export LSCOLORS=Cxfxcxdxbxegedabagacad
else
  # Keep an existing LS_COLORS. Underline other-writable directories (ow, tw)
  # instead of the default green background.
  export LS_COLORS=${LS_COLORS:-'di=1;32:ow=1;32;4:tw=1;32;4'}
  # A function, not an alias, so that better_cd (defined earlier) picks it up.
  ls() { command ls --color=auto "$@" }
fi
