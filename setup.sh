#! /bin/bash
# Adapted from https://github.com/nicksp/dotfiles/blob/master/setup.sh mostly
# setup.sh

###############################################################################
# Helper Functions                                                            #
###############################################################################
execute() {
  # Run first arg and print with second
  $1 &> /dev/null
  print_result $? "${2:-$1}"
}
print_result() {
  [ $1 -eq 0 ] \
    && print_success "$2" \
    || print_error "$2"

  [ "$3" == "true" ] && [ $1 -ne 0 ] \
    && exit
}
print_success() {
  # Print output in green
  printf "\e[0;32m  [✔] $1\e[0m\n"
}
print_question() {
  # Print output in yellow
  printf "\e[0;33m  [?] $1\e[0m"
}
print_error() {
  # Print output in red
  printf "\e[0;31m  [✖] $1 $2\e[0m\n"
}

ask_for_confirmation() {
  print_question "$1 (y/n) "
  read -n 1
  printf "\n"
}
answer_is_yes() {
  [[ "$REPLY" =~ ^[Yy]$ ]] \
    && return 0 \
    || return 1
}
###############################################################################



# Warn that this script will overwrite current dotfiles
while true; do
  read -p "Warning: this will overwrite your current dotfiles. Continue? [y/n] " yn
  case $yn in
    [Yy]* ) break;;
    [Nn]* ) exit;;
    * ) echo "Please answer yes or no.";;
  esac
done

# Get the dotfiles directory's absolute path
SCRIPT_DIR="$(cd "$(dirname "$0")"; pwd -P)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"

export DOTFILES_DIR
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

dir=~/dotfiles                        # dotfiles directory
dir_backup=~/dotfiles_old             # old dotfiles backup directory

# Create dotfiles_old in homedir
echo -n "Creating $dir_backup for backup of any existing dotfiles in ~..."
mkdir -p $dir_backup
echo "done"

# Change to the dotfiles directory
echo -n "Changing to the $dir directory..."
cd $dir
echo "done"

declare -a FILES_TO_SYMLINK=(
    'dotfiles/agignore'
    'dotfiles/tmux.conf'
    'dotfiles/vimrc'
    'dotfiles/zshrc'
)

# Move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks from the homedir to any files in the ~/dotfiles directory specified in $files
for i in ${FILES_TO_SYMLINK[@]}; do
  echo "Moving any existing dotfiles from ~ to $dir_backup"
  mv ~/.${i##*/} ~/dotfiles_old/
done

main () {
  local i=''
  local sourceFile=''
  local targetFile=''

  for i in ${FILES_TO_SYMLINK[@]}; do
    sourceFile="$(pwd)/$i"
    targetFile="$HOME/.$(printf "%s" "$i" | sed "s/.*\/\(.*\)/\1/g")"

    if [ ! -w "$targetFile" ]; then
      execute "ln -fs $sourceFile $targetFile" "$targetFile → $sourceFile"
    elif [ "$(readlink "$targetFile")" == "$sourceFile" ]; then
      print_success "$targetFile → $sourceFile"
    else
      ask_for_confirmation "'$targetFile' already exists, do you want to overwrite it?"
      if answer_is_yes; then
        rm -rf "$targetFile"
        execute "ln -fs $sourceFile $targetFile" "$targetFile → $sourceFile"
      else
        print_error "$targetFile → $sourceFile"
      fi
    fi
  done
}

install_zsh () {
  # Test to see if zshell is installed.  If it is:
  if [ -f /bin/zsh -o -f /usr/bin/zsh -o -f /usr/local/bin/zsh ]; then
    # Install Oh My Zsh if it isn't already present
    if [[ ! -d $dir/oh-my-zsh/ ]]; then
      sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    fi
    # Set the default shell to zsh if it isn't currently set to zsh
    if [[ ! $(echo $SHELL) == $(which zsh) ]]; then
      chsh -s $(which zsh)
    fi
  else
    # If zsh isn't installed, get the platform of the current machine
    platform=$(uname);
    # If the platform is Linux, try an apt-get to install zsh and then recurse
    if [[ $platform == 'Linux' ]]; then
      sudo apt-get install zsh
      install_zsh
      # If the platform is OS X, tell the user to install zsh :)
    elif [[ $platform == 'Darwin' ]]; then
      echo "We'll install zsh, then re-run this script!"
      brew install zsh
      exit
    fi
  fi
}

install_nvim() {
  # Test to see if neovim is installed. If it is:
  if [ -f /bin/nvim -o -f /usr/bin/nvim -o -f /usr/local/bin/nvim ]; then
    # install vundle
    git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
    nvim +BundleInstall
  else
    platform=$(uname);
    if [[ $platform == 'Linux' ]]; then
      # https://github.com/neovim/neovim/wiki/Installing-Neovim
      sudo apt-get install software-properties-common
      sudo apt-get install python-software-properties
      sudo add-apt-repository ppa:neovim-ppa/stable
      sudo apt-get update
      sudo apt-get install neovim
      install_nvim
    elif [[ $platform == 'Darwin' ]]; then
      echo "We'll install neovim, then re-run this script!"
      brew install neovim
      exit
    fi
  fi
}

main
install_zsh

# link zsh theme
ln -s ~/dotfiles/themes/ohjannrussell.zsh-theme $HOME/.oh-my-zsh/themes
source ~/.zshrc

if [ ! "$1" = "--skip-nvim" ]; then
    install_nvim
fi
