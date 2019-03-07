---
layout:     post
title:      Two Drawer Layouts from Same Side in Xamarin.Android
date:       2019-01-05
summary:    How to show secondary drawer in android material drawers over primary.
categories: Xamarin.Android
published:  true
---

In one of the projects, client require to built a design where a secondary drawer will opened over already opened primary drawer.

As per Android Material Design guidelines its not recommended and its not implemented in <span class="red">android.support.v4.widget.DrawerLayout</span>.
If we try to implement it in code like following, it throws exception, only one drawer can be shown.

{%highlight xml %}
<?xml version="1.0" encoding="utf-8"?>
<android.support.v4.widget.DrawerLayout 
    xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    android:id="@+id/drawer_layout"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:fitsSystemWindows="true">
    <!-- Layout to contain contents of main body -->
    <FrameLayout
        android:id="@+id/content_frame"
        android:layout_width="match_parent"
        android:layout_height="match_parent" />
    <!-- First container for drawer contents -->
    <android.support.design.widget.NavigationView
        android:id="@+id/first_nav_view"
        android:layout_width="wrap_content"
        android:layout_height="match_parent"
        android:layout_gravity="start"
        android:fitsSystemWindows="true" />
    <!-- Second container for drawer contents -->
    <android.support.design.widget.NavigationView
        android:id="@+id/second_nav_view"
        android:layout_width="wrap_content"
        android:layout_height="match_parent"
        android:layout_gravity="start"
        android:fitsSystemWindows="true" />
</android.support.v4.widget.DrawerLayout>
{%endhighlight%}


To show both drawers from same side we need to extend the <span class="red">android.support.v4.widget.DrawerLayout</span> to handle the navigation of secondary drawer over primary.


<script src="https://gist.github.com/azeemchaudhrry/39a1e189f4a5c6e50fca7caa82095361.js"></script>