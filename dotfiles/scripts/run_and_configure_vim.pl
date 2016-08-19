use strict;
use warnings;

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
    my $current_time_str = join("_", split(/ /, localtime));
    my $dir_name = "~/backup/vim_backup_" . $current_time_str;
    my $create_backup_dir = `mkdir -p $dir_name`;
    my $move_vimrc = `mv ~/.vimrc $dir_name`;
    my $move_vim = `mv ~/.vim/ $dir_name`;
    my $move_dotfiles = `mv ~/.dotfiles/ $dir_name`;
}

sub setup_dotfiles {
    #created dotfiles
    print_me "Configuring dotfiles\n";
    my $create_dotfiles = `mkdir -p ~/.dotfiles/`;
    my $dotfiles_dir = "~/.dotfiles/dotfiles";
    print_me("dotfiles dir = $dotfiles_dir");
    my $setup_correct = setup_from_git("Dotfiles", "https://github.com/kabir-sohel/dotfiles.git", $dotfiles_dir, {});

    #copy from dotfiles
    #my @to_copy = qw(.plugin_options .ctags .bashrc .alias .tmux.conf .vimrc .vimrc_braces .vimrc_pathogen .vimrc_vundle );
    my @to_copy = qw(.plugin_options .vimrc_braces .vimrc_pathogen .vimrc_vundle);
    my $created_butdle = `mkdir -p ~/.vim/bundle`;
    foreach my $item(@to_copy){
        my $result = `ln -s $dotfiles_dir/$item ~/.vim/bundle`;
    }
    my $link_vimrc = `ln -s $dotfiles_dir/.vimrc ~/.vimrc`;
    my $vim_plugins_dir = $dotfiles_dir . "/vim_plugins";
    my @vim_files = `ls $vim_plugins_dir`;
    chomp @vim_files;
    @vim_files = grep { $_ =~ /.vim$/ } @vim_files;
    print_me("following vim files will be symlinked");
    print(@vim_files);
    foreach my $vim_file(@vim_files){
        my $linked = `ln -s $vim_plugins_dir/$vim_file ~/.vim/$vim_file`;
    }
}

sub install_plugins {
	print_me("...\n...\n...\n...\n");
    print_me("..............**************************....................");
    print_me("............. Vim setup complete. Installing plugins, it may take a few moments. .....................");
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
#    print_me "Cloning Vundle.vim";
#    my $result = undef;
#    eval {
#        $result = `git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim`;
#    } or do {
#        print_me "Failed to git clone, please check your git setup";
#        print_me $@ if $@;
#        #exit;
#    };
#    warn $@ if $@;
#
#    print_me "Successfully git cloned\n";
}

sub update_vim {
    print_me "Upgrading vim.... will install fresh vim and do a lots of staffs, dont panic if something isn't perfectly installed";
    print_me "Please note that you may need to type y to give permission to install necessary softwares";
    my $update_vim_from_sh = `sh ~/.dotfiles/dotfiles/scripts/build_vim.sh`;
    print_me "Vim setup finished succesfully";
}
sub install_ycm {
    print_me "Setting ycm for the upgraded vim, dont panic if something isn't pefectly installed"; 
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
            install_ycm();
        }
    }
}

back_up_everything();
setup_dotfiles();
setup_pathogen();
setup_vundle();
install_plugins();
check_vim_version();

