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

Before the final run, bring your work onto the current tip of the branch it
lands on, the way the project merges. The final run tests what will land.

## 3. Mechanisms go by the book

The skills below come from the `by-the-book` plugin. These are steps of this
skill, not suggestions: call each with the Skill tool by its full name at its
step, whether or not your brief names it, and follow it.

- Before the first line of code: `by-the-book:how-should-it-work`. Every
  change that decides how something works counts: an API, a pattern, a
  library, a dependency version, a build file, a config value, the fix for a
  bug. What it has you report goes into your report.
- Before the first test you write or change:
  `by-the-book:will-it-pass-tomorrow`.
- `/code-review` checks standards and spec. In the same round, a separate
  reviewer applies `by-the-book:is-it-by-the-book`. That skill says when the
  axis applies and when to skip it.

Skip a step only when the ticket has nothing for it (no test touched, for
example), and say so in the report.

If the plugin is not installed, stop and tell whoever called you to run
`claude plugin install by-the-book --marketplace alfabaykal/by-the-book`.

## 4. Visual work gets a Design axis

When the change touches what a person sees - a screen, a component, layout,
motion - add a Design axis to the same round: a separate reviewer that gets
the diff, the design reference (a mockup, a board, or the existing screen you
are matching) and rendered screenshots. It looks for deviations from the
reference, clipped or overflowing text, fixed sizes on text, contrast below
AA, and custom controls where the platform has its own.

Fix every finding on every axis. Review again only when a fix changed
behavior. A fix that changes only form (a name, an import, the order of
imports, the wording of a comment) needs no new round: list it in the report.
Stop when a round comes back clean or with form findings only, fixed.

## 5. Fixes after acceptance

When the caller sends back remarks on work that was already reviewed and
accepted, do not start `implement` again. Make the fixes, run the tests
they touch, and review again only by the rule above: a fix that changes
behavior gets a new round on the axes it touches, a fix of form gets none.
Report each remark and what you did with it.

## 6. Project rules

If the repository has `docs/agents/implement.md`, read it before you start and
follow it. It holds what is true of that project only: where executors commit,
how they report, which commands run the tests. Where it contradicts
`implement`, the project file wins. Name each such override in your report.

## Report

End with what you built, the commit, each mechanism you chose with its source,
the test runs (red, then green), each review round with what it found, and
what is still open. Also:

- Which `by-the-book` skills you loaded and at which step. A step you skipped,
  and why.
- No red run before the green one: say so under what is still open, and do
  not call the work test-first. Give the reviewers your test runs, so they see
  it too.
- The reviewer's "Practice differs from a project rule" section, copied as
  written. Change nothing because of it: the owner decides.
