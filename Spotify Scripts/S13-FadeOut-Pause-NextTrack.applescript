-- S13 - Fade Out / Pause / Next Track
-- Same fade-out fix as S4/S12, but snaps straight back to maxVolume on the
-- next track instead of fading in - unlike S12. fadeOutSeconds/maxVolume
-- come from the shared SETTINGS cue when present, falling back to the
-- *Default properties otherwise.

use script "QLabUtilities"
use scripting additions

property maxVolumeDefault : 100
property fadeOutSecondsDefault : 5

tell application id "com.figure53.QLab.4" to tell front workspace
	try
		set maxVolume to (my getSetting("maxVolume", maxVolumeDefault)) as integer
		set fadeOutSeconds to (my getSetting("fadeOutSeconds", fadeOutSecondsDefault)) as integer

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
