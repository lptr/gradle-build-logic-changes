#!/bin/bash

# Branch to start from
branch=$(git branch --show-current)

# Limit the number of commits to process (e.g., 1000)
commit_limit=1000

# Get the total number of commits to process (capped at commit_limit)
total_commits=$(git rev-list --max-count=$commit_limit --count $branch)

# Initialize a counter for commits affecting the specified files
build_script_commits=0
build_logic_commits=0

# Walk through each commit on the 'master' branch (up to the commit limit)
for commit in $(git rev-list --max-count=$commit_limit $branch); do
    if git diff-tree --no-commit-id --name-only -r $commit | grep -E '^(build-logic|gradle/plugins)'; then
        build_logic_commits=$((build_logic_commits + 1))
        continue
    fi
    if git diff-tree --no-commit-id --name-only -r $commit | grep -E 'build|settings).gradle.kts$'; then
        build_script_commits=$((build_script_commits + 1))
    fi
done

# Calculate ratio
if [ $total_commits -eq 0 ]; then
    echo "No commits in the repository."
else
    build_script_ratio=$(echo "scale=2; $build_script_commits / $total_commits" | bc)
    build_logic_ratio=$(echo "scale=2; $build_logic_commits / $total_commits" | bc)
    echo "Commits observed: $total_commits"
    echo "Commits affecting build scripts: $build_script_commits ($build_script_ratio)"
    echo "Commits affecting build logic: $build_logic_commits ($build_logic_ratio)"
fi
