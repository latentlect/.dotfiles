#!/usr/bin/env sh

create_mpv_videoclip_dir(){
	if [ -d "$HOME/.config/mpv" ]; then
    	# directory for mpv video recorded clips
    	mkdir -p ~/Videos/mpv_videoclips
		# replace user with username
		sed -i "s/\<user\>/$(whoami)/" "$HOME/.config/mpv/script-opts/videoclip.conf"
    	sed -i "s/\<user\>/$(whoami)/" "$HOME/.config/mpv/mpv.conf"

		sed -i "s/\<uname\>/$(whoami)/" "$HOME/.config/mpv/script-opts/youtube-download.conf"
	fi
}


create_mpv_videoclip_dir


