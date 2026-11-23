---
name: auto-implement
description: Use when an agent, not a human, has to implement a ticket or a spec - a coordinator session handing a ticket to an executor, a subagent told "implement X", any session asked to implement without the user typing /implement. Runs mattpocock's `implement` as written, asks once how much testing to run, checks every mechanism against the platform's guidance, and adds a design axis to the review of visual work.
---

# Auto-implement

`implement` from [mattpocock/skills](https://github.com/mattpocock/skills) is
closed to model invocation: only a human typing `/implement` starts it. This
skill lets an agent run it without copying it. The upstream file stays the
source, so when it changes, your behaviour changes with it.

## 1. Read `implement` and follow it

Read the installed skill file, the first of these that exists:

1. `~/.claude/skills/implement/SKILL.md`
2. `~/.agents/skills/implement/SKILL.md`
3. `~/.claude/plugins/cache/mattpocock/mattpocock-skills/*/skills/engineering/implement/SKILL.md`,
   the newest version

Follow it as written. Where it names another skill (`/tdd`, `/code-review`),
call that skill with the Skill tool. Reading your own diff does not count as a
code review.

If none of the files exists, or the one you found is not mattpocock's
`implement`, stop and tell whoever called you to run
`npx skills add mattpocock/skills`. Do not work from what you remember the
skill saying.

## 2. Settle the test run before you write code

`implement` ends with the full test suite. On a large repository, or when a
coordinator runs one gate for many tickets, that run is paid for twice. Settle
it once, up front:

- The caller already said which run they want, in the command, the ticket or
  the brief: take that.
- The caller did not say: ask once, before the first line of code. "Full suite
  at the end, or only the tests this change touches?" A user started you - ask
  them with a question tool. A session started you - message that session.
- Nobody answers: run the full suite, as `implement` says.

The answer changes that one step. The rest of `implement` stands.

## 3. Mechanisms go by the book

Before you choose how something works - an API, a pattern, a library, the fix
for a bug - call `by-the-book` with the Skill tool and follow it. What it has
you report goes into your report.

`/code-review` checks standards and spec. Every change to code also gets a
Practice axis in the same round: a separate reviewer that gets the diff and
checks each mechanism in it against the platform's guidance, as `by-the-book`
describes under "As a review axis". A change to documents alone needs none.

If `by-the-book` is not installed, stop and tell whoever called you to run
`npx skills add alfabaykal/skills`.

## 4. Visual work gets a Design axis

When the change touches what a person sees - a screen, a component, layout,
motion - add a Design axis to the same round: a separate reviewer that gets
the diff, the design reference (a mockup, a board, or the existing screen you
are matching) and rendered screenshots. It looks for deviations from the
reference, clipped or overflowing text, fixed sizes on text, contrast below
AA, and custom controls where the platform has its own.

Fix every finding on every axis, then review again. Stop when a round comes
back clean.

## 5. Project rules

If the repository has `docs/agents/implement.md`, read it before you start and
follow it. It holds what is true of that project only: where executors commit,
how they report, which commands run the tests. Where it contradicts
`implement`, the project file wins. Name each such override in your report.

## Report

End with what you built, the commit, each mechanism you chose with its source,
the test runs (red, then green), each review round with what it found, and
what is still open.
