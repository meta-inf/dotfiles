alias tmux='tmux -2'
alias gst='git status '
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

export PS1="\[\e[48;5;34m\](\${CUDA_VISIBLE_DEVICES:-none}) $PS1\[\e[0m\]"
export EDITOR="vim"

if [ -e ${HOME}/.exports ]; then
    source ${HOME}/.exports
fi
if [ -e ${HOME}/dotfiles/.exports ]; then
	source ${HOME}/dotfiles/.exports
fi
