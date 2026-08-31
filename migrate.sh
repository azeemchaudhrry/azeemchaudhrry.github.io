#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "Starting migration to Hugo..."

# 1. Create and switch to a new branch
# git checkout -b hugo-migration

# 2. Clean up Jekyll files and folders (Keeping CNAME, README.md, and _posts)
# echo "Removing old Jekyll files..."
# rm -rf _layouts _includes _sass _data css sites Gemfile Gemfile.lock _config.yml Rakefile feed.xml _site index.html about.md contact.html fb-instant-articles.xml projects.md

# 3. Initialize a fresh Hugo site in the current directory
# echo "Initializing Hugo..."
# hugo new site . --force

# 4. Add the Swiss Operator theme as a submodule
# echo "Installing swiss-operator theme..."
# git submodule add https://github.com/carlosplanchon/hugo-theme-swiss-operator themes/swiss-operator

# 5. Create the base Hugo configuration
# echo "Configuring hugo.toml..."
# cat <<EOT > hugo.toml
# baseURL = "https://azeem.dev/"
# languageCode = "en-us"
# title = "Azeem Chaudhry"
# theme = "swiss-operator"

# [markup.highlight]
# style = "github-dark"
# lineNos = true
# EOT

# 6. Migrate content to Hugo's folder structure
echo "Moving posts..."
mkdir -p content/posts
mv _posts/* content/posts/
rm -rf _posts

# 7. Set up GitHub Actions for automatic deployment
echo "Creating GitHub Actions workflow..."
mkdir -p .github/workflows
cat <<EOT > .github/workflows/hugo.yml
name: Deploy Hugo site to Pages

on:
  push:
    branches: ["main"]
  workflow_dispatch:

permissions:
  contents: read
  pages: write
  id-token: write

concurrency:
  group: "pages"
  cancel-in-progress: false

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4
        with:
          submodules: recursive
          fetch-depth: 0
      - name: Setup Hugo
        uses: peaceiris/actions-hugo@v3
        with:
          hugo-version: 'latest'
          extended: true
      - name: Build
        run: hugo --minify
      - name: Upload artifact
        uses: actions/upload-pages-artifact@v3
        with:
          path: ./public

  deploy:
    environment:
      name: github-pages
      url: \${{ steps.deployment.outputs.page_url }}
    runs-on: ubuntu-latest
    needs: build
    steps:
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4
EOT

echo "Migration complete! Your posts are now in content/posts/."
echo "Run 'hugo server -D' to preview your site locally."