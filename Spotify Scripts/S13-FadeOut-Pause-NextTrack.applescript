-- S13 - Fade Out / Pause / Next Track
-- Same fade-out fix as S4/S12, but snaps straight back to maxVolume on the
-- next track instead of fading in - unlike S12, which fades in gradually.
-- Kept this hard-cut-in behavior since it was in the original; confirm this
-- distinction from S12 is intentional for your use case.

property maxVolume : 100
property fadeOutSeconds : 5

tell application id "com.figure53.QLab.4" to tell front workspace
	try
		set startVol to sound volume of application "Spotify"
		my fadeSpotifyVolume(startVol, 0, fadeOutSeconds)
		tell application "Spotify" to pause

		tell application "Spotify"
			play (next track)
			set sound volume to maxVolume
		end tell
	on error errMsg
		display dialog "S13 (Fade Out / Pause / Next Track) failed: " & errMsg buttons {"OK"} default button 1 with icon caution
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
