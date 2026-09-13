-- S6 - Resume + Fade Up
-- Resumes playback and fades up to maxVolume from the actual current
-- volume. maxVolume/fadeInSeconds come from the shared SETTINGS cue when
-- present, falling back to the *Default properties otherwise.

use script "QLabUtilities"

property maxVolumeDefault : 100
property fadeInSecondsDefault : 5

tell application id "com.figure53.QLab.4" to tell front workspace
	try
		set maxVolume to (my getSetting("maxVolume", maxVolumeDefault)) as integer
		set fadeInSeconds to (my getSetting("fadeInSeconds", fadeInSecondsDefault)) as integer
		tell application "Spotify" to play
		set startVol to sound volume of application "Spotify"
		my fadeSpotifyVolume(startVol, maxVolume, fadeInSeconds)
	on error errMsg
		display dialog "S6 (Resume + Fade Up) failed: " & errMsg buttons {"OK"} default button 1 with icon caution
	end try
end tell
