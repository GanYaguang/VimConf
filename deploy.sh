#!/bin/sh

# This script is used to deploy some settings for linux env
# Author  : Gan Yaguang
echo "deploy start..."

git clone git@github.com:GanYaguang/VimConf.git ~/VimConf

#bak .vimrc .vim .tmux.conf .bashrc
mv ~/.bashrc ~/.bashrc-bak
mv ~/.tmux.conf ~/.tmux.conf-bak
mv ~/.vimrc ~/.vimrc-bak
mv ~/.vim ~/.vim-bak

ln -s ~/VimConf/conf/bashrc ~/.bashrc
ln -s ~/VimConf/conf/tmux.conf ~/.tmux.conf
ln -s ~/VimConf/vim/_vimrc ~/.vimrc
ln -s ~/VimConf/vim/vimrc ~/.vim

git clone http://github.com/gmarik/vundle.git ~/.vim/bundle/vundle

vim +BundleInstall +qa

# make command-t plugin and this need install ruby-dev
cd ~/.vim/bundle/command-t/ruby/command-t && ruby extconf.rb && make

echo "Done."
