---
layout:     post
title:      Arabic Text in SkiaSharp & Harfbuzz
date:       2020-06-01
summary:    How to render arabic text in SkiaSharp Canvas using Harfbuzz.
categories: SkiaSharp, Harfbuzz, Xamarin.Android, Xamarin.iOS, Xamarin.Forms, Xamarin, C#
published: true
---

SkiaSharp is a 2D graphics system for .NET and C# powered by the open-source Skia graphics engine that is used extensively in Google products.

I came across a requirement to draw dynamic arabic text with specific typeface.

{%highlight c# %}
using (var eventTextShaper = new SKShaper(GetTypeface("GESSTwoLight.ttf")))
using (SKPaint eventTextPaint = new SKPaint())
{
    eventTextPaint.TextAlign = SKTextAlign.Center;
    eventTextPaint.TextSize = 13f;
    eventTextPaint.Color = SKColor.Parse("#dc0234");
    eventTextPaint.Typeface = GetTypeface("GESSTwoLight.ttf");
    eventTextPaint.IsAntialias = true;
    var eventTitleText = "فعاليات";
    var result = eventTextShaper.Shape(eventTitleText, eventTextPaint);
    eventTextPaint.TextEncoding = SKTextEncoding.GlyphId;
    var bytes = result.Codepoints.Select(cp => BitConverter.GetBytes((ushort)cp)).SelectMany(b => b).ToArray();
    canvas.DrawText(bytes, new SKPoint(0, 50), eventTextPaint);
}

//Font by name from Embedded Resources
public static SKTypeface GetTypeface(string fullFontName)
{
    SKTypeface result;
    var assembly = Assembly.GetExecutingAssembly();
    var stream = assembly.GetManifestResourceStream("App.Fonts." + fullFontName);
    if (stream == null)
        return null;
    using (var data = SKData.Create(stream))
    {
        result = SKTypeface.FromData(data);
    }
    return result;
}
{%endhighlight%}

