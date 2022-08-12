#!/bin/sh

VERSION=$1

if [ -z "$1" ]; then
    echo "Usage: $0 <version>"
    exit 1
fi

# Get latest stable version
if [ "$1" = "stable" ]; then
    GH_STABLE_RELEASE=$(gh api -H "Accept: application/vnd.github+json" /repos/Anuken/Mindustry/releases/latest | jq '.assets[1].browser_download_url')
    PREFIX="\"https://github.com/Anuken/Mindustry/releases/download/"
    SUFFIX="/server-release.jar\""
    VERSION=${GH_STABLE_RELEASE#"$PREFIX"}
    VERSION=${VERSION%"$SUFFIX"}
    VERSION_TYPE="stable"

    echo "Found latest stable version: \"$VERSION\""
fi

# Get latest beta version
if [ "$1" = "latest" ] || [ "$1" = "beta" ]; then
    GH_BETA_RELEASE=$(gh api -H "Accept: application/vnd.github+json" /repos/Anuken/Mindustry/releases | jq '.[0].assets[1].browser_download_url')
    PREFIX="\"https://github.com/Anuken/Mindustry/releases/download/"
    SUFFIX="/server-release.jar\""
    VERSION=${GH_BETA_RELEASE#"$PREFIX"}
    VERSION=${VERSION%"$SUFFIX"}
    VERSION_TYPE="latest"

    echo "Found latest beta version: \"$VERSION\""
fi

# Check if version exists
wget --no-cache --spider https://github.com/Anuken/Mindustry/releases/download/$VERSION/server-release.jar &> /dev/null
if [ $? -ne 0 ]; then
    echo "Error: version \"$VERSION\" not found"
    exit 1
fi

# Build command
START_CMD="docker buildx build"
PUSH_ARG="--push"
PLATFORM_ARG="--platform linux/arm/v7,linux/arm64/v8,linux/amd64"
DOCKER_VERSION_TAG_ARG="-t mercxry/mindustry:$VERSION"
DOCKER_VERSION_TYPE_TAG_ARG="-t mercxry/mindustry:$VERSION_TYPE"
GITHUB_VERSION_TAG_ARG="-t ghcr.io/mercxry/mindustry:$VERSION"
GITHUB_VERSION_TYPE_TAG_ARG="-t ghcr.io/mercxry/mindustry:$VERSION_TYPE"
END_CMD="--build-arg "VERSION"="$VERSION" ."

CMD="$START_CMD $PUSH_ARG $PLATFORM_ARG $DOCKER_VERSION_TAG_ARG $GITHUB_VERSION_TAG_ARG"

if [ ! -z "$VERSION_TYPE" ]; then
    CMD="$CMD $DOCKER_VERSION_TYPE_TAG_ARG $GITHUB_VERSION_TYPE_TAG_ARG"
fi

CMD="$CMD $END_CMD"

# Run command
echo "Running command:"
echo "$CMD"

eval $CMD
