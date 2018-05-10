#!/bin/sh

update_pkgman() {
  type apk > /dev/null 2>&1
  if [ $? -eq 0 ]; then
    apk update
    return
  fi
  type apt > /dev/null 2>&1
  if [ $? -eq 0 ]; then
    apt update
    return
  fi
}

install_pkg() {
  PKG=$1
  type $PKG > /dev/null
  if [ $? -ne 0 ]; then
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
update_pkgman
install_pkg curl
install_pkg jq

# Install ci-utils
mkdir -p $HOME/.ci-utils
curl -s -L https://github.com/takemikami/ci-utils/archive/$TARGET_BRANCH.tar.gz | tar zx -C $HOME/.ci-utils --strip-components 1

export PATH=$PATH:$HOME/.ci-utils
