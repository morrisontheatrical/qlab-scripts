-- S2 - Play/Resume Spotify
-- Sets volume to the shared "maxVolume" setting (see the SETTINGS cue in the
-- repo README) and resumes/plays.

use script "QLabUtilities"

property maxVolumeDefault : 100 -- used if no SETTINGS cue exists yet, or it doesn't define maxVolume

tell application id "com.figure53.QLab.4" to tell front workspace
	try
		set maxVolume to (my getSetting("maxVolume", maxVolumeDefault)) as integer
		tell application "Spotify"
			set sound volume to maxVolume
			play
		end tell
	on error errMsg
		display dialog "S2 (Play/Resume Spotify) failed: " & errMsg buttons {"OK"} default button 1 with icon caution
	end try
end tell
