
# OpStack Profile loading
if [ -n "$ZSH_VERSION" ]; then
  export OPSTACK_DIR=${0:a:h}
  eval "$(chef shell-init zsh)"
elif [ -n "$BASH_VERSION" ]; then
  export OPSTACK_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
  eval "$(chef shell-init bash)"
else
  export OPSTACK_DIR=$(dirname $0)
  echo "Shell unknown, chef-dk env not loaded"
fi

# Shared Bash functions
source $OPSTACK_DIR/.functions

# Default opstack env
if [ -f $OPSTACK_DIR/environments/default/accounts.json ]; then
  export OPSTACK_ENV='default'
  eval "$(chef exec ${OPSTACK_DIR}/bin/load_accounts.rb)"
fi
