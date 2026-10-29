# Pulse

A small Mac menu bar app that shows how much of my Claude and Codex plans I've used, so I can see at a glance which one has room left.

Each provider gets a card with two bars: the 5-hour limit and the weekly limit, plus when the week resets.

## How it works

Pulse doesn't track anything itself. It asks [Hearth](https://github.com/gdcruz0911/hearth), my personal agent workbench, by running `hearth usage --json` and drawing what comes back.

Hearth reads the numbers from logs Claude Code and Codex already write, and it uses the same numbers to stop starting work on a plan that's nearly used up. Pulse is just the gauge you can see without opening anything.

## Run it

Needs macOS 15 and a working Hearth install.

```bash
swift run
```

Pulse appears in the menu bar. Press ⌘R in the panel to refresh and ⌘Q to quit.

## Where it's going

- Show "not tracked yet" instead of 0% when there's no data.
- Show when each number was last updated, not when Pulse last asked.
- Refresh on its own.
- Mark the 90% line where Hearth stops starting new work.
- Notify me when a plan resets, so unused limits don't go to waste.
- Open at login.

This is also how I'm learning Swift and SwiftUI, so it stays small on purpose.
