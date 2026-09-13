-- S4 - Fade Out / Pause / Play Playlist In Notes / Fade In
-- Fades Spotify out from its ACTUAL current volume (not a hardcoded 100),
-- pauses, plays the track/playlist URI from the triggering cue's Notes, then
-- fades back in to maxVolume.
--
-- NOTE ON THE FIX: the original version faded out with
--   repeat with volumeset from 0 to 100
--       set sound volume to 100 - volumeset
-- which always jumps volume to 100 on the very first loop iteration before
-- ramping down - audible as an unwanted jump if the real volume wasn't
-- already 100 when this cue fired. This version reads the real starting
-- volume first and fades from there.

property maxVolume : 100
property fadeOutSeconds : 5
property fadeInSeconds : 5

tell application id "com.figure53.QLab.4" to tell front workspace
	try
		set houseTrack to notes of last item of (active cues as list)
		if houseTrack is missing value or houseTrack = "" then error "No track/playlist URI found in this cue's Notes"

		set startVol to sound volume of application "Spotify"
		my fadeSpotifyVolume(startVol, 0, fadeOutSeconds)
		tell application "Spotify" to pause

		tell application "Spotify" to play track houseTrack
		my fadeSpotifyVolume(0, maxVolume, fadeInSeconds)
	on error errMsg
		display dialog "S4 (Fade Out / Pause / Play Notes / Fade In) failed: " & errMsg buttons {"OK"} default button 1 with icon caution
	end try
end tell

on fadeSpotifyVolume(startLevel, endLevel, durationSeconds)
	if startLevel = endLevel then return
	if endLevel > startLevel then
		set stepCount to endLevel - startLevel
	else
		set stepCount to startLevel - endLevel
	end if
	set stepDelay to durationSeconds / stepCount
	tell application "Spotify"
		if endLevel > startLevel then
			repeat with v from startLevel to endLevel
				set sound volume to v
				delay stepDelay
			end repeat
		else
			repeat with v from startLevel to endLevel by -1
				set sound volume to v
				delay stepDelay
			end repeat
		end if
	end tell
end fadeSpotifyVolume
