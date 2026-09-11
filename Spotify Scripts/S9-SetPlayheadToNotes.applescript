tell application id "com.figure53.QLab.4" to tell front workspace
	
	-- notes: "30" sets track playhead to 30s
	set setpos to notes of last item of (active cues as list)
	
	tell application "Spotify"
		
		set player position to setpos
	end tell
	
end tell