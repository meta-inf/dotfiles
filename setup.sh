mkdir -p ~/.config
ln -s "$(pwd)/.vim" ~/.config/nvim
ln -s "$(pwd)/.vim" ~/.vim
ln -s "$(pwd)/.vimrc" ~/.vimrc

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
