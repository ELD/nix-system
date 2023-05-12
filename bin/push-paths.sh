#!/usr/bin/env bash
set -euo pipefail

cachix=${1:-cachix} cachixArgs=${2:--j8} cache=${3:-eld} pathsToPush=${4:-} pushFilter=${5:-}

if [[ $pathsToPush == "" ]]; then
    pathsToPush=$(comm -13 <(sort /tmp/store-path-pre-build) <("$(dirname "$0")"/list-nix-store.sh))

    if [[ $pushFilter != "" ]]; then
        pathsToPush=$(echo "$pathsToPush" | grep -vEe "$pushFilter")
    fi
fi

echo "$pathsToPush" | "$cachix" push $cachixArgs "$cache"