AUTHOR_NAME="Tarran Jones"
AUTHOR_EMAIL="tarrandavidjones@gmail.com"
AUTHOR_URL="http://tarranjones.com"

AUTHOR_EMAIL="tarrandavidjones@gmail.com"



mkdir -p $HOME/.ssh
chmod 0700 $HOME/.ssh
eval "$(ssh-agent -s)"

# https://github.com/curtisalexander/til/blob/master/cl/ssh-config.md

ssh_keygen(){
  mkdir -p ~/.ssh
  filename=~/.ssh/"${1:+$1_}${2:+($2)_}id_rsa"
  ssh-keygen -t rsa -b 4096 -N "" -C "$USER@$HOSTNAME ${1:-Default Identity}${2:+ ($2)}" -f $filename
  if [ $# -gt 1 ]; then
    host="${1#*@}"
    user="${1%@*}"
    ssh_config_host "$user.$host-$2" "$host" "$user" $filename
  fi
  eval "$(ssh-agent -s)"
  ssh-add $filename
}

ssh_setup_key(){
  ssh_keygen $@
  ssh_copy_id $@
  pub_key $@
}

# <User@HostName><username>
# git@github.com tarranjones
# git@github.com otheraccount
# git@bitbucket.org tarranjones
# git@bitbucket.org otheraccount
ssh_copy_id(){
  if ! [ command -v "ssh-copy-id" >/dev/null 2>&1 ] ; then
    ssh-copy-id -i ~/.ssh/"${1:+$1_}${2:+($2)_}id_rsa.pub" $1
  else
    cat ~/.ssh/"${1:+$1_}${2:+($2)_}id_rsa.pub" | ssh $1 'umask 0077; mkdir -p ~/.ssh; cat >> ~/.ssh/authorized_keys && echo "Key copied"'
  fi
}


# <User@HostName> <username>
# git@github.com tarranjones
# git@github.com otheraccount
# git@bitbucket.org tarranjones
# git@bitbucket.org otheraccount
pub_key(){
  pbcopy < ~/.ssh/"${1:+$1_}${2:+($2)_}id_rsa.pub"
}

# <Host> <HostName> <User> <IdentityFile>
# git@github.com-tarranjones github.com git ~/.ssh/git@github.com_(tarranjones)id_rsa"
ssh_config_host(){
  mkdir -p ~/.ssh

  # // this will create duplicate entiries - needs improving

  # further reading - https://gist.github.com/jexchan/2351996/de8ad280bef07c668fe55486e2bca546079efdc8
  # ssh_config docs - https://linux.die.net/man/5/ssh_config
  echo -e "Host $1\n\tHostName $2\n\tPreferredAuthentications publickey\n\t${3:+User $3\n\t}${4:+IdentityFile $4\n\t}" >> ~/.ssh/config
}

# ssh_setup_key git@bitbucket.org tarranjones
# ssh_setup_key git@github.com tarranjones
