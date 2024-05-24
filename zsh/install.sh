#!/bin/bash

config_path=$(pwd)

dependencies() {
  arch=$(uname -s)
  echo "Checking dependencies for $arch..."
  case $arch in
  Darwin)
    if [[ $(which brew | grep "not found") ]]; then
      read -p "brew not found! Try installing it? (y/n) " confirm && [[ $confirm == [yY] ]] || exit 1
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
      echo "➜ brew - OK!"
    fi

    brew=$(brew list)
    brew_git=$(echo "$brew" | grep 'git$')
    brew_zsh=$(echo "$brew" | grep zsh)

    if [[ ! $brew_zsh ]]; then
      read -p "zsh not found! Try installing it? (y/n) " confirm && [[ $confirm == [yY] ]] || exit 1
      brew install zsh
      echo "Installing oh-my-zsh"
      sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    else
      echo "➜ zsh - OK!"
    fi
    if [[ ! $brew_git ]]; then
      read -p "git not found! Try installing it? (y/n) " confirm && [[ $confirm == [yY] ]] || exit 1
      brew install git 
    else
      echo "➜ git - OK!"
    fi
    ;;
  Linux)
   if [[ -e "/etc/debian_version" ]]; then
        if [[ $(which zsh | grep "not found") ]]; then
          read -p "zsh not found! Try installing it? (y/n) " confirm && [[ $confirm == [yY] ]] || exit 1
          sudo apt install zsh -y
        else
          echo "➜ zsh - OK!"
        fi
        if [[ $(which git | grep "not found") ]]; then
          read -p "git not found! Try installing it? (y/n) " confirm && [[ $confirm == [yY] ]] || exit 1
          sudo apt install git -y
        else
          echo "➜ git - OK!"
        fi
    fi
    ;;
  *)
    echo 'OS not supported!'
    echo 'The installation relies in git and zsh'
    read -p "Do you want to continue? (y/n) " confirm && [[ $confirm == [yY] ]] || exit 1
    ;;
  esac
}

dotfiles() {
  if [[ ! -e ".zshrc" || ! -e "kaz.zsh-theme" ]]; then
  echo "Kaz's config files not found!"
  git clone https://github.com/definitelynotkaz/dotfiles ./kaz-zsh-temp/
  config_path="./kaz-zsh-temp/zsh"
fi

}

cleanup() {
  if echo "$config_path" | grep -q "./kaz-zsh-temp/zsh"; then
    echo "Removing temp directory"
    rm -rf "./kaz-zsh-temp"
  fi
}

dependencies

dotfiles

echo "Installing zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions > /dev/null 2>&1

echo "Installing zsh-syntax-highlighting"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting > /dev/null 2>&1

cp "$config_path/.zshrc" ~/.zshrc
cp "$config_path/kaz.zsh-theme" ~/.oh-my-zsh/custom/themes/kaz.zsh-theme

cleanup

zsh
source ~/.zshrc