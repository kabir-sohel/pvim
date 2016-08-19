use strict;
use warnings;
#version 1.0

sub print_me {
    my $text = shift;
    print $text, "\n";
}

sub setup_from_git {
    my ($name, $url, $location, $options) = @_;
    print_me "Cloning $name from $url , in $location";
    my $result = undef;
    $result = `git clone $url $location`;
    if($@){
	warn $@;
	print_me "Failed to git clone";
	return 0;
    }
    print_me "Successfully git cloned $name";
    return 1;
}

sub back_up_everything {
    print_me("Backing up .vimrc and .vim into ~/backup/vim_back_x directory");
    my $current_time_str = join("_", split(/ /, localtime));
    my $dir_name = "~/backup/vim_backup_" . $current_time_str;
    my $create_backup_dir = `mkdir -p $dir_name`;
    my $move_vimrc = `mv ~/.vimrc $dir_name`;
    my $move_vim = `mv ~/.vim/ $dir_name`;
}
sub setup_vim_files {
    print_me "Setting up vim files\n";
    my $dotfiles_dir = "~/.dotfiles/dotfiles";
    my $create_or_do_nothing = `mkdir -p $dotfiles_dir`;
    my $git_repo_dir = `pwd`;
    #my $vim_files_dir = "~/github/pvim/dotfiles";
    #print_me("Git repo dir  = $git_repo_dir");
    #my $setup_correct = setup_from_git("vim_files", "https://github.com/kabir-sohel/pvim.git", $git_repo_dir, {});


    #my $copy_everything = `cp -r $vim_files_dir/ $dotfiles_dir/`;
    my $copy_everything = `cp -r dotfiles/ $dotfiles_dir/`;
    
    my $created_bundle = `mkdir -p ~/.vim/bundle`;
    my $link_vimrc = `ln -s $dotfiles_dir/.vimrc ~/.vimrc`;
    my $vim_plugins_dir = $dotfiles_dir . "/vim_plugins";
    my @vim_files = `ls $vim_plugins_dir`;
    chomp @vim_files;
    @vim_files = grep { $_ =~ /.vim$/ } @vim_files;
    print_me("following vim files will be symlinked\n");
    print(@vim_files);
    print_me("\n\n\n");
    foreach my $vim_file(@vim_files){
        my $linked = `ln -s $vim_plugins_dir/$vim_file ~/.vim/$vim_file`;
    }

}

sub install_plugins {
	print_me("...\n...\n...\n...\n");
    print_me("..............**************************....................");
    print_me("............. Vim setup complete. Installing plugins, it may take a few minuites, please dont close the window. .....................");
    print_me("..............**************************....................");
    print_me("..............**************************....................");
    print_me("..............**************************....................");
    print_me("...\n...\n...\n");
    my $plugin_install_result = `vim +PluginInstall +qall`;
    print_me("............. plugin installation complete .....................");
}
sub setup_pathogen {
    #create the directory first
    my $create_dir_result = `mkdir -p ~/.vim/autoload`;
    setup_from_git("Pathogen", 'https://github.com/tpope/vim-pathogen.git', '~/.vim/autoload/pathogen.vim', {});
}
sub setup_vundle {
    setup_from_git('Vundle', 'https://github.com/VundleVim/Vundle.vim.git', '~/.vim/bundle/Vundle.vim', {});
}

sub update_vim {
    print_me "Upgrading vim.... will install fresh vim and do a lots of staffs, dont panic if something isn't perfectly installed";
    print_me "Please note that you may need to type y to give permission to install necessary softwares";
    my $update_vim_from_sh = `sh ~/.dotfiles/dotfiles/scripts/build_vim.sh`;
    print_me "Vim setup finished succesfully";
}
sub install_ycm {
    print_me "If you want to install You Complete Me plugin for vim , press 1";
    my $input = <>;
    chomp $input;
    if($input != 1){
        return;
    }
    print_me "Setting up ycm for the upgraded vim, dont panic if something isn't pefectly installed"; 
    my $update_vim_from_sh = `sh ~/.dotfiles/dotfiles/scripts/setup_ycm.sh`;
    print_me "YCM setup finished succesfully, Enjoy!!";
}

sub check_vim_version {
    my $vim_version = `vim --version`;
    my @texts = split / /, $vim_version;
    $vim_version = $texts[4] * 10;
    if($vim_version >= 74){
        print_me "Your vim version is up to date to run all plugins";
    }else {
        print_me "Warning!!!!! Your vim version is not up to date to run all plugins, YCM wont work. If you want to upgrade your vim and press 1";
        my $input = <>;
        chomp $input;
        if($input == 1){
            update_vim();
        }
    }
}

back_up_everything();
setup_vim_files();
setup_pathogen();
setup_vundle();
install_plugins();
check_vim_version();
install_ycm();

