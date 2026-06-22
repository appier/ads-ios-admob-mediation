#!/bin/sh
set -e

repository="$1"
branch="$2"
path="$3"

echo "Cloning git repository"
mkdir -p $path
cd $path

git clone $repository --branch $branch --single-branch .
git --no-pager log --no-color -n 1 --format='HEAD is now at %h %s'
