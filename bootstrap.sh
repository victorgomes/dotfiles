#!/usr/bin/env zsh

# A simple script for setting up OSX enviroment, based on https://github.com/paulmillr/dotfiles

dev="$HOME/dev"
pushd .
mkdir -p $dev
cd $dev

echo 'Enter new hostname of the machine (e.g. macbook-victor)'
  read hostname
  echo "Setting new hostname to $hostname..."
  scutil --set HostName "$hostname"
  echo "Setting computer name to $hostname..."
  scutil --set ComputerName "$hostname"
  sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "$hostname"

pub=$HOME/.ssh/id_rsa.pub
echo 'Checking for SSH key, generating one if it does not exist...'
  [[ -f $pub ]] || ssh-keygen -t rsa

# if we on OSX, install homebrew
if [[ `uname` == 'Darwin' ]]; then
  which -s brew
  if [[ $? != 0 ]]; then
    echo 'Installing Homebrew...'
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew update
    brew install git htop
    brew cask install macvim transmission
  fi

  echo 'Tweaking OS X...'
  source 'osx.sh'
fi

echo "Configurating git..."
echo "Enter user name..."
read username
echo "Enter email..."
read email
git config --global user.name "$username"
git config --global user.email $email

popd
