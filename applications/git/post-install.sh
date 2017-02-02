# setup git credentials
git config --global user.name "$USERNAME"
git config --global user.email "$EMAIL"
git config --global core.editor "$EDITOR"

appendtofile "*.local" "$GIT_GITIGNORE_GLOBAL"
git config --global core.excludesfile "$GIT_GITIGNORE_GLOBAL"

git config status.showuntrackedfiles no
git update-index --untracked-cache

# <alias> <hostname> <identity>
add_git_identity_alias(){

  echo "adding identity"

  # echo -e "Host $1\n\tHostName $2\n\tPreferredAuthentications publickey\n\tIdentityFile ~/.ssh/$3" >> ~/.ssh/config
  # ssh-keygen -f ~/.ssh/$3 -C $3
}
# add_git_identity_alias github github.com
# add_git_identity_alias bitbucket bitbucket.com
unset add_git_identity_alias



# archive_repo github.com/rupa/z
