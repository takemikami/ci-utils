#!/bin/sh

install_pkg() {
  PKG=$1
  type $PKG > /dev/null
  if [ $? -eq 1 ]; then
    type apk > /dev/null 2>&1
    if [ $? -eq 0 ]; then
      apk add $PKG
      return
    fi
    type pacman > /dev/null 2>&1
    if [ $? -eq 0 ]; then
      pacman -S $PKG
      return
    fi
    type yum > /dev/null 2>&1
    if [ $? -eq 0 ]; then
      yum -y install $PKG
      return
    fi
    type apt-get > /dev/null 2>&1
    if [ $? -eq 0 ]; then
      apt-get install -y $PKG
      return
    fi
  fi
}

# Get target branch from commandline-argument
TARGET_BRANCH=master
if [ $# -ge 1 ]; then
  TARGET_BRANCH=$1
fi

echo "================================"
echo " ci-utils installation"
echo "  branch: $TARGET_BRANCH"
echo "================================"

# Install prerequisite modules
type apk > /dev/null 2>&1
if [ $? -eq 0 ]; then
  apk update
fi
install_pkg jq

# Install ci-utils
rm -rf $HOME/.ci-utils
mkdir $HOME/.ci-utils
curl -L https://github.com/takemikami/ci-utils/archive/$TARGET_BRANCH.tar.gz | tar zx -C $HOME/.ci-utils --strip-components 1

export PATH=$PATH:$HOME/.ci-utils
