symlink_files() {
  IGNORE=(Readme.md scripts config)
  DIR="$HOME/.dotfiles/"

  ignored() {
    for e in "${@:2}"; do [[ "$e" == "$1" ]] && return 0; done
    return 1
  }

  printf "\033[0;34mCreating Symlinks:\033[0m\n"

  for file in $(ls ${DIR}); do
    ignored $file "${IGNORE[@]}"

    if [ $? -eq 0 ]; then
      continue
    fi
    printf "$DIR$file => ~/.$file\n"
    rm -r $HOME/.$file &> /dev/null
    ln -s $DIR$file ~/.$file
  done

  # Creating default folders
  printf "\033[0;34mCreating Default Folders\033[0m\n~/projects\n~/vcode\n~/test_cases\n~/go\n"
  mkdir $HOME/{projects,vcode,test_cases,go} &> /dev/null
}

printf "\033[0;32m                                            \033[0m\n"
printf "\033[0;32m   **************************************** \033[0m\n"
printf "\033[0;32m   *      BLeve: Machine Provisioner     * \033[0m\n"
printf "\033[0;32m   **************************************** \033[0m\n"
printf "\033[0;32m                                            \033[0m\n"

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.osx` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

printf "\033[0;34mCloning .Dotfiles...\033[0m\n"

hash git >/dev/null || {
  echo "git not installed. Please install XCode first"
  exit
}

/usr/bin/env git clone https://github.com/bLevein/.dotfiles.git ~/.dotfiles || {
  echo "$HOME/.dotfiles has already exists updating now"
  git pull origin master
}

# enter scripts dir
pushd $HOME/.dotfiles/scripts

# Set up symlinks
symlink_files

printf "\033[0;34mRunning Base Setup\033[0m\n"

#################
# INSTALLATIONS #
#################

# Install homebrew
if [ -d /usr/local/.git ]
then
  echo "Homebrew is already installed"
else
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi
  # Brew Taps
  brew tap neovim/neovim
  brew tap caskroom/versions
  brew tap caskroom/fonts

# update brews and casks
printf "\033[0;34mFetching latest homebrew formulas...\033[0m\n"
brew update

#install kegs
brew install \
  git \
  zsh \
  node \
  tmux \
  python \
  go \
  cmake \
  watchman \
  fswatch \
  docker \
  ctags\
  python3 \
  xhyve \
  docker-machine-driver-xhyve \
  the_silver_searcher \
  reattach-to-user-namespace

# override system vim
brew install vim --env-std --override-system-vim

## Install casks
brew cask install \
  vagrant \
  virtualbox \
  docker-machine \
  docker-compose \
  iterm2 \
  google-chrome \
  google-chrome-canary \
  font-source-code-pro \
  font-source-code-pro-for-powerline

## Install NeoVim
brew install --HEAD --with-release neovim
pip3 install neovim

brew cask cleanup

# Install oh-my-zsh
curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh

printf "\033[0;34mInstalling cocoapods\033[0m\n"
# Cocoapods
sudo gem install cocoapods --no-rdoc --no-ri

printf "\033[0;34mInstalling Go tools\033[0m\n"
# Go Tools
go get github.com/mitchellh/gox
go get golang.org/x/tools/...
go get github.com/mholt/caddy
go get github.com/google/git-appraise/git-appraise

printf "\033[0;34mInstalling Node Modules\033[0m\n"
# Install modules
npm -g install eslint babel babel-eslint eslint-plugin-react eslint-plugin-babel webpack yarn n git+https://github.com/ramitos/jsctags.git &> /dev/null

printf "\033[0;34mInstalling Vim Plugins\033[0m\n"
# Install vim bundles for vim
curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Install Google Cloud SDK
if ! [[ -d $HOME/google-cloud-sdk ]]
then
  curl https://sdk.cloud.google.com | zsh
fi

#################
# CONFIGURATION #
#################

# Own Node and NPM
sudo mkdir -p /usr/local/{share/man,bin,lib/node,lib/dtrace,include/node,lib/node_modules}
sudo chown -R $USER /usr/local/{share/man,bin,lib/node,lib/dtrace,include/node,lib/node_modules}

printf "\033[0;34mSetting OS X Defaults\033[0m"
# Enable full keyboard access for all controls (e.g. enable Tab in modal dialogs)
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3
# Enable subpixel font rendering on non-Apple LCDs
defaults write NSGlobalDomain AppleFontSmoothing -int 2
# Show remaining battery time; hide percentage
defaults write com.apple.menuextra.battery ShowPercent -string "NO"
defaults write com.apple.menuextra.battery ShowTime -string "YES"
# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
# Disable the “Are you sure you want to open this application?” dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false
# Increase window resize speed for Cocoa applications
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001
# Avoid creating .DS_Store files on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
# Only use UTF-8 in Terminal.app
defaults write com.apple.terminal StringEncodings -array 4
# Disable the “reopen windows when logging back in” option
# This works, although the checkbox will still appear to be checked,
# and the command needs to be entered again for every restart.
defaults write com.apple.loginwindow TALLogoutSavesState -bool false
defaults write com.apple.loginwindow LoginwindowLaunchesRelaunchApps -bool false

# Faster key repeat
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 40

printf "\033[0;34mFinishing Up...\033[0m"

source ./link.sh

cp $HOME/.dotfiles/config/com.googlecode.iterm2.plist $HOME/Library/Preferences/

# return to starting dir
popd
vim +PlugInstall +GoInstallBinaries +qall &> /dev/null

# Setup docker machine xhyve driver
sudo chown root:wheel $(brew --prefix)/opt/docker-machine-driver-xhyve/bin/docker-machine-driver-xhyve
sudo chmod u+s $(brew --prefix)/opt/docker-machine-driver-xhyve/bin/docker-machine-driver-xhyve

# Create git creds file
if [ -f $HOME/.gitconfig_local ]
then
  printf "\033[0;32mFound ~/.gitconfig_local.\033[0m\n";
else
  printf "\033[0;33mNo ~/.gitconfig_local found. Generating one now...\033[0m\n";
  printf "Full Name: "
  read FULL_NAME 
  printf "Email:"
  read EMAIL
  printf "[user]\n  name=$FULL_NAME\n  email=$EMAIL\n" > ~/.gitconfig_local
fi

