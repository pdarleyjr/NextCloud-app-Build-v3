#!/bin/bash
# shellcheck shell=bash

# Setup GitHub Authentication for Automation

echo "Configuring Git global settings..."
git config --global user.name "pdarleyjr"
git config --global user.email "pdarleyjr@gmail.com"
git config --global credential.helper store

echo "Storing GitHub credentials..."
token="${GITHUB_TOKEN}"
if [ -z "$token" ]; then
    echo "Error: GITHUB_TOKEN environment variable not set."
    exit 1
fi

# Use git credential approve to securely store the token
echo "protocol=https
host=github.com
username=pdarleyjr
password=${token}" | git credential approve

echo "GitHub authentication setup complete."