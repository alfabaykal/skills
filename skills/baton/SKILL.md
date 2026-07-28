---
name: baton
description: Use when the user wants a feature or project driven end-to-end in one session — from a sentence to tested, committed work — with phrases like "build this end to end", "take it from idea to done", "ship the whole thing". Conducts the mattpocock chain (grilling → spec → tickets) and then implements it ticket by ticket, one fresh subagent each, test-first, committing only on green. Also use when the user explicitly invokes /baton.
---

# Baton

## Overview

Baton conducts a chain that already exists. `/grilling`, `/to-spec` and
`/to-tickets` produce a spec and a set of tracer-bullet tickets; `to-tickets`
then ends with an instruction addressed to a human — "work the frontier one
ticket at a time, clearing context between tickets". Baton is what runs that
loop, plus the three things no skill in the chain does:

1. **Reconnaissance** — how this project builds and tests. Nothing else asks, so
   nothing else can check its own work.
2. **Acceptance of each ticket.** `implement` tests and commits its own work,
   but nothing checks that work from the outside before the next ticket builds
   on it. One commit per ticket is a rollback point only if someone verified it.
3. **The frontier loop itself** — picking the next unblocked ticket, spawning a
   clean subagent, committing, repeating.

**Phases 1–3 are not yours to modify.** You pass the baton to those skills and
follow them as written, including every gate they ask the user for. Capping,
skipping or reinterpreting them is the failure mode this skill was built to
avoid.

**This is not about removing the human.** The audience is a developer. What gets
automated is the conducting, not the judgement.

## Prerequisites

The chain must be installed:

```bash
npx skills add mattpocock/skills
```

Used: `grilling`, `to-spec`, `to-tickets`, `implement`, `tdd`,
`diagnosing-bugs`. If the tracker vocabulary has never been configured,
`to-spec` and `to-tickets` will say so — run `/setup-matt-pocock-skills`.

## When to Use

- A feature or project that spans several tickets and one person wants it driven
  the whole way in one session.
- Greenfield ("build me X") and brownfield ("add X to this repo") alike.

**When NOT to use:** a single-file change (just make it); a throwaway experiment
to answer one question (`/prototype`); an idea too big and too foggy for one
spec (`/wayfinder` first, then come back); the user wants to drive each stage
themselves (call the chain skills directly).

## Phase 0 — Reconnaissance

Gather what the later phases cannot work without. Do this before any question
about the feature itself.

**Resume first.** If a spec and tickets for this work already exist, a previous
run was interrupted. Do not start over and do not rewrite them — read the
tickets, and re-enter at phase 4 on the frontier. Eight tickets rarely fit one
session, so this is the normal case, not the edge case.

**Ground.** Empty directory → greenfield. Existing code → brownfield.

**Verification commands.** A fast one (compile plus the affected module's tests)
and a full one. Look in CI config, `pom.xml` / `package.json` / `Makefile`,
CLAUDE.md, README. Not found → ask once, then record the answer so it is never
asked again.

**Test posture.** If the project has test infrastructure, TDD is on and you ask
nothing — the question would be rhetorical. If there is no test infrastructure
at all, ask exactly one question: set it up and go test-first, or build without
tests? Record the answer.

**Ticket destination.** When a tracker is configured and the work arrives as an
existing ticket on it, ask exactly one question: break it down as subtasks of
that ticket on the tracker, or in a local `tickets.md` that references it? A
shared tracker has an audience — whether eight agent-made subtasks under a
watched ticket are visibility or noise is a team norm baton cannot read.
Record the answer. This resolves the destination `to-tickets` reads from its
configuration; how it publishes is untouched, including its own rule that the
parent issue is never closed or modified.

**Conventions (brownfield).** CLAUDE.md / CONTEXT.md, ADRs, the domain glossary.
This bundle is handed to every subagent in phase 4 — a fresh context knows
nothing about this project's rules unless you carry them across.

**Git.**

| State | Action |
|---|---|
| No repository | `git init` |
| Clean tree | Brownfield: branch `baton/<feature>`. Merging to the trunk stays the user's call. |
| Dirty tree | **Stop.** Never build on top of unsaved work — ask the user to commit or stash. |

## Phases 1–3 — the chain, verbatim

Run `/grilling`, then `/to-spec`, then `/to-tickets`. Follow each as written.

They ask the user things — `to-spec` confirms the test seams, `to-tickets` quizzes
the ticket breakdown. **Those gates stay.** They are the two places where a wrong
assumption is cheap to correct; past them it is expensive.

Add nothing, cap nothing, skip nothing. Your job here is to pass the baton and
carry the phase-0 findings forward so the spec is written against this project's
real conventions and commands.

## Phase 4 — Frontier loop

Repeat while open tickets remain.

**1. Pick.** A ticket whose blockers are all closed, read from wherever
`to-tickets` published — the local `tickets.md` or the configured tracker.

**2. Spawn.** One ticket, one subagent, one fresh context. Never two tickets in
one context. Hand it: the ticket body, the spec sections it needs, the phase-0
convention bundle, and the verification commands.

**3. Implement.** The subagent runs `/implement` on that one ticket. `implement`
drives `/tdd` at the pre-agreed seams, runs typechecking and tests, reviews its
own work, and commits — do not reach past it and do not do its job for it.

One thing is tightened, because `implement` says "use `/tdd` **where
possible**" and an agent can quietly decide it was not possible: **a ticket
finished without tests must carry a reason, and that reason goes into the final
report.** Nothing observable from the outside — a migration, a config edit, docs
— is a reason. "It seemed fine" is not. If phase 0 recorded a no-tests answer,
the report says so once, at the top, and no per-ticket reason is needed.

**4. Accept and close.** The subagent has returned and committed. Run the fast
verification yourself — accepting its work is your job, not its own.

Green → **mark the ticket done where it lives**: tick its acceptance criteria in
`tickets.md`, or close the issue on the tracker. Red → **roll its commit back**
and go to step 5; the ticket stays open.

Step 1 reads blocker state from these same tickets. A finished ticket left open
stalls every ticket it blocks, and the loop has no other memory of what is done.
Closing is part of finishing, not bookkeeping afterwards.

**5. On failure, diagnose.** A failed ticket gets one pass of
`/diagnosing-bugs` — not a rerun of the same attempt in a fresh context. Still
failing → stop, and tell the user in plain terms what blocks it and what you
need. There is no third attempt.

Record the blocker on the ticket itself before stopping. The session ends; the
ticket is what the next one reads.

**6. Advance.** The next ticket starts from the merged state. Tickets are
serialised: a ticket's file set is only known after it runs, so disjointness
cannot be predicted up front.

Report one line per completed ticket — what now works, and the count.

## Phase 5 — Finish

Run the full verification once, then report:

- what was built, and the exact command to run or test it;
- what the spec put out of scope;
- which tickets ran without TDD, and why;
- what is still open — placeholders, keys, manual steps, and the parent ticket
  when the run started from one: closing it is the user's call.

## Rationalizations — STOP

| Excuse | Reality |
|---|---|
| "They're in a hurry, skip the spec" | Then every correction becomes "that's not what I meant". The spec is the only thing you can both point at. |
| "I'll cap the questions to save time" | `grilling` has no cap and needs none: every question ships with a recommended answer, so agreeing is one word. Capping it is how the previous attempt at this skill broke. |
| "The seam gate is a formality, I know where to test" | It belongs to `to-spec`, and phases 1–3 are not yours to edit. |
| "No test needed here, it's obvious" | Then write the reason down — the report has a line for it. Obvious-to-you is not a seam. |
| "Red now, I'll fix it after the next ticket" | A red commit is not a rollback point. It is a trap for whoever rolls back to it. |
| "It failed, let me just try again" | Same attempt, same context, same failure. Diagnose or stop. |
| "Two tickets in one context is faster" | Faster for one hour. Then the model starts breaking what already worked. |

## Red Flags — restart the phase

- Code written before the spec exists.
- Two tickets sharing one subagent context.
- A ticket accepted, or left committed, on a red check.
- A finished ticket left open, or a failed one left without its blocker written down.
- Reaching past `/implement` to write the ticket's code yourself.
- Subtasks published to a shared tracker nobody was asked about.
- A retry in place of a diagnostic pass.
- Work started on a dirty tree.
- TDD skipped with no recorded reason.
- Any phase 1–3 behaviour altered by this skill.

**Violating the letter of these rules is violating their spirit.**
