-- S3 - Play Playlist In Notes
-- Plays a Spotify track/playlist URI. By default reads it from the
-- triggering cue's Notes each time it fires; set the houseTrack property
-- below to override with a fixed value instead.

use script "QLabUtilities"

property houseTrack : "" -- leave blank to read from Notes; or set a Spotify URI here to always use it instead
property maxVolumeDefault : 100 -- used if no SETTINGS cue exists yet, or it doesn't define maxVolume

tell application id "com.figure53.QLab.4" to tell front workspace
	try
		set trackToPlay to houseTrack
		if trackToPlay = "" then
			set trackToPlay to notes of last item of (active cues as list)
			if trackToPlay is missing value or trackToPlay = "" then error "No track/playlist URI found - set this cue's Notes, or set the houseTrack property at the top of this script"
		end if

		set maxVolume to (my getSetting("maxVolume", maxVolumeDefault)) as integer

		tell application "Spotify"
			set sound volume to maxVolume
			play track trackToPlay
		end tell
	on error errMsg
		display dialog "S3 (Play Playlist In Notes) failed: " & errMsg buttons {"OK"} default button 1 with icon caution
	end try
end tell
