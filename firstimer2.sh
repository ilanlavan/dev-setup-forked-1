#!/usr/bin/env bash

# Install command-line tools using Homebrew.

# Ask for the administrator password upfront.
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Check for Homebrew,
# Install if we don't have it
if test ! $(which brew); then
  echo "Installing homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

#adding Homebrew to your PATH:
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/$USER/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

## Make sure we’re using the latest Homebrew.
brew update

## Upgrade any already-installed formulae.
brew upgrade --formula

# install zsh
echo "Installing zsh..."
brew install zsh
echo " parse_git_branch() { git branch 2> /dev/null | sed -n -e 's/^\* \(.*\)/[\1]/p' } COLOR_DEF=\$'\e[0m' COLOR_USR=\$'\e[38;5;243m' COLOR_DIR=\$'\e[38;5;197m' COLOR_GIT=\$'\e[38;5;39m' NEWLINE=\$'\n' setopt PROMPT_SUBST export PROMPT='\${COLOR_USR}%n@%M \${COLOR_DIR}%d \${COLOR_GIT}\$(parse_git_branch)\${COLOR_DEF}\${NEWLINE}%% '" >> ~/.zshrc
source ~/.zshrc

#install java
echo "Installing java..."
echo export "JAVA_HOME=\$(/usr/libexec/java_home)" >> ~/.bash_profile
brew install java

# install tomcat
echo "Installing tomcat..."
brew install tomcat@9

## install docker
echo "Installing docker..."
brew install --cask docker


##Compose is now a Docker plugin. For Docker to find this plugin, symlink it:
  mkdir -p ~/.docker/cli-plugins
  ln -sfn /opt/homebrew/opt/docker-compose/bin/docker compose ~/.docker/cli-plugins/docker-compose

echo "{\"composeV2\": \"disabled\"}" >> ~/.docker/features.json

sed 's#"/Users",#"/Users","/kenshoo/java/docker/tomcat/KS-Logs",#g' ~/Library/Group\ Containers/group.com.docker/settings.json

#open /Applications/Docker.app


## Jfrog logindocker - need to get credentials from init.gradle
#docker login -u <USER> -p <PASSWORD> kenshoo-docker.jfrog.io

# ecr login
# Create the following file: ~/.aws/credentials if it doesn’t exist.
#aws_access_key_id=
#aws_secret_access_key=
#aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 668139184987.dkr.ecr.us-east-1.amazonaws.com

# install gradle
echo "Installing gradle..."
brew install gradle
#get init.gradle and place it in ~/.gradle


# install git
echo "Installing git..."
brew install git

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


timezonemessage=$(sudo systemsetup -gettimezone)
echo $timezonemessage
prefix="Time Zone: "
timezone=${timezonemessage#"$prefix"}
echo sudo ln -sf /usr/share/zoneinfo/$timezone/etc/localtime
sudo ln -sf /usr/share/zoneinfo/$timezone/etc/localtime
mkdir ~/etc
echo $timezone > ~/etc/timezone


echo "Generating SSH key..."
echo "*************************************************************************************************************"
echo "*************************************************************************************************************"
echo "** press enter for all questions...                                                                        **"
echo "**                                                                                                         **"
ssh-keygen -t rsa -b 2048 -C 'search@skai1111.io'
echo "*************************************************************************************************************"
echo "**Goto your github account and paste the following code under Settings-> SSH and GPG keys -> New SSH key...**"
echo "*************************************************************************************************************"
cat ~/.ssh/id_rsa.pub

echo "*************************************************************************************************************"
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
