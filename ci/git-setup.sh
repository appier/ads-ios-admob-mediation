#!/bin/sh
set -e

# Workaround old docker images with incorrect $HOME
# check https://github.com/docker/docker/issues/2968 for details
if [ "${HOME}" = "/" ]
then
  export HOME=$(getent passwd $(id -un) | cut -d: -f6)
fi

git --version

mkdir -p ~/.ssh
chmod 0700 ~/.ssh

ssh-keyscan github.com >> ~/.ssh/known_hosts
ssh-keyscan bitbucket.org >> ~/.ssh/known_hosts

chmod 0600 ~/.ssh/known_hosts

rm -f ~/.ssh/id_rsa
printf "%s" "$CHECKOUT_KEY" > ~/.ssh/id_rsa
chmod 0600 ~/.ssh/id_rsa

if (: "${CHECKOUT_KEY_PUBLIC?}") 2>/dev/null; then
  rm -f ~/.ssh/id_rsa.pub
  printf "%s" "$CHECKOUT_KEY_PUBLIC" > ~/.ssh/id_rsa.pub
fi

export GIT_SSH_COMMAND='ssh -i ~/.ssh/id_rsa -o UserKnownHostsFile=~/.ssh/known_hosts'

git config --global user.name "Appier iOS Bot"
git config --global user.email ios-dev@appier.com

# use git+ssh instead of https
git config --global url."ssh://git@bitbucket.org".insteadOf "https://bitbucket.org" || true
git config --global gc.auto 0 || true
