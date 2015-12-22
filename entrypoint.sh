#!/bin/bash
usage() { echo "Usage: ghost-themer <theme>:<githubrepo> [<theme>:<githubrepo> ...]" 1>&2; exit 1; }

# Setup a theme we haven't seen before
installTheme () {
	local theme=$1
	local repo=$2
	github="https://github.com/$repo.git"
	echo " cloning theme '$theme' from $repo..."
	git clone $github $theme_location
	echo " ...'$theme' theme installed"
}

# Update an existing theme
updateTheme () {
	local theme_location=$1
	echo " updating theme '$theme'..."
	cd ${theme_location} && git pull origin master
    echo " ...'$theme' theme updated"
}

if [ $# -lt 1 ]; then
	echo "At least one theme must be specified"
	usage
fi

echo "installing/updating ghost themes..."

# Install or update each theme supplied as args
for theme_config in "$@"
do
    IFS=':' read -ra PARTS <<< "$theme_config"

	# Check we have two parts, the theme folder and github repo
	if [ ${#PARTS[@]} -ne 2 ]; then
		echo " ERROR: Cannot parse theme config: '$theme_config' (format is <themefolder>:<githubrepo>) - Skipping installing/updating this theme."
		continue
	fi

	theme="${PARTS[0]}"
	repo="${PARTS[1]}"

	echo "checking if theme $theme is installed..."

	theme_location="$THEMES_LOCATION/$theme"

	if [ -d ${theme_location} ]; then  
		# Check the theme is an existing Git repo
		cd ${theme_location}
		if [ -d ".git" ]; then
			updateTheme $theme_location	
		else
			echo " Warning: Theme '$theme' was not updated as it is not a Git repository. Did you install it manually?"
		fi
	else  
		installTheme $theme $repo	
	fi
done
