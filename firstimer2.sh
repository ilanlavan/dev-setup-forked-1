#!/usr/bin/env bash

# Install command-line tools using Homebrew.

# Ask for the administrator password upfront.
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Check for Homebrew,
## Install if we don't have it
#if test ! $(which brew); then
#  echo "Installing homebrew..."
#  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
#fi

##adding Homebrew to your PATH:
#echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/$USER/.zprofile
#eval "$(/opt/homebrew/bin/brew shellenv)"

## Make sure we’re using the latest Homebrew.
#brew update

## Upgrade any already-installed formulae.
#brew upgrade --formula

## install zsh
echo "Installing zsh..."
brew install zsh
echo 'eval "parse_git_branch() { git branch 2> /dev/null | sed -n -e 's/^\* \(.*\)/[\1]/p' } COLOR_DEF=$'\e[0m' COLOR_USR=$'\e[38;5;243m' COLOR_DIR=$'\e[38;5;197m' COLOR_GIT=$'\e[38;5;39m' NEWLINE=$'\n' setopt PROMPT_SUBST export PROMPT='${COLOR_USR}%n@%M ${COLOR_DIR}%d ${COLOR_GIT}$(parse_git_branch)${COLOR_DEF}${NEWLINE}%% '"' >> /Users/$USER/.zshrc
source ~/.zshrc

#install java
echo "Installing java..."
echo export "JAVA_HOME=\$(/usr/libexec/java_home)" >> ~/.bash_profile
brew install java

# install tomcat
echo "Installing tomcat..."
brew install tomcat@9

# install docker
echo "Installing docker..."
brew install --cask docker

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
brew install hashicorp/tap/vault
cd ~
vault login -address="https://vault-staging.internalk-stg.com:8200" -method=okta username=<your username>

#Install volta
echo "Installing volta..."
brew install volta
export PATH=$VOLTA_HOME/bin:$PATH

#Clone search
echo "Clone search..."
mkdir ~/dev
cd ~/dev
git clone git@github.com:kenshoo/search.git





# Install GNU core utilities (those that come with OS X are outdated).
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
brew install coreutils
sudo ln -s /usr/local/bin/gsha256sum /usr/local/bin/sha256sum

# Install some other useful utilities like `sponge`.
brew install moreutils
# Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
brew install findutils
# Install GNU `sed`, overwriting the built-in `sed`.
brew install gnu-sed
# Install Bash 4.
brew install bash
brew install bash-completion2
# We installed the new shell, now we have to activate it
echo "Adding the newly installed shell to the list of allowed shells"
# Prompts for password
sudo bash -c 'echo /usr/local/bin/bash >> /etc/shells'
# Change to the new shell, prompts for password
chsh -s /usr/local/bin/bash

# Install `wget`.
brew install wget

# Install RingoJS and Narwhal.
# Note that the order in which these are installed is important;
# see http://git.io/brew-narwhal-ringo.
brew install ringojs
brew install narwhal

# Install Python
brew install python
brew install python3

# Install ruby-build and rbenv
brew install ruby-build
brew install rbenv
LINE='eval "$(rbenv init -)"'
grep -q "$LINE" ~/.extra || echo "$LINE" >> ~/.extra

# Install more recent versions of some OS X tools.
brew install vim
brew link vim
brew install php@5.6

# Install font tools.
brew tap bramstein/webfonttools
brew install sfnt2woff
brew install sfnt2woff-zopfli
brew install woff2

# Install some CTF tools; see https://github.com/ctfs/write-ups.
brew install aircrack-ng
brew install bfg
brew install binutils
brew install binwalk
brew install cifer
brew install dex2jar
brew install dns2tcp
brew install fcrackzip
brew install foremost
brew install hashpump
brew install hydra
brew install john
brew install knock
brew install netpbm
brew install nmap
brew install pngcheck
brew install socat
brew install sqlmap
brew install tcpflow
brew install tcpreplay
brew install tcptrace
brew install ucspi-tcp # `tcpserver` etc.
brew install homebrew/x11/xpdf
brew install xz

# Install other useful binaries.
brew install ack
brew install dark-mode
#brew install exiv2
brew install git
brew install git-lfs
brew install git-flow
brew install git-extras
brew install hub
#brew install imagemagick --with-webp
brew install lua
brew install lynx
brew install p7zip
brew install pigz
brew install pv
brew install rename
brew install rhino
brew install speedtest_cli
brew install ssh-copy-id
brew install tree
brew install webkit2png
brew install zopfli
brew install pkg-config libffi
brew install pandoc

# Lxml and Libxslt
brew install libxml2
brew install libxslt
brew link libxml2 --force
brew link libxslt --force

# Install Heroku
brew install heroku/brew/heroku
heroku update

# Core casks
brew install --appdir="/Applications" alfred --cask
brew install --appdir="~/Applications" iterm2 --cask
brew cask install --appdir="~/Applications" java
brew install --appdir="~/Applications" xquartz --cask

# Development tool casks
brew install --appdir="/Applications" sublime-text --cask
brew install --appdir="/Applications" atom --cask
brew install --appdir="/Applications" virtualbox --cask
brew install --appdir="/Applications" vagrant --cask
brew install --appdir="/Applications" macdown --cask

# Misc casks
brew install --appdir="/Applications" google-chrome --cask
brew install --appdir="/Applications" firefox --cask
brew install --appdir="/Applications" skype --cask
brew install --appdir="/Applications" slack --cask
brew install --appdir="/Applications" dropbox --cask
brew install --appdir="/Applications" evernote --cask
brew install --appdir="/Applications" 1password --cask
#brew cask install --appdir="/Applications" gimp
#brew cask install --appdir="/Applications" inkscape

#Remove comment to install LaTeX distribution MacTeX
#brew cask install --appdir="/Applications" mactex

# Install Docker, which requires virtualbox
brew install docker
brew install boot2docker

# Install developer friendly quick look plugins; see https://github.com/sindresorhus/quick-look-plugins
brew install qlcolorcode qlstephen qlmarkdown quicklook-json qlprettypatch quicklook-csv betterzip qlimagesize webpquicklook suspicious-package quicklookase  --cask


# Remove outdated versions from the cellar.
brew cleanup
