#!/bin/sh

mkdir -p $HOME/.gitt
cacheFile="$HOME/.gitt/cache"
current=$(git branch --show-current)

read -p "enter commit msg:" msg
git add .
git commit -am "fix: $msg"

if [[ -f "$cacheFile" ]]; then
    source $cacheFile
fi

read -p "enter target branch:($target_branch)" n_target_branch

if [ -z "$n_target_branch" ]; then
    if [ -z "$target_branch" ]; then
        n_target_branch=testing
    else
        n_target_branch=$target_branch
    fi
fi

if [ "$n_target_branch" != "$target_branch" ]; then
    echo "not equal"
    rm $cacheFile
    echo target_branch=$n_target_branch >>$cacheFile
fi

git checkout $n_target_branch
git pull --rebase
git merge $current -Xtheirs --no-edit
git push --set-upstream origin $n_target_branch

git checkout $current
