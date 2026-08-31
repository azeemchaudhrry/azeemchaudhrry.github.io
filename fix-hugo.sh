#!/bin/bash

set -e

echo "Fixing Jekyll frontmatter..."

# Loop through all markdown files in the posts directory
find content/posts -type f \( -name "*.md" -o -name "*.markdown" \) | while read -r file; do
    # 1. Delete 'published: true' (Hugo assumes true by default)
    sed -i '' '/^published:[[:space:]]*true/d' "$file"
    
    # 2. Replace 'published: false' with 'draft: true'
    sed -i '' 's/^published:[[:space:]]*false/draft: true/g' "$file"
done

echo "Frontmatter fixed!"


echo "Configuring Hugo to allow raw HTML..."

# Check if the unsafe HTML setting is already in hugo.toml, if not, append it
if ! grep -q "\[markup.goldmark.renderer\]" hugo.toml; then
    cat <<EOT >> hugo.toml

[markup.goldmark.renderer]
  unsafe = true
EOT
    echo "Raw HTML rendering enabled in hugo.toml!"
else
    echo "Raw HTML config already exists in hugo.toml."
fi

echo "All fixes applied! You can now run: hugo server -D"