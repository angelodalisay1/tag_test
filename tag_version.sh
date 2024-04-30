#!/bin/bash

# Get the latest tag
latest_tag$(git describe --tags --abbrev=0)

# Split the version number
IFS='.' read -ra version_parts <<< "$latest_tag"

# Increment the last part of the version
major=${version_parts[0]}
minor=${version_parts[1]}
patch=${version_parts[2]}
patch=$((patch + 1))

# Create the new tag
new_tags="$major.$minor.$patch"

# Tag the commit
git tag "$new_tag"
git push origin "$new_tag"