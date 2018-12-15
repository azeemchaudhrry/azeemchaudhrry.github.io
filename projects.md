---
layout: page
title: Projects
permalink: /projects/
tags: project, portfolio
---

<div>
  {% for project in site.data.projects %}
    <div>
        <h3 class="f3 post-title">{{project.name}}</h3>
      <a href="{{project.github_url}}" class="f6 link mid-gray dim">{{project.github_url}}</a>
      <!-- <img src="/images/{{project.image}}"> -->
      <p class="f4 lh-copy mt2">{{project.description}}</p>
    </div>
    <div class="mb2">
        {% if project.websiteurl %}
            <a class="store-icons" href="{{ project.websiteurl }}" rel="nofollow" target="_blank" title="{{ project.name }}">
                <i class="fas fa-link project-links" style="color: #1971c2;"></i>
            </a>
        {% endif %}
        {% if project.appstoreurl %}
            <a class="store-icons" href="https://itunes.apple.com/us/app/{{ project.appstoreurl }}" rel="nofollow" target="_blank">
                <i class="fab fa-app-store-ios project-links" style="color: #2d2d01;" aria-hidden="true"></i>
            </a>
        {% endif %}
        {% if project.playstoreurl %}
            <a class="store-icons" href="https://play.google.com/store/apps/details?id={{ project.playstoreurl }}" rel="nofollow" target="_blank" title="{{ project.name }}">
                <i class="fab fa-google-play project-links " style="color: #689f38;"></i>
            </a>
        {% endif %}
    </div>
    <div class="project-content">
        <div class="tag-holder">
        <p class=""> Tech Stack [
          {% if project.tags %}
            {% for j in project.tags %}
              <span class="tags tag-filter" data-tag="{{ j | downcase }}"><a href="#{{ j }}">{{ j }}</a></span>
            {% endfor %}
          {% endif %}
          ]</p>
        </div>
    </div>
  {% endfor %}
</div>