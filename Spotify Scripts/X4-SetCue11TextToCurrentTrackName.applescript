tell application id "com.figure53.QLab.4" to tell front workspace
	set thecue to cue "11"
	tell application "Spotify"
		
		set trackname to name of current track
	end tell
	set text of thecue to trackname
end tell