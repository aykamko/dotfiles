# tab completion in project directory
cdp() { cd $HOME/twitch/$1; }
compctl -f -W $HOME/twitch/ cdp

export GOPATH="$HOME/go"
export FLEX_HOME="/Users/alekskamko/Library/Flex/flex_sdk_4.6"

export PATH="$FLEX_HOME/bin:$PATH"
export PATH="$GOPATH/bin:$PATH"
