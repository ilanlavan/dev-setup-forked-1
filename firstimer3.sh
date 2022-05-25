#!/usr/bin/env bash

# Install command-line tools using Homebrew.

# Ask for the administrator password upfront.
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &


## install docker
echo "Installing docker..."
#brew install --cask docker
#open /Applications/Docker.app

##Compose is now a Docker plugin. For Docker to find this plugin, symlink it:
  mkdir -p ~/.docker/cli-plugins
  ln -sfn /opt/homebrew/opt/docker-compose/bin/docker-compose ~/.docker/cli-plugins/docker-compose

echo "{\"composeV2\": \"disabled\"}" >> ~/.docker/features.json

m ~/etc/localtime
timezone=$(sudo systemsetup -gettimezone)
echo $timezone
sudo ln -sf /usr/share/zoneinfo/$timezone/etc/localtime
echo $timezone >> ~/etc/timezone

## Jfrog logindocker - need to get credentials from init.gradle
#docker login -u <USER> -p <PASSWORD> kenshoo-docker.jfrog.io

# ecr login
# Create the following file: ~/.aws/credentials if it doesn’t exist.
#aws_access_key_id=
#aws_secret_access_key=
#aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 668139184987.dkr.ecr.us-east-1.amazonaws.com

# install gradle
echo "Installing gradle..."
#brew install gradle
#get init.gradle and place it in ~/.gradle


# install git
echo "Installing git..."
#brew install git

#add ssh key
#https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent

#Configure vault
echo "Installing hashicorp..."
#brew install hashicorp/tap/vault
#cd ~
#vault login -address="https://vault-staging.internalk-stg.com:8200" -method=okta username=$USER

#Install volta
echo "Installing volta..."
#brew install volta
#export PATH=$VOLTA_HOME/bin:$PATH

echo "Generating SSH key..."
echo "*************************************************************************************************************"
echo "*************************************************************************************************************"
echo "** press enter for all questions...                                                                        **"
echo "**                                                                                                         **"
ssh-keygen -t rsa -b 2048 -C 'search@skai1111.io'
echo "**Goto your github account and paste the following code under Settings-> SSH and GPG keys -> New SSH key...**"
echo "**                                                                                                         **"
echo "*************************************************************************************************************"
echo "**                                                                                                         **"
echo "**                                                                                                         **"
cat ~/.ssh/id_rsa.pub
read -p "Press enter to continue"
echo "*************************************************************************************************************"
echo "**                                                                                                         **"
echo "**      Now go to the same place and authorize the key you just generated, (Settings-> SSH and GPG keys)   **"
echo "**                                   https://github.com/settings/keys                                      **"
echo "**                                                                                                         **"
echo "*************************************************************************************************************"
echo ""
read -p "Press enter to continue"

#Clone search
echo "Clone search..."
mkdir ~/dev
cd ~/dev
git clone git@github.com:kenshoo/search.git

#Clone search
#echo "Installing vault-cli..."
#brew install vault-cli


# Remove outdated versions from the cellar.
brew cleanup
