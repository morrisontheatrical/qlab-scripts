-- S6 - Resume + Fade Up
-- Resumes playback and fades up to maxVolume from the actual current volume.
-- (This one already read the real current volume in the original version -
-- it's the pattern the other fade scripts have been brought in line with.)

property maxVolume : 100
property fadeInSeconds : 5

tell application id "com.figure53.QLab.4" to tell front workspace
	try
		tell application "Spotify" to play
		set startVol to sound volume of application "Spotify"
		my fadeSpotifyVolume(startVol, maxVolume, fadeInSeconds)
	on error errMsg
		display dialog "S6 (Resume + Fade Up) failed: " & errMsg buttons {"OK"} default button 1 with icon caution
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
