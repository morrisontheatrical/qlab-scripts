-- S3 - Play Playlist In Notes
-- Reads a Spotify track/playlist URI from the triggering cue's Notes field and
-- plays it. Example Notes value: spotify:playlist:37i9dQZF1F0sijgNaJdgit

property maxVolume : 100

tell application id "com.figure53.QLab.4" to tell front workspace
	try
		set houseTrack to notes of last item of (active cues as list)
		if houseTrack is missing value or houseTrack = "" then error "No track/playlist URI found in this cue's Notes"

		tell application "Spotify"
			set sound volume to maxVolume
			play track houseTrack
		end tell
	on error errMsg
		display dialog "S3 (Play Playlist In Notes) failed: " & errMsg buttons {"OK"} default button 1 with icon caution
	end try
end tell
