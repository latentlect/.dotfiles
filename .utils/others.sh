#!/usr/bin/env sh

# pipenv, yt-dlp
python3 -m pip install --upgrade pip
python3 -m pip install -U pipenv yt-dlp

mkdir -p "$HOME/.local/bin/"

# Create batcat link as bat
if command -v batcat > /dev/null; then
	ln -s $(command -v batcat) ~/.local/bin/bat
fi

# Create fd-find link as fd
if command -v fdfind > /dev/null; then
	ln -s $(command -v fdfind) ~/.local/bin/fd
fi

# lf
if ! command -v lf > /dev/null; then
	curl -L https://github.com/gokcehan/lf/releases/latest/download/lf-linux-amd64.tar.gz | tar xzC ~/.local/bin
fi


append_line(){
    LINE="$1"
    FILE="$2"
    `grep -qxF -- "$LINE" "$FILE" || echo -en "$LINE" >> "$FILE"`
}


# automatic CPU speed & power optimizer for linux
install_auto_cpufreq(){
	if [ ! -d "$HOME/auto-cpufreq" ]; then
		git clone https://github.com/AdnanHodzic/auto-cpufreq.git
		cd auto-cpufreq && sudo ./auto-cpufreq-installer
		sudo auto-cpufreq --install
	fi
}

# slimbook battery optimizer
install_slimbook_battery_optimizer(){
    sudo add-apt-repository ppa:slimbook/slimbook -y
    sudo apt-get update -y
    sudo apt-get install slimbookbattery -y
}

# onlyoffice
install_onlyoffice(){
    # Remove libreoffice using bash terminal: sudo apt-get purge libre* -y
    mkdir -p -m 700 ~/.gnupg
    gpg --no-default-keyring --keyring gnupg-ring:/tmp/onlyoffice.gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys CB2DE8E5
    chmod 644 /tmp/onlyoffice.gpg
    sudo chown root:root /tmp/onlyoffice.gpg
    sudo mv /tmp/onlyoffice.gpg /usr/share/keyrings/onlyoffice.gpg

    echo 'deb [signed-by=/usr/share/keyrings/onlyoffice.gpg] https://download.onlyoffice.com/repo/debian squeeze main' | sudo tee -a /etc/apt/sources.list.d/onlyoffice.list

    sudo apt-get update -y

    sudo apt-get install onlyoffice-desktopeditors -y

    # Remove onlyoffice
    # sudo apt-get purge onlyoffice-desktopeditors -y
}

download_nerdfonts(){
	mkdir -p "$HOME/.local/share/fonts/nerdfonts"
	sudo aria2c --continue=true --max-concurrent-downloads=1 --auto-save-interval=5 --auto-file-renaming=false --dir=${HOME}/.local/share/fonts/nerdfonts -i "$HOME/.utils/nerdfonts"

	# generate fonts cache
	fc-cache -f -v

	# verify if font was cached successfully
	# fc-list | grep "font-name"
}


# enable usb support in virutalbox
# command -v virtualbox > /dev/null && sudo adduser $USER vboxusers


install_vscode(){
	if ! command -v code > /dev/null; then
		sudo apt-get install wget gpg
		wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
		sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
		sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
		rm -f packages.microsoft.gpg

		sudo apt install -y apt-transport-https
		sudo apt update -y
		sudo apt install -y code

		# uninstall vscode
		# sudo apt-get purge code
		# remove all user settings
		# rm -rf ~/.config/Code
		# rm -rf ~/.vscode
	fi
}


install_neovim(){
	if ! command -v nvim > /dev/null; then
        aria2c https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.deb
        sudo apt install ./nvim-linux64.deb
        rm nvim-linux64.deb
	fi
}


install_lvim(){
    if command -v nvim > /dev/null; then
        #  Pre-requisites
        sudo install -y ripgrep rust
        sudo npm install -g tree-sitter-cli prettier
        python3 -m pip install -U pynvim autopep8 flake8
        cargo install stylua

        bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh) --no-install-dependencies

		if command -v lvim > /dev/null; then
			append_line '\nalias nvim="lvim"\n' "$HOME/.aliases"
		fi

        # uninstall lvim
        # bash ~/.local/share/lunarvim/lvim/utils/installer/uninstall.sh

    fi
}


install_fzf(){
    if ! command -v fzf > /dev/null; then
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
        ~/.fzf/install --all
    fi
}


setup_tmux(){
    if command -v tmux > /dev/null; then
        sudo apt-get install entr -y
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
        if [ -f "$HOME/.tmux.conf" ]; then
            # type this in terminal if tmux is already running
            tmux source ~/.tmux.conf
        fi
        # if [ -d "$HOME/.tmux/plugins/tmp/tpm" ]; then
        #     tmux run '~/.tmux/plugins/tpm/tpm'
        # fi
        # tmux prefix: ctrl + b
        # Press prefix + I (capital i, as in Install) to fetch the plugin.
        # Press prefix + alt + u (lowercase u as in uninstall) to remove the plugin.
    fi
}


# install these packages when
# MPEG-4 and H.264 (High Profile) decoders are required
# gstreamer1.0-libav
# gstreamer1.0-plugins-ugly
# gstreamer1.0-plugins-bad
# ubuntu-restricted-extras

install_fzf
download_nerdfonts
install_vscode
# setup_tmux
# install_neovim
# install_lvim
# install_auto_cpufreq
# auto_cpufreq replaced with Slimbook battery
# echo "Download Slimbook Battery .deb file here: https://github.com/slimbook/slimbookbattery/releases"
# echo "Run command: sudo apt install ./slimbookbattery_4.0.0_all.deb"
install_slimbook_battery_optimizer
