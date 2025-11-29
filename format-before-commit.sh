
#!/bin/bash
# Pre-commit Prettier Formatting Script
# Auto-formats all files before committing to prevent CI failures

echo -e "\033[0;36m=== Pre-Commit Prettier Formatter ===\033[0m"
echo ""

# Navigate to script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR" || exit 1

# Check if there are staged files
STAGED_FILES=$(git diff --cached --name-only --diff-filter=ACMR)
if [ -z "$STAGED_FILES" ]; then
    echo -e "\033[0;33mNo staged files found. Stage your changes first with:\033[0m"
    echo -e "\033[0;90m  git add <files>\033[0m"
    echo ""
    echo -e "\033[0;33mOr format all files with:\033[0m"
    echo -e "\033[0;90m  npx prettier . --write\033[0m"
    exit 0
fi

FILE_COUNT=$(echo "$STAGED_FILES" | wc -l)
echo -e "\033[0;32mFound $FILE_COUNT staged file(s)\033[0m"
echo -e "\033[0;90mRunning Prettier...\033[0m"
echo ""

# Format staged files
echo "$STAGED_FILES" | while IFS= read -r file; do
    npx prettier "$file" --write --log-level warn
done

echo ""
echo -e "\033[0;90mRe-staging formatted files...\033[0m"
echo "$STAGED_FILES" | xargs git add

echo ""
echo -e "\033[0;32m✓ All staged files formatted and re-staged!\033[0m"
echo ""
echo -e "\033[0;36mYou can now commit:\033[0m"
echo -e "\033[0;90m  git commit -m \"your message\"\033[0m"
echo ""
