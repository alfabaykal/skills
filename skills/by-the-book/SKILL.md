---
name: by-the-book
description: Use before choosing how something works - a mechanism, an API, a pattern, a library, a config, the fix for a bug - and when reviewing or auditing such a choice. Use when a shortcut with a known limit looks tempting ("good enough for now", "redo it if a profile shows it", polling, a sleep loop, a hand-rolled version of what the platform provides), and when the user asks for best practices.
---

# By the book

How a thing works comes from the platform's own guidance, read from the
primary source. Not from memory, and not from what is shortest to write. A
shortcut with a known limit does not go into the product.

Scope is a different question, and it stays small. Before writing anything,
ask in this order: does this need to exist at all, is it already in this
codebase, does the standard library do it, does the platform do it. Build
only what was asked and add no abstraction for a single caller. This skill
decides how the asked thing works, not how much gets built.

## 1. Understand, then name the decision

Read the task and the code it touches. Trace the real flow end to end. For a
bug, find every caller of what you are about to change: the fix goes where
they all pass, not where the symptom showed.

Then one line: what has to work, on which platform and version, under which
rules of this project. Read the project's rules first (`CLAUDE.md`, rule
files, ADRs). A workaround or an owner's decision written there stands: it is
not a deviation.

## 2. Read the primary source

Sources, strongest first:

1. The platform's or framework's documentation and sample code, for the
   version the project targets.
2. The library's own docs, changelog and issue tracker.
3. A well-known guide.
4. A blog post.
5. Your memory.

Open the page, not the search snippet. Answer two questions, both required:

- What does the platform recommend here?
- What bites people? Look at lifecycle, interruption, cancellation, failure
  of a dependency, load, background, concurrency.

A stack skill that is installed can do the lookup. Confirm what it says
against the source it cites. A claim whose source you did not open is marked
"unverified".

## 3. Choose

- The platform has a mechanism for this: use it. No hand-rolled equivalent.
  A callback beats polling, the display's clock beats a sleep loop, a lazy
  result beats a copy of everything, a value from the system beats a number
  you typed.
- The recommended way costs far more than the shortcut, or collides with a
  project rule: stop and ask whoever gave you the task. Give both options
  with their price and with what the product's user would notice. Do not
  settle it yourself by shipping the shortcut.
- No marker of work put off: no `TODO: do properly`, no "if it ever shows in
  a profile". Right code needs no marker, and wrong code does not ship.
- Never simplified away, whatever the size of the task: input validation at
  trust boundaries, error handling that prevents data loss, security,
  accessibility.

## 4. Prove it

Each failure the source warns about gets a test: cancellation, interruption,
a dependency that fails, load. The test waits for a state or an event, never
for time.

A test is a mechanism too, and the same rule holds for it. A test does not
wait on real time. A unit test controls what its code depends on: the clock,
the network, the disk, another service, a system component. Give the code a
seam for that dependency and let the test hold and release it. A test that
needs a real dependency on purpose (an integration test) waits for its
state, never for a pause.

## 5. Report

For each mechanism: the decision, the source (URL with version or date), the
pitfalls covered, what stayed unverified, and any question you sent up.

## 6. A rule comes with its check

When the work produces a rule for the project ("never X", "always Y"), the
same change adds a check that fails the gate on a violation: a lint rule, a
script or a test, with one fixture that must fail and one that must pass. A
rule that only a document holds comes back after the next refactor. If no
check can express the rule, say so in the report.

## As a review axis: Practice

This axis fits any review, whoever runs it: a review skill, a reviewer
agent, or you checking your own diff before you report.

First answer one question: does this diff decide how something works, in
the product or in a test? A rename, a move, a mechanical replacement across
files or a change to documents alone decides nothing: skip the axis and say
so in one line. When unsure, run it.

Reviewing a diff or auditing code, ask of each mechanism: would the
platform's documentation recommend this? A finding names the place, what is
there now, the recommended way with its source, what the product's user
notices, and the size of the fix. Rank findings by what the user notices.
A workaround the project's rules or ADRs document is not a finding.

A rule added to the project's rule files with no check in its gate is a
finding. Test code is in scope: how a test waits is a mechanism.

## Signs you are about to take the shortcut

| Thought | What it means |
|---|---|
| "Good enough for now" | The limit is known. Do it right, or ask. |
| "Redo it if a profile shows it" | Nobody will profile it. It ships as is. |
| "The proper API is more code" | More code is not a reason. Price it and ask. |
| "I know how this works" | That is memory. Open the source. |
| "It passes the tests" | On a quiet machine. Read what the source says breaks. |
| "The platform sends a notification for that, but it is rare" | Rare for you, weekly for a user. Handle it. |
| "The shortest diff wins" | The right mechanism wins. Then keep its diff short. |
