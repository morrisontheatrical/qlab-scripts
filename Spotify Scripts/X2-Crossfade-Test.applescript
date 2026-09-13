-- X2 - Crossfade Near Track End
-- Waits until shortly before the current track ends, then fades out,
-- changes track, and fades back in. All timing/volume settings come from
-- the shared SETTINGS cue when present, falling back to the *Default
-- properties otherwise.
--
-- DESIGN NOTE: this computes the wait time ONCE up front (trackDuration
-- minus current position minus crossfadeLeadSeconds) and does a single
-- `delay`, rather than polling player position in a loop - much lighter on
-- resources, but if someone manually pauses/skips/scrubs the track while
-- this cue is waiting, the crossfade will still fire at the
-- originally-calculated moment. Let me know if you'd rather have a polling
-- version that re-checks position periodically instead.
--
-- IMPORTANT: uncheck "This cue needs to complete before continuing" on this
-- cue in QLab's inspector (Basics tab) - otherwise the cue list will be
-- blocked for the entire wait.

use script "QLabUtilities"

property crossfadeTarget : "next track" -- special value "next track", or a Spotify track/playlist URI to crossfade into
property crossfadeLeadSecondsDefault : 5
property fadeOutSecondsDefault : 5
property fadeInSecondsDefault : 5
property maxVolumeDefault : 100

tell application id "com.figure53.QLab.4" to tell front workspace
	try
		set crossfadeLeadSeconds to (my getSetting("crossfadeLeadSeconds", crossfadeLeadSecondsDefault)) as integer
		set fadeOutSeconds to (my getSetting("fadeOutSeconds", fadeOutSecondsDefault)) as integer
		set fadeInSeconds to (my getSetting("fadeInSeconds", fadeInSecondsDefault)) as integer
		set maxVolume to (my getSetting("maxVolume", maxVolumeDefault)) as integer

		tell application "Spotify"
			if player state is not playing then error "Spotify is not currently playing - nothing to crossfade"
			set trackDurationMs to duration of current track
			set trackPosition to player position
		end tell

		-- Spotify reports track duration in milliseconds but player position in seconds
		set secondsRemaining to (trackDurationMs / 1000) - trackPosition
		set waitSeconds to secondsRemaining - crossfadeLeadSeconds
		if waitSeconds > 0 then delay waitSeconds

		set startVol to sound volume of application "Spotify"
		my fadeSpotifyVolume(startVol, 0, fadeOutSeconds)
		tell application "Spotify" to pause

		if crossfadeTarget = "next track" then
			tell application "Spotify" to play (next track)
		else
			tell application "Spotify" to play track crossfadeTarget
		end if
		my fadeSpotifyVolume(0, maxVolume, fadeInSeconds)
	on error errMsg
		display dialog "X2 (Crossfade Near Track End) failed: " & errMsg buttons {"OK"} default button 1 with icon caution
	end try
end tell
