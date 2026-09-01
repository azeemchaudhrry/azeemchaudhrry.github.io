---
title: "The Model on the Phone"
date: 2026-09-01T09:00:00+01:00
draft: false
description: "Eight things I got wrong building a conversational feature on Apple's on-device Foundation Models, and the measurements that corrected me."
summary: "Eight things I got wrong building on Apple's on-device model — and the measurements that corrected me. Most of them were not about prompting."
slug: "the-model-on-the-phone"
tags:
  - swift
  - ios
  - foundation-models
  - on-device-ai
  - apple-intelligence
categories:
  - engineering
keywords:
  - Apple Foundation Models
  - on-device LLM
  - Generable
  - LanguageModelSession
  - iOS 26
showToc: true
---

Eight things I got wrong building a conversational feature on Apple's on-device model — and the
measurements that corrected me. Most of them were not about prompting.

| | |
|---|---|
| Generation | 1,700–2,330 ms |
| Timeout that failed | 2,500 ms |
| Eval cases | 10 / 10 |
| Transcript kept | none |

<!--more-->

## 01 — The use case parameter is a real decision

`SystemLanguageModel` takes a `useCase`. My task was pulling structured fields out of a sentence, which
sounded like tagging, so I reached for `.contentTagging`.

It kept answering *about* the input rather than extracting from it. Given a shopper's message it would
return categories — "product search", "price range", "information request" — which is exactly what a model
tuned for describing content should do. I wanted the person's own words back.

```swift
// .general, not .contentTagging. The tagging model answers with
// categories *about* the input rather than the shopper's own words.
// Do not swap this back.
private let model = SystemLanguageModel(useCase: .general)
```

One parameter, and the difference between extraction and classification. The comment in my source is a
warning to my future self.

## 02 — Availability is not a promise

The framework will tell you the model is `.available` and then fail every single generation. On the
simulator the assets simply are not there. `.available` means the OS supports the framework — not that a
request will succeed.

> **Cost me a day.** I treated availability as a precondition and spent hours debugging my own code before
> accepting that the environment was the problem. Check it to decide whether to *offer* the feature. Never
> treat it as a guarantee the next call will work.

## 03 — Neither test environment can generate

This follows from the last one and it is worse than it first looks. The simulator cannot generate. And a
SwiftPM test target has no host app, so it cannot generate either.

Which means the unit suite — however large — can never exercise the model. Mine has hundreds of tests and
every one of them runs against a stub. That is fine, as long as you know it, because the tests are covering
state transitions and merge semantics rather than the model itself. The trap is believing green tests say
anything about generation quality.

## 04 — So the eval harness goes inside the app

The fix was to stop trying to test the model from the outside. I put an evaluation mode into the app
itself: launch with an environment variable, run a fixed set of cases against the real model on real
hardware, print a report, exit.

```text
EDGEAI_EVALS=1

PASS  a colour refines rather than restarts
PASS  a wedding is not a size
PASS  bare product invents nothing
PASS  under means a ceiling
...
10/10 passed
```

This became the only feedback loop that mattered. It also settled an argument I could not otherwise have
settled: two prompt variants, same ten cases, one scored 10 and the other 9. Ship the winner, delete the
loser, stop debating which one felt better.

## 05 — Latency is the design constraint

Generation runs **1,700 to 2,330 ms** on device for my schema. I set a 2.5 second timeout, which sounded
generous and left about 170 ms of headroom. Turns began failing on a coin toss.

The lesson is not "use a bigger timeout". It is that the number has to come from measuring your own schema
on your own hardware, because schema size drives generation time and nobody else's figure transfers.

## 06 — The fastest call is the one you skip

Once you accept that every model call costs around two seconds, the architecture writes itself. Most turns
in a conversation are not language problems at all. Tapping a filter chip. Typing "under £80". "Cheapest
first." "Start over."

> A parser handles those in about zero milliseconds, with no chance of the model inventing anything.

So a deterministic layer reads every turn first, and the model only sees what is genuinely ambiguous. This
is the single biggest thing I would tell someone starting: decide what does *not* need the model before you
decide how to prompt it.

## 07 — The schema is the prompt

This one surprised me most. Doc comments on `@Generable` types are not documentation. They are sent to the
model. So are your `@Guide` descriptions, your enum case names, and the shape of the type itself.

```swift
@Generable
enum ValueChangeResponse {
    /// The message says nothing about this. The usual answer.
    case unchanged
    case set
    /// The shopper took it back — "no price limit", "any brand".
    case clear
}
```

Which leads to the finding I would put above all the others. My first schema asked the model to return the
*complete state* every turn. Hand a model a form and it fills the form — all of it. Type one bare product
word and it comes back having decided a colour and a size that nobody mentioned. In one run that narrowed
several thousand matching products down to a few dozen.

Restructuring the schema to describe the **change** rather than the state fixed it, because `unchanged`
became a cheap and legal answer. The old schema had no way to say "this message tells me nothing about
price" — the nearest available answer was a plausible guess.

## 08 — Sessions are disposable; the state is yours

I build a fresh `LanguageModelSession` for every request and keep no transcript. The conversation lives in
application state, and each request is told only what I choose to hand it.

That sounds wasteful and is not. It means the model can never quietly become the source of truth about what
the user is doing, and it makes context overflow easy to reason about: with no history to blame, an
overflow means *this one request* is too large.

Two smaller things worth doing early. Call `prewarm()` so your first real request is not also the cold one.
And serialise requests, or two concurrent turns will contend for the same on-device capacity and both
arrive late.

---

## What I would tell myself in week one

I spent the first stretch treating this like a small cloud model behind a Swift API. It is not. It is a
constrained device resource with its own availability rules, its own latency floor, and its own capacity
limits — and the framework is honest about all three if you read it that way rather than as an
inconvenience.

The prompt was the last thing I needed to fix, and the smallest. Everything above it — what you ask for,
when you ask, and whether you need to ask at all — mattered more.

---

*Measurements are from one feature on one device and one schema; treat them as a starting point for your
own, not as benchmarks. The product-count figure in §07 is a single observed run, quoted to show the shape
of the failure rather than to size it.*
