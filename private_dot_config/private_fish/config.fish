if status is-interactive
    # Commands to run in interactive sessions can go here
end


# pyenv init
if command -v pyenv 1>/dev/null 2>&1
  pyenv init - | source
end

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

# poetry and other stuff ?
set -x PATH "/home/norsse/.local/bin" $PATH
eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)


export PATH="$PATH:/opt/nvim-linux64/bin"

export FLYCTL_INSTALL="/home/norsse/.fly"
export PATH="$FLYCTL_INSTALL/bin:$PATH" 

# set up default editor
set -Ux EDITOR nvim
set -Ux VISUAL $EDITOR
