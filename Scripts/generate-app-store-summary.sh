#!/bin/bash

set -euo pipefail

# Check if current commit is tagged with a version tag
current_tag=$(git describe --exact-match --tags --match="v*.*.*-*" HEAD 2>/dev/null || echo "")

if [[ -n "$current_tag" ]]; then
    # Current commit is tagged, find the previous version tag
    echo "Current commit is tagged as $current_tag"
    
    # Get all version tags sorted, find the one before current
    all_tags=$(git tag --list "v*.*.*-*" --sort=-version:refname)
    previous_tag=""
    found_current=false
    
    for tag in $all_tags; do
        if [[ "$found_current" == true ]]; then
            previous_tag="$tag"
            break
        fi
        if [[ "$tag" == "$current_tag" ]]; then
            found_current=true
        fi
    done
    
    if [[ -z "$previous_tag" ]]; then
        echo "No previous version tag found before $current_tag"
        echo "Showing all commits up to $current_tag:"
        git log --oneline --pretty=format:"• %s" $current_tag
    else
        echo "Changes from $previous_tag to $current_tag:"
        echo ""
        commits=$(git log $previous_tag..$current_tag --oneline --pretty=format:"• %s" 2>/dev/null || echo "No commits found")
        
        if [[ -z "$commits" ]]; then
            echo "No changes between $previous_tag and $current_tag"
        else
            echo "$commits"
        fi
    fi
else
    # Current commit is not tagged, find the latest version tag
    previous_tag=$(git describe --tags --match="v*.*.*-*" --abbrev=0 2>/dev/null || echo "")
    
    if [[ -z "$previous_tag" ]]; then
        echo "No previous version tag found matching pattern v*.*.*-*"
        echo "Showing all commits:"
        git log --oneline --pretty=format:"• %s" HEAD
    else
        echo "Changes since $previous_tag:"
        echo ""
        
        # Get commits since the previous tag
        commits=$(git log $previous_tag..HEAD --oneline --pretty=format:"• %s" 2>/dev/null || echo "No commits found")
        
        if [[ -z "$commits" ]]; then
            echo "No changes since $previous_tag"
        else
            echo "$commits"
        fi
    fi
fi

echo "" 