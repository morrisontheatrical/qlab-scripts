# Spotify Scripts

QLab 4 Script cues that control Spotify for pre-show/house music, intermission
music, and playlist-driven scene underscoring, plus a couple of experiments
for on-screen "now playing" display and crossfading.

## Core playback cues

| Cue | Script File | Purpose |
|---|---|---|
| S1 | S1-OpenSpotify.applescript | Launch Spotify, return focus to QLab |
| S2 | S2-PlayResumeSpotify.applescript | Set volume to ceiling, play/resume |
| S3 | S3-PlayPlaylistInNotes.applescript | Play the track/playlist URI in this cue's Notes |
| S4 | S4-FadeOut-Pause-PlaylistNotes-FadeIn.applescript | Fade out, pause, play Notes URI, fade in |
| S5 | S5-FadePauseSpotify.applescript | Fade out and pause (no next track) |
| S6 | S6-ResumeFadeUp.applescript | Resume playback and fade up |
| S7 | S7-ResumeNextTrack.applescript | Hard cut to next track at full volume |
| S8 | S8-QuitSpotify.applescript | Quit Spotify |
| S9 | S9-SetPlayheadToNotes.applescript | Seek to a position (seconds) from this cue's Notes |
| S10 | S10-ShuffleOn.applescript | Turn shuffle on |
| S11 | S11-ShuffleOff.applescript | Turn shuffle off |
| S12 | S12-FadeOut-Pause-NextTrack-FadeIn.applescript | Fade out, pause, next track, fade in |
| S13 | S13-FadeOut-Pause-NextTrack.applescript | Fade out, pause, next track, hard cut back in |
| S14 | S14-ToggleShuffle.applescript | Toggle shuffle on/off |

## Experimental / in-progress cues

| Cue | Script File | Status |
|---|---|---|
| X1 | X1-PostWaitFadeTime-Test.applescript | Working test of driving fade duration from the cue's own Post Wait field instead of a hardcoded number — not yet adopted into the S-series scripts |
| X2 | X2-Crossfade-Test.applescript | Working — computes time-to-crossfade once and does a single `delay` rather than polling; see the design note in the file for the resilience/resource tradeoff this implies |
| X3 | X3-SetCue12TargetToURL.applescript | Working (pending verification) — downloads current track's album art and sets it as a Video cue's media file; the exact QLab property name used (`file target`) needs confirming against your QLab version |
| X4 | X4-SetCue11TextToCurrentTrackName.applescript | Working — writes the current track name into a Text cue |

## Shared settings ("SETTINGS" cue)

`S2`, `S3`, `S4`, `S5`, `S6`, `S7`, `S12`, `S13`, and `X2` read `maxVolume`,
`fadeOutSeconds`, `fadeInSeconds`, and (for `X2`) `crossfadeLeadSeconds` from
a memo cue named **`SETTINGS`**, if one exists in the workspace, instead of
each having its own hardcoded value. This means you can change house volume
or fade timing show-wide by editing one cue's Notes rather than every script.

Add a memo cue named `SETTINGS` with Notes formatted as `key=value` pairs
separated by `;`, e.g.:

```
maxVolume=100;fadeOutSeconds=5;fadeInSeconds=5;crossfadeLeadSeconds=5
```

If the `SETTINGS` cue doesn't exist yet (e.g. a workspace you haven't set
this up in), every script falls back to its own `*Default` property at the
top of the file, so nothing breaks — you just don't get show-wide control
until you add the cue.

This requires the shared library described below.

## Shared library (QLabUtilities)

`getSetting` (reads the `SETTINGS` cue above) and `fadeSpotifyVolume` (the
volume ramp used by every fade script) now live in one file,
`Shared Library/QLabUtilities.applescript`, instead of being pasted into
every script that needs them. See that file's header comment for one-time
install instructions (compile it in Script Editor, save into
`~/Library/Script Libraries/`). Each script that uses it starts with
`use script "QLabUtilities"`.

**This hasn't been tested against a live QLab instance** — please verify
`use script` resolves correctly from inside a QLab Script cue before relying
on it in a show. The library file's header comment includes a fallback
(`load script` with a hardcoded path) if it doesn't.

## Setup for a new show

1. Install the shared library once per machine (see "Shared library" above)
   if it isn't already installed.
2. Copy the S-series cues you need into a dedicated cue list (e.g. "House
   Music"), keeping each script's cue number as referenced by the others
   (`S3`/`S4`/`S9` read the *triggering* cue's own Notes, so those can live on
   any cue number — it's `X4`'s `targetCueNumber` property that needs to
   match a real Text cue in your show).
3. Add a `SETTINGS` memo cue (see "Shared settings" above) if you want
   show-wide control over volume/fade timing; otherwise each script uses its
   own `*Default` property.
4. `S3`, `S4`, `S9`, `S12`, `S13` expect specific Notes content:
   - `S3`/`S4`: a Spotify track or playlist URI (e.g.
     `spotify:playlist:37i9dQZF1F0sijgNaJdgit`) — or leave Notes blank and
     set the `houseTrack` property instead to always use a fixed value
   - `S9`: a plain number of seconds (e.g. `30`)

## Design notes

- Spotify's `sound volume` is an **application-wide** setting, not per-track
  or per-cue — if two of these scripts could ever run at the same time (a
  double-triggered cue, an accidental double-press), they'll fight over the
  same value. Not an issue in normal single-threaded use, but worth keeping
  in mind if you build anything that could overlap these cues.
- All the fade scripts now share one `fadeSpotifyVolume` handler from the
  `QLabUtilities` library instead of each having its own copy.

## Known limitations

- Requires Spotify to already be running (or reachable via
  activate/AppleScript) and an active track/queue — an empty player state
  (e.g. nothing has ever been played this session) will surface as a dialog
  rather than fail silently, but won't recover on its own.
- No protection against two fade cues firing back-to-back or concurrently
  (see Design notes above).
- If the `QLabUtilities` library isn't installed on a machine, any script
  starting with `use script "QLabUtilities"` will fail to compile/run —
  install it first (see "Shared library" above).

## Changes from the original version

- **Fixed the fade-out bug in S4, S5, S12, S13.** The original fade-out loop
  always jumped volume up to 100 on its first step, then ramped down —
  regardless of what the volume actually was when the cue fired. All four
  scripts now read the real current volume first and fade from there.
- Added `try`/`on error` with a `display dialog` alert to every script — the
  originals had no error handling at all, meaning a missing Notes value, a
  closed Spotify app, or no current track would throw an uncaught error
  mid-cue.
- Added guard checks for missing/blank Notes values in `S3`, `S4`, `S9`.
- Fixed `S14`'s shuffle toggle: it compared a boolean (`shuffling enabled`)
  to `0`/`1`, which is an unreliable comparison in AppleScript — now uses
  `not shuffling enabled` directly. `S10`/`S11` were updated to use
  `true`/`false` for consistency with this.
- Pulled `maxVolume`, `fadeOutSeconds`, `fadeInSeconds`, and (for `X4`)
  `targetCueNumber` into `property` declarations at the top of each script —
  addresses the `--to do: add memo cue for max volume variable` note that
  was in the original `S2`.
- Consolidated the fade-out/fade-in math into one `fadeSpotifyVolume`
  handler, reused across `S4`, `S5`, `S6`, `S12`, `S13` — the original had
  three slightly different hand-rolled versions of this loop with different
  step sizes and hardcoded delays.
- **Finished X2 (crossfade).** Replaced the incomplete/broken conditional
  with a working version: it reads the track's total duration and current
  position once, computes how long until the crossfade should start, and
  does a single `delay` for that long rather than polling in a loop (lighter
  on resources, at the cost of not adapting if the track is manually
  paused/skipped/scrubbed during the wait — see the design note in the file).
  `crossfadeTarget` is a property, defaulting to `"next track"`, that can be
  swapped to a specific track/playlist URI.
- **Finished X3 (album art).** It previously downloaded the artwork but
  never applied it anywhere; it now sets it as the media file on the Video
  cue named by the `targetCueNumber` property. Also replaced the hardcoded
  `/Users/seth/Downloads/` path with `path to downloads folder`, so it works
  on any machine/user account, and added shell-quoting around the artwork
  URL for safety.
- **Introduced the shared `SETTINGS` cue and `QLabUtilities` library.**
  `maxVolume`, `fadeOutSeconds`, `fadeInSeconds`, and `crossfadeLeadSeconds`
  are now read from one shared memo cue instead of being hardcoded per
  script, and the `getSetting`/`fadeSpotifyVolume` handlers live in one
  library file instead of being duplicated across S4/S5/S6/S12/S13/X2. See
  "Shared settings" and "Shared library" above.
- `X1` intentionally left as-is — it's a working proof of concept, not yet
  adopted into the main S-series scripts.
