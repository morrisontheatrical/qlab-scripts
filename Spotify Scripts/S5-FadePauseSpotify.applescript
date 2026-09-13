-- S5 - Fade + Pause Spotify
-- Fades out from the actual current volume (see S4's header note on the fix)
-- and pauses. Does not start anything new afterward.

property fadeOutSeconds : 5

tell application id "com.figure53.QLab.4" to tell front workspace
	try
		set startVol to sound volume of application "Spotify"
		my fadeSpotifyVolume(startVol, 0, fadeOutSeconds)
		tell application "Spotify" to pause
	on error errMsg
		display dialog "S5 (Fade + Pause Spotify) failed: " & errMsg buttons {"OK"} default button 1 with icon caution
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
