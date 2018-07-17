apt-get install -y zsh #install zsh core
chsh -s $(which zsh) #set zsh as current default shell
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" #install oh-my-zsh
cd ~
git clone https://github.com/mkjmdski/shell-config.git #get current repository
cd shell-config
grep -lr mlodzikos | xargs sed -i "s/mlodzikos/$(whoami)/g" #replace my username with current user 
shopt -s dotglob; cp -R ./* ~ #copy all config files to the home directory with .dotfiles
for custom_plugin in $(cat .custom-plugins); do #install all custom plugins listed in the file
(
    cd ~/.oh-my-zsh/custom/plugins
    git clone $custom_plugin
)
done
for temporary_file in $(cat .temporary_files); do
    rm ~/$temporary_file
done # remove files necessary during the install
zsh