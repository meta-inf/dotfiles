mkdir -p ~/.config
ln -s "$(pwd)/.tmux.conf" ~/.tmux.conf
ln -s "$(pwd)/.vim" ~/.config/nvim
ln -s "$(pwd)/.vim" ~/.vim
ln -s "$(pwd)/.vimrc" ~/.vimrc
# `.vim` is no longer tracked for changes here
ln -s "$(pwd)/.vimrc" ~/.config/nvim/init.vim

mkdir -p ~/.local/bin

if [ ! -e $HOME/.exports ]; then
	echo "export PATH=$HOME/.local/bin:$PATH" > ~/.exports
	echo "source $HOME/.exports" >> ~/.bashrc
fi

pushd ~/.local/bin
curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
mv nvim.appimage vim
chmod u+x vim
popd
