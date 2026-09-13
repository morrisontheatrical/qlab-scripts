-- S4 - Fade Out / Pause / Play Playlist In Notes / Fade In
-- Fades Spotify out from its ACTUAL current volume, pauses, plays a
-- track/playlist URI, then fades back in. maxVolume/fadeOutSeconds/
-- fadeInSeconds come from the shared SETTINGS cue when present, falling
-- back to the *Default properties below otherwise. Track/playlist URI still
-- comes from this cue's Notes, or the houseTrack property override.

use script "QLabUtilities"
use scripting additions

property houseTrack : "" -- leave blank to read from Notes; or set a Spotify URI here to always use it instead
property maxVolumeDefault : 100
property fadeOutSecondsDefault : 5
property fadeInSecondsDefault : 5

tell application id "com.figure53.QLab.4" to tell front workspace
	try
		set trackToPlay to houseTrack
		if trackToPlay = "" then
			set trackToPlay to notes of last item of (active cues as list)
			if trackToPlay is missing value or trackToPlay = "" then error "No track/playlist URI found - set this cue's Notes, or set the houseTrack property at the top of this script"
		end if

		set maxVolume to (my getSetting("maxVolume", maxVolumeDefault)) as integer
		set fadeOutSeconds to (my getSetting("fadeOutSeconds", fadeOutSecondsDefault)) as integer
		set fadeInSeconds to (my getSetting("fadeInSeconds", fadeInSecondsDefault)) as integer

		set startVol to sound volume of application "Spotify"
		my fadeSpotifyVolume(startVol, 0, fadeOutSeconds)
		tell application "Spotify" to pause

		tell application "Spotify" to play track trackToPlay
		my fadeSpotifyVolume(0, maxVolume, fadeInSeconds)
	on error errMsg
		display dialog "S4 (Fade Out / Pause / Play Notes / Fade In) failed: " & errMsg buttons {"OK"} default button 1 with icon caution
	end try
end tell
