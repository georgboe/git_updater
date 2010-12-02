#!/bin/zsh

check_errs()
{
  # Function. Parameter 1 is the return code
  # Para. 2 is text to display on failure.
  if [ "${1}" -ne "0" ]; then
    echo "ERROR # ${1} : ${2}"
    exit ${1}
  fi
}

# Check that we're root
if [ `id -u` != 0 ]; then
	echo "This script must be run as root"
	exit 1
fi

# Check for an argument
if [ -n "$1" ]; then
	GIT_VERSION=$1
else
	# matches: http://www.kernel.org/pub/software/scm/git/docs/RelNotes/1.7.3.1.txt
    GIT_VERSION=`curl "http://git-scm.com" 2> /dev/null | sed -n 's/.*\/\(.*\).txt.*/\1/p'`
    echo "Current version expected to be $GIT_VERSION"
    echo "Is this is incorrect, press CTRL-C NOW!"
    sleep 5
fi

# Download the tarballs
curl -O http://kernel.org/pub/software/scm/git/git-$GIT_VERSION.tar.gz \
     -O http://kernel.org/pub/software/scm/git/git-$GIT_VERSION.tar.gz.sign \
     -O http://kernel.org/pub/software/scm/git/git-manpages-$GIT_VERSION.tar.bz2 \
     -O http://kernel.org/pub/software/scm/git/git-manpages-$GIT_VERSION.tar.bz2.sign

# ===============
# = Install Git =
# ===============

# Verify the git tarballs
gpg --verify git-$GIT_VERSION.tar.gz.sign git-$GIT_VERSION.tar.gz
check_errs $? "Git doesn't verify!"

# Extract and install
tar -xzvf git-$GIT_VERSION.tar.gz
cd git-$GIT_VERSION
./configure && make install
cd ..

# ============
# = Manpages =
# ============

# Verify  and install manpages
gpg --verify git-manpages-$GIT_VERSION.tar.bz2.sign git-manpages-$GIT_VERSION.tar.bz2
check_errs $? "Manpages doesn't verify!"
tar xjv -C /usr/local/share/man -f git-manpages-$GIT_VERSION.tar.bz2

# ============
# = Clean up =
# ============

rm -rf git-$GIT_VERSION.tar.gz git-$GIT_VERSION.tar.gz.sign \
	   git-manpages-$GIT_VERSION.tar.bz2 git-manpages-$GIT_VERSION.tar.bz2.sign \
       git-$GIT_VERSION


echo "================================="
echo "   GIT successfully updated!   "
echo "      \c"; git --version
echo "================================="
