<p align="center">
  <img src="assets/baton.svg" alt="Baton — abstract sketch of a bread loaf" width="380">
</p>

# Baton

[![skills.sh](https://skills.sh/b/alfabaykal/skills)](https://skills.sh/alfabaykal/skills)

Drives a feature from a sentence to tested, committed work in one session.

*A baton is a conductor's stick, a relay stick — and, in Russian, a loaf of
bread. This skill is all three: it conducts, it hands off, and it ships the
work in slices.*

It does not replace the [mattpocock skills](https://github.com/mattpocock/skills)
pipeline — it conducts it. `/grilling`, `/to-spec` and `/to-tickets` already
produce a spec and a set of tracer-bullet tickets, and `to-tickets` ends with an
instruction addressed to a human: *work the frontier one ticket at a time,
clearing context between tickets*. Baton is what runs that loop.

## Install

```bash
npx skills add alfabaykal/skills
```

The pipeline it conducts must be installed too:

```bash
npx skills add mattpocock/skills
```

Requires [Node.js](https://nodejs.org) and any supported agent — Claude Code,
Cursor, Codex and [70+ others](https://github.com/vercel-labs/skills#supported-agents).

## Use

```
/baton Add CSV export to the reports page
```

Works on an empty directory and on an existing repository alike.

## What it adds

Three things no skill in the chain does:

1. **Reconnaissance.** How this project builds and tests. Nothing else asks, so
   nothing else can check its own work.
2. **Acceptance of each ticket.** `implement` tests and commits its own work,
   but nothing checks it from the outside before the next ticket builds on top.
   Green closes the ticket; red rolls the commit back.
3. **The frontier loop.** Picking the next unblocked ticket, spawning a clean
   subagent, verifying, committing, repeating.

## Phases

| Phase | What happens |
|---|---|
| 0 — Reconnaissance | Ground (greenfield or brownfield), build and test commands, project conventions, git state; starting from an existing tracker ticket also asks whether the breakdown becomes subtasks there or stays local. Dirty working tree stops the run. |
| 1–3 — The chain | `/grilling` → `/to-spec` → `/to-tickets`, followed as written, with every human gate they declare left in place. |
| 4 — Frontier loop | One ticket, one subagent, one fresh context, running `/implement`. Its work is then verified from the outside: green closes the ticket, red rolls the commit back. Failure → one diagnostic pass, then stop. |
| 5 — Finish | Full verification run, then a report: what was built, what was out of scope, what ran without tests and why, what is still open. |

## Two rules it will not bend

**Phases 1–3 are not modified.** No question caps, no skipped gates, no
reinterpretation. A skill that cripples the skills it delegates to is worse than
no orchestration at all.

**Skipping tests needs a reason.** `implement` uses `/tdd` "where possible", and
an agent can quietly decide it was not possible. Here a ticket that finishes
without tests has to say why, and that reason lands in the final report — so
"tested" never silently means "compiled".

## When not to use it

| Situation | Instead |
|---|---|
| A single-file change | Just ask for it |
| A throwaway experiment answering one question | `/prototype` |
| An idea too big and too foggy for one spec | `/wayfinder` first, then come back |
| You want to drive each stage yourself | Call the chain skills directly |

# Auto-implement

Lets an agent run mattpocock's `implement`, which only a human can start.

`implement` is closed to model invocation, so a coordinator session or a
subagent cannot call it. `auto-implement` reads the installed `implement` file
and follows it as written. Nothing is copied: upstream changes arrive with
`npx skills update`.

```
/auto-implement PROJ-123
```

It adds four things:

1. **One question about testing.** `implement` ends with the full test suite.
   The agent asks once, before it writes code, whether to run the full suite or
   only the tests the change touches. A caller who already said is not asked.
2. **Mechanisms by the book.** Before it chooses how something works, the agent
   calls `by-the-book`. Every change to code also gets a Practice reviewer next
   to standards and spec.
3. **A design axis for visual work.** A change to what a person sees also gets
   a design reviewer with the reference and rendered screenshots.
4. **Project rules.** When the repository has `docs/agents/implement.md`, the
   agent reads it first, and it wins over `implement` where the two disagree.

# By the book

Makes an agent take the mechanism from the platform's own guidance, not the
shortest thing that works.

An agent left alone reaches for the shortcut: polling where the platform has a
callback, a sleep loop, a hand-rolled copy of what the system provides, with a
note to redo it "if a profile ever shows it". `by-the-book` has it read the
primary source first, answer what the platform recommends and what bites
people, and ask before it ships a shortcut with a known limit. Scope stays
small: the skill decides how the asked thing works, not how much gets built.

```
/by-the-book how should the app wait for the network
```

It comes in two layers:

1. **The core.** A few lines that are always in context: `core.md`, put into
   every session and every subagent by two hooks.
2. **The skill.** The full procedure, loaded when a mechanism is chosen or
   reviewed. `auto-implement` calls it before code is written and as the
   Practice axis of its review.

The hooks go into `~/.claude/settings.json`, next to the ones already there:

```json
"SessionStart": [
  {
    "matcher": "startup|resume|clear|compact",
    "hooks": [{ "type": "command", "command": "sh \"$HOME/.claude/skills/by-the-book/inject.sh\" SessionStart", "timeout": 5 }]
  }
],
"SubagentStart": [
  {
    "hooks": [{ "type": "command", "command": "sh \"$HOME/.claude/skills/by-the-book/inject.sh\" SubagentStart", "timeout": 5 }]
  }
]
```

`SessionStart` brings the core back after each compaction too. Without the
hooks the skill still works when called. It is just not always on.

## License

[MIT](LICENSE) © Dmitrii Boiko
