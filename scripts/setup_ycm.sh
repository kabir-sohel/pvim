#!/bin/bash
sudo yum install cmake
vim +PluginInstall +qall
cd ~/
mkdir ycm_build
cd ycm_build
cmake -G "Unix Makefiles" . ~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp
make ycm_support_libs

