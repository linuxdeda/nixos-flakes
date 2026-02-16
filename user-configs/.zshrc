# ==============================

export ZSH="$HOME/.oh-my-zsh"


ZSH_THEME="agnoster"
ZSH_THEME_RANDOM_QUIET=true

# ==============================
# Oh-My-Zsh plugin lista
# ==============================

plugins=(
  git
  fast-syntax-highlighting
  copybuffer
  copyfile
  dirhistory
  docker
  sudo
  web-search
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh
