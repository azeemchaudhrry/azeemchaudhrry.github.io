#!/bin/bash
set -e

echo "Building Project Cards..."

# Clean up old project files to prevent conflicts
rm -f content/projects.md content/projects/index.md content/projects.markdown
rm -f content/projects/*.md

# Create the main Projects page
mkdir -p content/projects
cat << 'EOF' > content/projects/_index.md
---
title: "Projects"
description: "A selection of my mobile apps, frameworks, and web portals."
cascade:
  showReadingTime: false
---
EOF

# 1. Smart Media
mkdir -p content/projects/smart-media
cat << 'EOF' > content/projects/smart-media/index.md
---
title: "Smart Media Mobile Apps"
date: 2020-01-01
tags: ["C#", "Java", "Xamarin", "iOS", "Android", "OData"]
summary: "Smart Media Platform is an interactive media solution aimed at enhancing media usability."
showReadingTime: false
---
Smart Media Platform is an interactive media solution, aimed to enhance media and information usability. The Smart Media Center puts your company's precious multimedia collection in the palm of viewers hand seamlessly; with its light feather weight foot print it puts an end to sorry days of endless buffering, complex settings, and jumbled user interfaces.
EOF

# 2. Clipping Station
mkdir -p content/projects/clipping-station
cat << 'EOF' > content/projects/clipping-station/index.md
---
title: "Clipping Station"
date: 2019-01-01
tags: ["C++", "Qt", "Ubuntu", "mySql", "OCR", "Automation"]
summary: "Utilize cutting-edge technology to provide publications for press clippings in the MENA region."
showReadingTime: false
---
Utilize the cutting edge technology to provide publications for press clippings in Middle East and North Africa (MENA).
EOF

# 3. Abu Dhabi Chamber
mkdir -p content/projects/abu-dhabi-chamber
cat << 'EOF' > content/projects/abu-dhabi-chamber/index.md
---
title: "Abu Dhabi Chamber of Commerce"
date: 2018-01-01
tags: ["C#", "Java", "Xamarin", "iOS", "Android", "ASP.NET"]
summary: "Mobile Apps that facilitate users to create/update COO and view the Commercial directory."
showReadingTime: false
---
Abu Dhabi Chamber of Commerce Mobile Apps that will facilitate the users to create/update COO and get updated with Commercial directory.
EOF

# 4. Sharjah Events
mkdir -p content/projects/sharjah-events
cat << 'EOF' > content/projects/sharjah-events/index.md
---
title: "Sharjah Events"
date: 2017-01-01
tags: ["C#", "Java", "Xamarin.Forms", "iOS", "Android", "Angular", ".NET Core"]
summary: "The official website and mobile apps for events held in Sharjah, UAE, throughout the year."
showReadingTime: false
---
Sharjah Events is the official website for events held in Sharjah, UAE, throughout the year.
EOF

# 5. Sharjah24
mkdir -p content/projects/sharjah-24
cat << 'EOF' > content/projects/sharjah-24/index.md
---
title: "Sharjah24"
date: 2017-02-01
tags: ["iOS", "Swift", "Android", "Java", "Retrofit", "AFNetworking"]
summary: "An online news portal based in Sharjah, serving as a reliable news reference for the UAE."
showReadingTime: false
---
Sharjah 24 is an online news portal based in the emirate of Sharjah. The site aims to become a reliable news reference covering all events in the emirate of Sharjah.
EOF

# 6. NYC Consumer App
mkdir -p content/projects/nyc-consumer-app
cat << 'EOF' > content/projects/nyc-consumer-app/index.md
---
title: "NYC Consumer App"
date: 2016-01-01
tags: ["Xamarin", "iOS", "ASP.NET"]
summary: "A mobile experience for retail shoppers, powered by CORE, enabling a connected shopping experience."
showReadingTime: false
---
The VA Consumer app, powered by CORE, is a mobile experience for retail shoppers. It is one app in an ecosystem of apps that constitute the touch points of a retail customer.
EOF

# 7. Core Framework
mkdir -p content/projects/core-framework
cat << 'EOF' > content/projects/core-framework/index.md
---
title: "Core Framework"
date: 2015-01-01
tags: ["C#", "Java", "Xamarin", "iOS", "Android", "ASP.NET"]
summary: "A platform producing a unified user experience across devices with accelerated provisioning."
showReadingTime: false
---
CORE is a platform which produces a unified user experience across all devices with accelerated provisioning for new, innovative business applications.
EOF

# 8. Radiant Site Manager
mkdir -p content/projects/radiant-site-manager
cat << 'EOF' > content/projects/radiant-site-manager/index.md
---
title: "Radiant Site Manager (RSM)"
date: 2014-01-01
tags: ["C++", "C#", "Python", "ASP.NET", "SQL"]
summary: "NCR's site manager application with 60+ real-time reports and reconciliation applets."
showReadingTime: false
---
NCR's Radiant Site Manager (RSM) is an application that includes more than 60 real-time reports and reconciliation applets that show common fraudulent activities. This software increases store system availability and streamlines the support process.
EOF

echo "Project cards generated! Check http://localhost:1313/projects/"