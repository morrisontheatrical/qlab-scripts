-- S12 - Fade Out / Pause / Next Track / Fade In
-- Same fade-out fix as S4, but advances to the next track in the current
-- Spotify queue/playlist rather than a track named in cue Notes.

property maxVolume : 100
property fadeOutSeconds : 5
property fadeInSeconds : 5

tell application id "com.figure53.QLab.4" to tell front workspace
	try
		set startVol to sound volume of application "Spotify"
		my fadeSpotifyVolume(startVol, 0, fadeOutSeconds)
		tell application "Spotify" to pause

		tell application "Spotify" to play (next track)
		my fadeSpotifyVolume(0, maxVolume, fadeInSeconds)
	on error errMsg
		display dialog "S12 (Fade Out / Pause / Next Track / Fade In) failed: " & errMsg buttons {"OK"} default button 1 with icon caution
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
