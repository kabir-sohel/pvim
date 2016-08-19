find ../ -type f -prune ! -name .gitconfig -exec cp {} ~/.dotfiles/dotfiles/ \;
cd ../
cp -r ./* ~/.dotfiles/dotfiles/
rm -rf ~/.dotfiles/dotfiles/.gitconfig


