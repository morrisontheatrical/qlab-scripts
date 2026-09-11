tell application id "com.figure53.QLab.4" to tell front workspace
	tell application "Spotify"
		set sound volume to 100
		play (next track)
	end tell
end tell