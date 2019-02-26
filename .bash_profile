export PATH=$PATH:~/.local/bin
export VIRTUALENVWRAPPER_PYTHON=`which python3`
# export VAULT_PASS=$(cat ~/.vivadecora/password-vault) >> ~/.bashrc # ou .zshrc

# export WORKON_HOME=~/Envs
# source $(which virtualenvwrapper.sh)

# if [ ! -d "$WORKON_HOME/vd36" ]; then
#    mkvirtualenv vd36 --python=$(which python3)
# fi

if [ -f "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh" ]; then
  __GIT_PROMPT_DIR=$(brew --prefix)/opt/bash-git-prompt/share
  GIT_PROMPT_ONLY_IN_REPO=1
  source "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh"
fi

alias qcurrbranch='git rev-parse --abbrev-ref HEAD'
f_qsetup() {
    git branch master --quiet --set-upstream-to origin/master
    git config branch.autosetuprebase always
    git config branch.master.rebase true
    git config branch.$(qcurrbranch).rebase true
}
alias qsetup=f_qsetup
f_qpull(){
        qsetup
        git pull --rebase origin $(qcurrbranch)
        git submodule init
        git submodule update
}
alias qpull=f_qpull
alias qpush='qsetup && git push origin $(qcurrbranch)'
f_qmerge() {
    if [ $1 ]
    then
        thatbranch=$1
        thisbranch=$(qcurrbranch)
        git merge --no-ff -m "Fazendo merge da $thatbranch em $thisbranch [$2]" $thatbranch
    else
        echo 'Faz merge de outra branch na branch atual'
        echo '-----------------------------------------'
        echo 'Usage: qmerge <other_branch> [commit_msg]'
    fi
}
alias qmerge=f_qmerge
f_qfeaturebranch() {
    if [ $1 ]
    then
        newbranch=$1
        git checkout -b $newbranch
        qsetup
    else
        echo 'Cria uma feature branch a partir da branch atual'
        echo '-----------------------------------------'
        echo 'Usage: qfeaturebranch <new_branch>'
    fi
}
alias qfeaturebranch=f_qfeaturebranch

f_vd() {
   cd ~/dev/plataforma
   . dev.sh
   workon vd36
   nvm use v8.11.3
   ci/decrypt-env-vault.sh
   export_vars local
}
alias vd=f_vd

export NVM_DIR="${XDG_CONFIG_HOME/:-$HOME/.}nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

export PS1="\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\]\$ "
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad
alias ls='ls -GFh'

# export WORKON_HOME=~/Envs
# source $(which virtualenvwrapper.sh)

