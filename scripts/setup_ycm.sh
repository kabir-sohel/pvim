#!/bin/bash
#sudo yum install cmake


#need to download cmake source and install it
mkdir -p ~/Software
cd ~/Software
wget https://cmake.org/files/v3.6/cmake-3.6.3.tar.gz
tar -xf cmake-3.6.3.tar.gz
cd cmake-3.6.3
./bootstrap
sudo make
sudo ake install



vim +PluginInstall +qall
cd ~/
mkdir -p ycm_build
cd ycm_build
#cmake -G "Unix Makefiles" . ~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp
/usr/local/bin/cmake -G "Unix Makefiles" . ~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp
cmake --build . --target ycm_core --config Release
make ycm_support_libs

