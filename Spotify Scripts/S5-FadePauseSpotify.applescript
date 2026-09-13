-- S5 - Fade + Pause Spotify
-- Fades out from the actual current volume and pauses. fadeOutSeconds comes
-- from the shared SETTINGS cue when present, falling back to
-- fadeOutSecondsDefault otherwise.

use script "QLabUtilities"

property fadeOutSecondsDefault : 5

tell application id "com.figure53.QLab.4" to tell front workspace
	try
		set fadeOutSeconds to (my getSetting("fadeOutSeconds", fadeOutSecondsDefault)) as integer
		set startVol to sound volume of application "Spotify"
		my fadeSpotifyVolume(startVol, 0, fadeOutSeconds)
		tell application "Spotify" to pause
	on error errMsg
		display dialog "S5 (Fade + Pause Spotify) failed: " & errMsg buttons {"OK"} default button 1 with icon caution
	end try
end tell
