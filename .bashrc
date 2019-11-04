alias tmux='tmux -2'
alias gs='git status '
alias ga='git add '
alias gb='git branch '
alias gc='git commit '
alias gp='git push '
alias gcmsg='git commit -m '
alias gd='git diff '
alias gl='git pull '
alias go='git checkout '
alias gk='gitk --all&'
alias gx='gitx --all'
alias got='git '
alias get='git '
alias sact='source activate '
alias jbl='jupyter notebook list'

usegpu() {
        export CUDA_VISIBLE_DEVICES=$1
}

gclone() {
        git clone https://github.com/$1.git
}

gclonepriv() {
        git clone git@github.com:$1.git
}

installjupyterkernel() {
        ipython kernel install --user --name=$1
}

export PS1="(\${CUDA_VISIBLE_DEVICES:-none}) $PS1"

source ${HOME}/.exports
