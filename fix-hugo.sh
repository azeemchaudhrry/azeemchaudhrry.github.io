#!/bin/bash
set -e

echo "Locking in the alejandro-ao.com aesthetic..."

# 1. Clean up Hugo Book and root config
git rm --cached themes/hugo-book 2>/dev/null || true
rm -rf themes/hugo-book
rm -f hugo.toml
rm -rf config

# 2. Add Blowfish back as a submodule
git submodule add -b main https://github.com/nunocoracao/blowfish.git themes/blowfish

# 3. Create the modular configuration structure
mkdir -p config/_default
mkdir -p assets

# Core Config
cat <<EOT > config/_default/hugo.toml
baseURL = "https://azeem.dev/"
locale = "en-US"
title = "Azeem Chaudhry"
theme = "blowfish"

[markup.goldmark.renderer]
  unsafe = true

[outputs]
  home = ["HTML", "RSS", "JSON"]
EOT

# Appearance & Layout (The Profile Look)
cat <<EOT > config/_default/params.toml
colorScheme = "blowfish"
defaultAppearance = "dark"
autoSwitchAppearance = false

[homepage]
  layout = "profile"
  showRecent = true
  showRecentItems = 5
  showMoreLink = true
  showMoreLinkDest = "/posts/"

[article]
  showDate = true
  showReadingTime = true
  showTableOfContents = true
EOT

# Author & Menus
cat <<EOT > config/_default/languages.en.toml
locale = "en-US"
languageName = "English"
weight = 1
title = "Azeem Chaudhry"

[author]
  name = "Azeem Chaudhry"
  image = "profile.png"
  headline = "Mobile & LLM Developer"
  bio = "Building mobile applications and open-source AI tools."
  links = [
    { github = "https://github.com/azeemchaudhrry" },
    { linkedin = "https://linkedin.com/in/yourprofile" },
    { email = "mailto:your@email.com" }
  ]

[[menu.main]]
  name = "Blog"
  url = "/posts/"
  weight = 10

[[menu.main]]
  name = "Projects"
  url = "/projects/"
  weight = 20
EOT

# 4. Setup homepage routing
mkdir -p content/posts
cat <<EOT > content/_index.md
---
title: "Home"
type: "home"
---
EOT

echo "Setup complete! Drop a square photo named 'profile.png' into your 'assets/' folder and run 'hugo server -D'."