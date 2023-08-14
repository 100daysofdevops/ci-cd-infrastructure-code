#!/bin/bash

# Configuration
REPO_USER="100daysofdevops" 
REPO_NAME="gitops-pipeline-argocd"       
SOURCE_BRANCH="feature"
TARGET_BRANCH="master"
read -s -p "Enter your GitHub token: " TOKEN

# PR Details
TITLE="My Pull Request"
BODY="This is the description of my pull request."

# Create PR
PR_RESPONSE=$(curl -s -X POST \
    -H "Authorization: token $TOKEN" \
    -H "Accept: application/vnd.github.v3+json" \
    -d "{
          \"title\":\"$TITLE\",
          \"body\":\"$BODY\",
          \"head\":\"$SOURCE_BRANCH\",
          \"base\":\"$TARGET_BRANCH\"
        }" \
    "https://api.github.com/repos/$REPO_USER/$REPO_NAME/pulls")

# Extract PR URL using jq
PR_URL=$(echo "$PR_RESPONSE" | jq -r .html_url)

# Check if PR creation was successful
if [[ $PR_URL != "null" ]]; then
    echo "Pull request created successfully: $PR_URL"
else
    echo "Failed to create pull request. Response:"
    echo "$PR_RESPONSE" | jq
fi
