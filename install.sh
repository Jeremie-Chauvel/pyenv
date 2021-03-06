#! /bin/bash
set -euo pipefail
IFS=$'\n\t'

sudo -v
set +e
type pyenv >/dev/null 2>&1
result_status="$?"
set -e
if [[ "$result_status" -gt 0 ]] && [[ ! -d "$HOME/.pyenv" ]]; then
    echo '###################'
    echo 'downloading and installing pyenv'
    echo '###################'
    set +eu
    bash -c "$(curl -L https://raw.githubusercontent.com/yyuu/pyenv-installer/master/bin/pyenv-installer)"
    set -eu
fi

sudo -v

set +e
grep -q ~/.zshrc -e 'export PATH="/home/$USER/.pyenv/bin:$PATH"'
result_status="$?"
set -e
if [[ "$result_status" -gt 0 ]]; then
    echo '###################'
    echo 'adding pyenv to .zshrc and reloading .zshrc'
    echo '###################'

    echo '#pyenv setup

export PATH="/home/$USER/.pyenv/bin:$PATH"
if [ -z ${PROFILE_LOADED} ]; then
    export PROFILE_LOADED=true
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi' | tee --append ~/.zshrc >/dev/null
fi

set +eu
export PATH="/home/tarkett/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
set -eu

echo '###################'
echo 'installing dev for python libs'
echo '###################'
sudo apt install -y make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev xz-utils tk-dev

echo '###################'
echo 'installing python 3.6.9'
echo '###################'
set +e
pyenv versions | grep -q -e '3.6.9'
result_status="$?"
set -e
if [[ "$result_status" -gt 0 ]]; then
    pyenv install 3.6.9
fi
echo -e '###################
To create a new virtual env use:
\e[1mpyenv virtualenv 3.6.9 <env>\e[0m

Then go to your project directory and use:

\e[1mpyenv local <env>\e[0m
###################'
