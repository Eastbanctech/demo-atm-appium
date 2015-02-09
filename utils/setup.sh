#!/bin/bash

echo "This script will install the required components to run appium tests"

echo "set ulimit to 2560"
sudo ulimit -n 2560

sudo xcode-select --install

echo -n "Verifying supported Operation System..."

if [[ "$OSTYPE" == "darwin"* ]]; then
  echo "[OK]"
else 
  echo "[ERROR]"
  echo "Mac OS is the only supported operation system"
  exit 1
fi


echo -n "Verifying brew installation..."

if ! type "brew" > /dev/null 2>&1; then
  echo "[NOT FOUND]"
  echo "Installing brew"
  ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
else
  echo "[OK]"
fi


echo -n "Verifying node installation..."

if ! type "node" > /dev/null 2>&1; then
  echo "[NOT FOUND]"
  echo "Installing node"
  brew install node
else
  echo "[OK]"
fi


echo -n "Verifying appium installation..."

if ! type "appium" > /dev/null 2>&1; then
  echo "[NOT FOUND]"
  echo "Installing appium"
  sudo npm install -g appium
else
  echo "[OK]"
fi


echo -n "Verifying rvm installation..."

if ! type "rvm" > /dev/null 2>&1; then
  echo "[NOT FOUND]"
  echo "Installing rvm"
  curl -sSL https://get.rvm.io | bash -s stable
  rvm install ruby-1.9.3-p547
  rvm ruby-1.9.3-p547@rcn --create
else
  echo "[OK]"
  rvm ruby-1.9.3-p547@rcn --create
fi


echo -n "Verifying bundle installation..."

if ! type "bundle" > /dev/null 2>&1; then
  echo "[NOT FOUND]"
  echo "Installing bundler"
  sudo gem install bundler
else
  echo "[OK]"
fi


echo "Verifying installed ruby packages..."
if true; then
  bundle install
fi

echo "Setup is successfully finished. You can run your tests"
