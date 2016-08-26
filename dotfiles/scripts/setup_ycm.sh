#!/bin/bash
sudo yum install cmake
vim +PluginInstall +qall
cd ~/
mkdir -p ycm_build
cd ycm_build
cmake -G "Unix Makefiles" . ~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp
cmake --build . --target ycm_core --config Release
make ycm_support_libs

