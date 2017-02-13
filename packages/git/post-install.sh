# setup git credentials

AUTHOR_NAME="Tarran Jones"
AUTHOR_EMAIL="tarrandavidjones@gmail.com"
AUTHOR_URL="http://tarranjones.com"

git config --global user.name "$AUTHOR_NAME"
git config --global user.email "$AUTHOR_EMAIL"
git config --global core.editor "$EDITOR"

# appendtofile "*.local" "$GIT_GITIGNORE_GLOBAL"
# git config --global core.excludesfile "$GIT_GITIGNORE_GLOBAL"

# git config status.showuntrackedfiles no
# git update-index --untracked-cache

# <alias> <hostname> <identity>
add_git_identity_alias(){

  echo "adding identity"

  # echo -e "Host $1\n\tHostName $2\n\tPreferredAuthentications publickey\n\tIdentityFile ~/.ssh/$3" >> ~/.ssh/config
  # ssh-keygen -f ~/.ssh/$3 -C $3
}
# add_git_identity_alias github github.com
# add_git_identity_alias bitbucket bitbucket.com
unset add_git_identity_alias


# npm install --global git-flow
# npm install --global git-fire
# brew install git-extras





# archive_repo github.com/rupa/z

# better diffs
if which diff-so-fancy > /dev/null 2>&1; then
  git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"
fi
