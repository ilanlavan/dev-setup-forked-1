#!/usr/bin/env bash

# Install command-line tools using Homebrew.

# Ask for the administrator password upfront.
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Check for Homebrew,
# Install if we don't have it
if test ! $(which brew); then
  echo "*********************************************************"
  echo "Installing homebrew..."
  echo "*********************************************************"
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
echo "*********************************************************"
echo "Installing zsh..."
echo "*********************************************************"
brew install zsh
echo " parse_git_branch() { git branch 2> /dev/null | sed -n -e 's/^\* \(.*\)/[\1]/p' } COLOR_DEF=\$'\e[0m' COLOR_USR=\$'\e[38;5;243m' COLOR_DIR=\$'\e[38;5;197m' COLOR_GIT=\$'\e[38;5;39m' NEWLINE=\$'\n' setopt PROMPT_SUBST export PROMPT='\${COLOR_USR}%n@%M \${COLOR_DIR}%d \${COLOR_GIT}\$(parse_git_branch)\${COLOR_DEF}\${NEWLINE}%% '" >> ~/.zshrc
source ~/.zshrc

#install java
echo "*********************************************************"
echo "Installing java..."
echo "*********************************************************"
echo export "JAVA_HOME=\$(/usr/libexec/java_home)" >> ~/.bash_profile
#fix java version to be 11
brew --cask install java11

# install tomcat
echo "*********************************************************"
echo "Installing tomcat..."
echo "*********************************************************"
brew install tomcat@9

#set timezone
echo "*********************************************************"
echo "Setting timezone"
echo "*********************************************************"

timezonemessage=$(sudo systemsetup -gettimezone)
echo $timezonemessage
prefix="Time Zone: "
timezone=${timezonemessage#"$prefix"}
echo sudo ln -sf /usr/share/zoneinfo/$timezone/etc/localtime
sudo ln -sf /usr/share/zoneinfo/$timezone/etc/localtime
mkdir ~/etc
echo $timezone > ~/etc/timezone


## install docker -
#todo : validate that m1 docker https://www.docker.com/products/docker-desktop/ is installed
echo "*********************************************************"
echo "Installing docker..."
echo "*********************************************************"
brew install --cask docker

##Compose is now a Docker plugin. For Docker to find this plugin, symlink it:
  mkdir -p ~/.docker/cli-plugins
  ln -sfn /opt/homebrew/opt/docker-compose/bin/docker compose ~/.docker/cli-plugins/docker-compose

echo "*********************************************************"
echo "disable compose v2 on docker"
echo "*********************************************************"
echo "{\"composeV2\": \"disabled\"}" >> ~/.docker/features.json

echo "*********************************************************"
echo "set a local container for the docker file sharing"
echo "*********************************************************"
sed -i.bak 's#"dev/search/kenshoo/java/docker/tomcat",#"dev/search/kenshoo/java/docker/tomcat","/kenshoo/java/docker/tomcat/KS-Logs",#g' ~/Library/Group\ Containers/group.com.docker/settings.json

open /Applications/Docker.app

#todo : authenticate via vault - needs verification


#Configure vault
echo "*********************************************************"
echo "Installing hashicorp..."
echo "*********************************************************"
brew install hashicorp/tap/vault
brew install jq

echo "*********************************************************"
echo "setting vault-token file..."
echo "*********************************************************"
PS3='Please enter your choice: '
options=("vault-prod" "vault-staging" "quit")
select opt in "${options[@]}"
do
    case $opt in
        "vault-prod")
            echo "you chose $opt"
            VAULT_URL="https://vault.internalk.com:8200/v1/auth/okta/login"
            break
            ;;
        "vault-staging")
            echo "you chose $opt"
            VAULT_URL="https://vault-staging.internalk-stg.com:8200/v1/auth/okta/login"
            break
            ;;
        "quit")
            exit
            ;;
        *) echo "invalid option $REPLY";;
    esac
done

USERNAME=$(whoami)
read -sp "please enter password: " PASSWORD
TOKEN=$(curl -s --request POST --data "{\"password\": \"${PASSWORD}\"}" "${VAULT_URL}"/"${USERNAME}" | jq -r .auth.client_token)
echo -e "\nYour token is: $TOKEN"
echo $TOKEN > ~/.vault-token
perl -p -i -e 's/\R//g;' ~/.vault-token


## Jfrog logindocker - need to get credentials from init.gradle
#docker login -u <USER> -p <PASSWORD> kenshoo-docker.jfrog.io

# ecr login
# Create the following file: ~/.aws/credentials if it doesn’t exist.
#aws_access_key_id=
#aws_secret_access_key=
#aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 668139184987.dkr.ecr.us-east-1.amazonaws.com

# install gradle
echo "*********************************************************"
echo "Installing gradle..."
echo "*********************************************************"
brew install gradle
#get init.gradle and place it in ~/.gradle


# install git
echo "*********************************************************"
echo "Installing git..."
echo "*********************************************************"
brew install git


#Install volta
echo "*********************************************************"
echo "Installing volta..."
echo "*********************************************************"
#brew install volta
#export PATH=$VOLTA_HOME/bin:$PATH


#add ssh key
#https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent

echo "Generating SSH key..."
echo "*************************************************************************************************************"
echo "*************************************************************************************************************"
echo "** press enter for all questions...                                                                        **"
echo "**                                                                                                         **"

#check how to remove the key name from the next line
#todo : pbcopy to copy to clipboard the content of the id_rsa
ssh-keygen -t rsa -b 2048
echo "*************************************************************************************************************"
echo "**Goto your github account and paste the following code under Settings-> SSH and GPG keys -> New SSH key...**"
echo "**                                   https://github.com/settings/keys                                      **"
echo "**           Once you are done authorize the key via the Authorize button under the new generated key      **"
echo "*************************************************************************************************************"
echo "*************************************************************************************************************"
cat ~/.ssh/id_rsa.pub

read -p "Press enter to continue"

#todo ask the user to print yes so he can use the key and add github to the list of authorized urls

#Clone search
echo "*********************************************************"
echo "Clone search..."
echo "*********************************************************"
mkdir ~/dev
cd ~/dev
git clone git@github.com:kenshoo/search.git

echo "*********************************************************"
echo "Prepare KS env"
echo "*********************************************************"
#download keystore and rename
#download server.xml, apply changes and locate here /opt/homebrew/Cellar

cd ~dev/search/kenshoo/java
./gradlew clean cleanIdea idea

#Edit “performanceAggregation.properties” file:
#file location - kenshoo/java/flat-view/flat-view-business-impl/src/main/resources/performanceAggregation.properties
#change needed -
#paggr.host=localhost
#paggr.port=9090


echo "*********************************************************"
echo "Create local DB"
echo "*********************************************************"
#cd ~dev/search/kenshoo/java/db
#./gradlew createNewDb genconf genDBProps genTestDBProps update liquidpackage -PdbPass=root56 -PdbUser=root -PdbName=kazaam -PdbHost=localhost -Pforce=true

# Remove outdated versions from the cellar.
brew cleanup
