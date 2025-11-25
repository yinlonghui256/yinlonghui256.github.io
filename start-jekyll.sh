#!/bin/bash
# Jekyll Development Server Startup Script for Linux/WSL
# Properly configures UTF-8 encoding

# Set locale to UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Configure Ruby encoding
export RUBYOPT='-EUTF-8:UTF-8'

# Navigate to script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR" || exit 1

echo -e "\033[0;32mStarting Jekyll development server...\033[0m"
echo -e "\033[0;90mLocale: UTF-8 (en_US.UTF-8)\033[0m"
echo -e "\033[0;90mRuby: External=UTF-8, Internal=UTF-8\033[0m"
echo ""
echo -e "\033[0;33mTip: Before committing, run ./format-before-commit.sh to auto-format files\033[0m"
echo ""

# Start Jekyll with live reload
bundle exec jekyll serve --host 127.0.0.1 --port 4000 --livereload --incremental

# Check exit code
if [ $? -ne 0 ]; then
    echo ""
    echo -e "\033[0;31mJekyll exited with error code $?\033[0m"
    echo -e "\033[0;33mPress Enter to close...\033[0m"
    read -r
fi
