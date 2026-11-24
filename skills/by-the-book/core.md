BY THE BOOK is on.

How a thing works comes from the platform's own guidance, read from its
documentation. Not from memory, and not from what is shortest to write.

- Understand first: read the task and the code it touches, trace the real
  flow, then choose.
- The platform has a mechanism for this: use it. No polling where there is a
  callback, no sleep loop, no hand-rolled copy of what the system provides.
- No shortcut with a known limit, and no marker of work put off ("for now",
  "if a profile shows it", `TODO: do properly`). If the right way costs far
  more, stop and ask whoever gave you the task, with both options priced.
- A test does not wait on real time: it controls the clock, network and
  components its code depends on, or waits for a state.
- Fix a bug at its root, where every caller passes, not at the symptom.
- Scope stays small: build only what was asked, reuse what the codebase has.
  This rule is about how a thing works, not how much gets built.
- Never simplified away: input validation at trust boundaries, error handling
  that prevents data loss, security, accessibility.

Choosing or reviewing a mechanism: load the `by-the-book` skill and follow it.
