#!/bin/sh

PACKAGE="lazydocker"
REPO="jesseduffield/lazydocker"

VERSION="$(cat tag)"

ARCH="amd64 arm64"
AMD64_FILENAME="lazydocker_"$VERSION"_Linux_x86_64.tar.gz"
ARM64_FILENAME="lazydocker_"$VERSION"_Linux_arm64.tar.gz"

get_url_by_arch() {
    case $1 in
    "amd64") echo "https://github.com/$REPO/releases/latest/download/$AMD64_FILENAME" ;;
    "arm64") echo "https://github.com/$REPO/releases/latest/download/$ARM64_FILENAME" ;;
    esac
}

build() {
    # Prepare
    BASE_DIR="$PACKAGE"_"$VERSION"-1_"$1"
    rm -rf "$BASE_DIR"
    cp -r templates "$BASE_DIR"
    sed -i "s/Architecture: arch/Architecture: $1/" "$BASE_DIR/DEBIAN/control"
    sed -i "s/Version: version/Version: $VERSION-1/" "$BASE_DIR/DEBIAN/control"
    # Download and move file
    curl -sLo "$PACKAGE-$1.tar.gz" "$(get_url_by_arch $1)"
    mkdir -p "$PACKAGE-$1"
    tar -xzf "$PACKAGE-$1.tar.gz" -C "$PACKAGE-$1"
    mv "$PACKAGE-$1/$PACKAGE" "$BASE_DIR/usr/bin/$PACKAGE"
    chmod 755 "$BASE_DIR/usr/bin/$PACKAGE"
    # Build
    dpkg-deb --build --root-owner-group "$BASE_DIR"
}

for i in $ARCH; do
    echo "Building $i package..."
    build "$i"
done

# Create repo files
apt-ftparchive packages . > Packages
apt-ftparchive release . > Release
