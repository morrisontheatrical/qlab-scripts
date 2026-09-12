# LogToTextFile

Automated show-timing logger for QLab 4. Captures curtain up/down times for a
two-act show and appends a running log of key event timestamps and computed
durations to a text file on the Desktop.

## What it does

For a two-act show, this system logs:

- Curtain Up (Act 1)
- Curtain Down (Act 1)
- Curtain Up (Act 2)
- Curtain Down (Act 2)

...and computes/reports:

- Act 1 running time
- Act 2 running time
- Interval length
- Playing time (Act 1 + Act 2 combined, excluding interval)
- Total running time (curtain up to final curtain down)

Every log line is appended to a single text file, `SHOW LOGGER.txt`, on the
Desktop — so the file accumulates a record across every run in the workspace's
lifetime, with an optional per-performance header cue to mark where each one
starts.

## Required cues

| Cue Number | Script File | Purpose |
|---|---|---|
| LOG1 | LOG1-LogCurtainUpTime.applescript | Logs curtain up, Act 1 |
| LOG2 | LOG2-LogCurtainDownAct1Time.applescript | Logs curtain down, Act 1 |
| LOG3 | LOG3-LogCurtainUpAct2Time.applescript | Logs curtain up, Act 2 |
| LOG4 | LOG4-LogCurtainDownTime.applescript | Logs curtain down, Act 2 |
| LOGA | LOGA-Act1RunningTime.applescript | Act 1 running time (LOG2 − LOG1) |
| LOGB | LOGB-Act2RunningTime.applescript | Act 2 running time (LOG4 − LOG3) |
| LOGI | LOGI-IntervalLength.applescript | Interval length (LOG3 − LOG2) |
| LOGP | LOGP-PlayingTime.applescript | Total playing time, excluding interval |
| LOGR | LOGR-RunningTime.applescript | Full running time (LOG4 − LOG1) |
| LOGN | LOGN-LogShowName.applescript | Header line marking a new performance |
| WRITE | WRITE-WriteToLogFile.applescript | Shared utility — appends text to the log file |
| CALC1 | CALC1-SecondsToHHMMSSConverter.applescript | Optional standalone utility (no longer required — see Changes below) |

All twelve must be **Script cues in the same workspace**, each named with the
exact cue number shown above (`LOG1`, `LOG2`, etc.) — the scripts look each
other up by cue number, so a mismatch, or a duplicate cue number elsewhere in
the show, will break the chain.

## Setup for a new show

1. Copy all cues above into a dedicated cue list (e.g. "Show Logger") in the
   new workspace, keeping the cue numbers exactly as listed.
2. Trigger `LOG1`–`LOG4` from wherever curtain up/down actually happens in
   your show — a GO in your main cue list can target one of these via a
   follow/network target, or hotkey them for manual triggering from the booth.
3. Trigger `LOGA`, `LOGB`, `LOGI`, `LOGP`, `LOGR` whenever you want a
   running-time report, typically right after `LOG4` fires.
4. Trigger `LOGN` once, before `LOG1`, if you want a header marking the start
   of each new performance in the shared log file.
5. Run a test and confirm `SHOW LOGGER.txt` appears on the Desktop with the
   formatting you expect.

## How it works

- Each `LOG1`–`LOG4` cue stores a Unix epoch timestamp (whole seconds) in
  *its own* Notes field, then hands a formatted line to `WRITE`'s Notes field
  and triggers `WRITE` to append it to the file.
- Each duration-reporting cue (`LOGA`/`LOGB`/`LOGI`/`LOGP`/`LOGR`) reads the
  relevant `LOG` cues' timestamps, subtracts (or sums) them, converts the
  result to `HH:MM:SS` inline, and hands the formatted line to `WRITE` the
  same way.
- Because every cue in this system re-purposes its own Notes field as scratch
  storage, don't use these cues' Notes fields for documentation — use the
  `-- comment` block at the top of each script for that instead.

## Known limitations

- **Single shared log file.** All runs accumulate into one
  `SHOW LOGGER.txt`. If you need a fresh file per production, edit the
  `logFileName` property at the top of `WRITE-WriteToLogFile.applescript`
  before tech, or archive/rename the old file between productions.
- **No file rotation.** The log will grow indefinitely across a long run —
  worth archiving it periodically.
- **Requires accurate triggering.** `LOG1`–`LOG4` must fire at the actual
  moment curtain moves. Any delay between the real event and the cue firing
  shows up directly in every derived duration.
- **Out-of-order firing.** If cues fire out of the expected order, the
  revised scripts report a negative duration (prefixed with `-`) rather than
  a bogus positive number — still worth investigating if you see one.

## Changes from the original version

- Added `try`/`on error` with a `display dialog` alert to every script, so a
  broken cue reference or missing timestamp surfaces immediately during tech
  instead of silently producing a blank log line.
- Removed the `start cue "CALC1"` + `delay 0.2` pattern from
  `LOGA`/`LOGB`/`LOGI`/`LOGP`/`LOGR`. The original asynchronously started
  `CALC1` and hoped it finished converting seconds to `HH:MM:SS` within 200ms
  before reading its Notes back — under system load this could silently
  produce a stale or wrong result. The conversion now happens inline in each
  script.
- Added guard checks for missing/blank timestamps (e.g. running a duration
  report before all relevant `LOG` cues have fired) — you now get a dialog
  instead of a silent no-op.
- Negative durations (from out-of-order cue firing) are now reported with a
  `-` sign instead of producing garbage from `div`/`mod` on a negative number.
- Pulled cue numbers, messages, and file names into `property` declarations
  at the top of each script, so they can be edited without hunting through
  the body.
- Fixed `WRITE`'s dead `append_data` flag (hardcoded `true`, never toggled —
  removed) and added a `.txt` extension to the log filename.
- Flagged a likely issue in `LOGN`: the original read `q number of front
  document` — `q number` is a cue property, not a document property, so this
  may not have worked as intended. Swapped to `name of front document`, but
  **please test this cue on its own** before relying on it; it wasn't
  possible to verify against a live QLab instance.
- `CALC1` is kept for optional manual/ad hoc use, but no other cue in this
  system depends on it anymore.
