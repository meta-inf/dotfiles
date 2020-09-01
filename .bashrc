alias tmux='tmux -2'
alias gst='git status '
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
alias sact='source deactivate && source activate '
alias cact='conda deactivate && conda activate '
alias jbl='jupyter notebook list'

register-venv() {
    if [ -z "$CONDA_DEFAULT_ENV" ]; then
        echo "not in conda env"
        return 1
    fi
    ipython kernel install --user --name=$CONDA_DEFAULT_ENV
}

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

usecuda() {
    CR=/usr/local/cuda-$1
    if ! [[ -d $CR ]]; then
        CR=$HOME/.local/cuda-$1
        if ! [[ -d $CR ]]; then
            echo "cuda-$1 not found"
            return 1
        fi
    fi
    export CUDA_ROOT=$CR
    export PATH=$CUDA_ROOT/bin:$PATH
    export LD_LIBRARY_PATH=$CUDA_ROOT/lib64:$LD_LIBRARY_PATH
}

export PS1="\[\e[48;5;34m\](\${CUDA_VISIBLE_DEVICES:-none}) $PS1\[\e[0m\]"
export EDITOR="vim"

if [ -e ${HOME}/dotfiles/.exports ]; then
    source ${HOME}/dotfiles/.exports
fi
if [ -e ${HOME}/.exports ]; then
    source ${HOME}/.exports
fi
