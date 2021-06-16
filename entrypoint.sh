#!/bin/sh -l

set -e

: ${ONE_DOMAIN_NAME?Required environment name variable not set.}
: ${ONE_SSH_KEY_PRIVATE?Required secret not set.}
: ${ONE_SSH_KEY_PUBLIC?Required secret not set.}

#SSH Key Vars
SSH_PATH="$HOME/.ssh"
KNOWN_HOSTS_PATH="$SSH_PATH/known_hosts"
ONE_SSH_KEY_PRIVATE_PATH="$SSH_PATH/github_action"
ONE_SSH_KEY_PUBLIC_PATH="$SSH_PATH/github_action.pub"

#Deploy Vars
ONE_SSH_HOST="ssh.$ONE_DOMAIN_NAME"
if [ -n "$TPO_PATH" ]; then
    DIR_PATH="$TPO_PATH"
else
    DIR_PATH=""
fi

if [ -n "$TPO_SRC_PATH" ]; then
    SRC_PATH="$TPO_SRC_PATH"
else
    SRC_PATH="."
fi

ONE_SSH_USER="$ONE_DOMAIN_NAME"@ssh."$ONE_DOMAIN_NAME"

ONE_DESTINATION="$ONE_SSH_USER":/../../www/"$DIR_PATH"

echo "SRC: $SRC_PATH"
echo "DEST: $ONE_DESTINATION"

# Setup our SSH Connection & use keys
mkdir "$SSH_PATH"
ssh-keyscan -t rsa "$ONE_SSH_HOST" >> "$KNOWN_HOSTS_PATH"

#Copy Secret Keys to container
echo "$ONE_SSH_KEY_PRIVATE" > "$ONE_SSH_KEY_PRIVATE_PATH"
echo "$ONE_SSH_KEY_PUBLIC" > "$ONE_SSH_KEY_PUBLIC_PATH"

#Set Key Perms
chmod 700 "$SSH_PATH"
chmod 644 "$KNOWN_HOSTS_PATH"
chmod 600 "$ONE_SSH_KEY_PRIVATE_PATH"
chmod 644 "$ONE_SSH_KEY_PUBLIC_PATH"

# Deploy via SSH
rsync -e "ssh -v -p 22 -i ${ONE_SSH_KEY_PRIVATE_PATH} -o StrictHostKeyChecking=no" -a --out-format="%n" --exclude=".*" $SRC_PATH $ONE_DESTINATION


# Clear cache
ssh -v -p 22 -i ${ONE_SSH_KEY_PRIVATE_PATH} -o StrictHostKeyChecking=no $ONE_SSH_USER "cache-purge"
echo "SUCCESS: Site has been deployed and cache has been flushed."
