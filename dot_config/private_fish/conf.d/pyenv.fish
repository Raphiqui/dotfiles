set -gx PYENV_ROOT $HOME/.pyenv
set -gx PATH $PYENV_ROOT/bin $PATH

status --is-interactive; and pyenv init --path | source
status --is-interactive; and pyenv init - | source
status --is-interactive; and pyenv virtualenv-init - | source
