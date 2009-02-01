## gitupdater
`git_updater.sh` is a script to automate the process of updating git. It will try to find out from git.or.cz what the latest version is and download git and the manpages. The tarballs are checked using [GPG][] and the script will stop if the verification fails.

### Requirements
* The usual tools for building git (gcc, make, zlib, etc.)
* [Gnu Privacy Guard (GPG)][GPG]
* curl

### Usage

Depending on where you are installing git, you will need to run the script as root.
The following command will download and install the latest version of git:

	% sudo ./git_updater.sh

You can also install a specific version by using an argument:

	% sudo ./git_updater.sh 1.6.0.6

### Notes
* The script is set to use the z-shell located at `/bin/zsh`, but will also work in `bash`.
* The script is intended for use on OS X Leopard, but have been used successfully in Ubuntu.


[GPG]: http://gnupg.org/
