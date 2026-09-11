tell application id "com.figure53.QLab.4" to tell front workspace
	
	set houseTrack to notes of last item of (active cues as list)
	
	tell application "Spotify"
		
		set sound volume to 100
		
		--set houseTrack to "spotify:playlist:37i9dQZF1F0sijgNaJdgit?si=93219bbef59649c5"
		
		play track houseTrack
		
	end tell
	
	
end tell