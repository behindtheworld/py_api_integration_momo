#!/bin/bash

export SEMVER_LAST_TAG=$(git describe --abbrev=0 --tags 2>/dev/null)
export SEMVER_RELEASE_LEVEL=$(git log --oneline -1 --pretty=%B | cat | tr -d '\n' | cut -d "[" -f2 | cut -d "]" -f1)

if [ -z $SEMVER_LAST_TAG ]; then
    >&2 echo "No tags defined"
    SEMVER_LAST_TAG="0.0.1"
fi

if [ -n $SEMVER_RELEASE_LEVEL ]; then
    git clone https://github.com/fsaintjacques/semver-tool /tmp/semver &> /dev/null
    SEMVER_NEW_TAG=$(/tmp/semver/src/semver bump $SEMVER_RELEASE_LEVEL $SEMVER_LAST_TAG)
    git tag $SEMVER_NEW_TAG &> /dev/null
    git push https://${GH_TOKEN}@github.com/sparkplug/momoapi-python.git --tags &> /dev/null
    echo $SEMVER_NEW_TAG
else
    >&2 echo "No release level defined"
fi

exit 0