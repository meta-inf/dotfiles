set -e
if [ ! -e ~/Anaconda3-5.1.0-Linux-x86_64.sh ]; then
    wget https://mirrors.tuna.tsinghua.edu.cn/anaconda/archive/Anaconda3-5.1.0-Linux-x86_64.sh -P $HOME
fi
chmod +x ~/Anaconda3-5.1.0-Linux-x86_64.sh
ln -s "$(pwd)/.condarc" ~/.condarc
bash ~/Anaconda3-5.1.0-Linux-x86_64.sh -b -p $HOME/anaconda3
# echo "pip install tensorflow-gpu" > /tmp/_setup.sh
# bash /tmp/_setup.sh
