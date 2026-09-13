-- S12 - Fade Out / Pause / Next Track / Fade In
-- Same fade-out fix as S4, advancing to the next track in the current
-- Spotify queue/playlist. Settings come from the shared SETTINGS cue when
-- present, falling back to the *Default properties otherwise.

use script "QLabUtilities"
use scripting additions

property maxVolumeDefault : 100
property fadeOutSecondsDefault : 5
property fadeInSecondsDefault : 5

tell application id "com.figure53.QLab.4" to tell front workspace
	try
		set maxVolume to (my getSetting("maxVolume", maxVolumeDefault)) as integer
		set fadeOutSeconds to (my getSetting("fadeOutSeconds", fadeOutSecondsDefault)) as integer
		set fadeInSeconds to (my getSetting("fadeInSeconds", fadeInSecondsDefault)) as integer

		set startVol to sound volume of application "Spotify"
		my fadeSpotifyVolume(startVol, 0, fadeOutSeconds)
		tell application "Spotify" to pause

		tell application "Spotify" to play (next track)
		my fadeSpotifyVolume(0, maxVolume, fadeInSeconds)
	on error errMsg
		display dialog "S12 (Fade Out / Pause / Next Track / Fade In) failed: " & errMsg buttons {"OK"} default button 1 with icon caution
	end try
end tell
