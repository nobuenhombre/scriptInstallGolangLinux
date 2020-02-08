#!/bin/bash

VERSION="1.13.7"
OS="linux"
ARCH="amd64"
CHECKSUM="b3dd4bd781a0271b33168e627f7f43886b4c5d1c794a4015abf34e99c6526ca3"

GO_PROJECTS_DIR="/home/go"

URL="https://dl.google.com/go"
ARCHIVE_FILE="go$VERSION.$OS-$ARCH.tar.gz"

if [ -f "$ARCHIVE_FILE" ]; then
  echo "File $ARCHIVE_FILE already exists."
else
  echo "Downloading file $ARCHIVE_FILE ..."
  wget "$URL/$ARCHIVE_FILE"
fi

if [ -f "$ARCHIVE_FILE" ]; then
  ARCHIVE_FILE_CHECKSUM=$(sha256sum "$ARCHIVE_FILE")
  if [ "$CHECKSUM  $ARCHIVE_FILE" == "$ARCHIVE_FILE_CHECKSUM" ]; then
    echo "Checksum - OK."
    tar -C /usr/local -xvzf "$ARCHIVE_FILE"
    echo "Archive unpacked - OK."
    mkdir -p $GO_PROJECTS_DIR
    mkdir -p $GO_PROJECTS_DIR/{src,pkg,bin}
    echo "Dirs created - OK."
    echo "export PATH=\"\$PATH:/usr/local/go/bin\"" >> ~/.bash_profile
    echo "export GOPATH=\"${GO_PROJECTS_DIR}\"" >> ~/.bash_profile
    echo "export GOBIN=\"\$GOPATH/bin\"" >> ~/.bash_profile
    source ~/.bash_profile
    echo "Profile updated - OK."

    VERSION_INFO=$(go version)
    if [ "go version go${VERSION} ${OS}/${ARCH}" == "$VERSION_INFO" ]; then
      echo -e "\033[32mInstall Successful !\033[0m"
    else
      echo "${VERSION_INFO}"
      echo -e "\033[31mInstall Failed !\033[0m"
    fi
  else
    echo "Wrong Checksum !"
    echo "Real ${ARCHIVE_FILE_CHECKSUM}"
    echo "Expd ${CHECKSUM}"
    echo -e "\033[31mInstall Failed !\033[0m"
  fi
else
  echo "Error downloading file $ARCHIVE_FILE."
  echo -e "\033[31mInstall Failed !\033[0m"
fi
