#!/bin/bash

# Get Current Branch
current_branch=$(git rev-parse --abbrev-ref HEAD)

# Get the latest tag
latest_tag=$(git describe --tags --abbrev=0)

# Split the version number
IFS='.' read -ra version_parts <<< "$latest_tag"

# Increment the version numbers based on the current branch
if [ "$current_branch" = "${version_parts[0]}" ]; then
    # Increment minor version if a new branch is created
    major=${version_parts[0]}
    minor=${version_parts[1]}
    patch=${version_parts[2]}
    patch=$((patch + 1))
    tag_suffix=""
elif [ "$current_branch" = "master" ] || [ "$current_branch" = "main" ]; then
    # Increment major version if commit is on master or main branch
    major=$(( ${version_parts[0]} + 1 ))
    minor=0
    patch=0
    tag_suffix=""
else
    # Check if the current branch is merged into the main or master branch
    merge_base=$(git merge-base "main" "$current_branch" || git merge-base "master" "$current_branch")
    if [ "$(git rev-parse HEAD)" = "$merge_base" ]; then
        # Increment minor version if the branch is merged into main or master
        major=${version_parts[0]}
        minor=$(( ${version_parts[1]} + 1 ))
        patch=0
        tag_suffix=""
    else
        # Increment patch version if commit is on a new branch
        major=${version_parts[0]}
        minor=${version_parts[1]}
        patch=${version_parts[2]}
        patch=$((patch + 1))
        tag_suffix="-alpha"
    fi
fi

    # Create the new tag
    new_tag="$major.$minor.$patch$tag_suffix"
    echo "Updating $latest_tag to $new_tag"

    # Tag the commit
    git tag "$new_tag"
    git push origin "$new_tag"