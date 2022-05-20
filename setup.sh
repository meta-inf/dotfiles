mkdir -p ~/.config
ln -s "$(pwd)/.tmux.conf" ~/.tmux.conf
ln -s "$(pwd)/.vim" ~/.config/nvim
ln -s "$(pwd)/.vim" ~/.vim
ln -s "$(pwd)/.vimrc" ~/.vimrc
# `.vim` is no longer tracked for changes here
ln -s "$(pwd)/.vimrc" ~/.config/nvim/init.vim
ln -s "$(pwd)/.bashrc" ~/.bashrc

mkdir -p ~/.local/bin
ln -s "$(pwd)/ag.py" ~/.local/bin/aggr
chmod +x ~/.local/bin/aggr

# if [ ! -e $HOME/.exports ]; then
# 	echo "export PATH=\$HOME/.local/bin:\$PATH" > ~/.exports
# fi
if [ ! -e $HOME/.bash_profile ]; then
	echo "source ~/.bashrc" > ~/.bash_profile
fi

pushd ~/.local/bin
curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
mv nvim.appimage vim
chmod u+x vim
popd

git config --global user.email "wzy196@gmail.com"
git config --global user.name "meta-inf"
git config --global core.autocrlf input

echo "\n" | ~/.local/bin/vim +PlugInstall +qall!
g++ ag.cc -o ag
