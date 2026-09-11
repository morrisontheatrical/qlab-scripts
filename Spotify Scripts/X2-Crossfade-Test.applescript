tell application id "com.figure53.QLab.4" to tell front workspace
	
	tell application "Spotify"
		if player state = "playing" then
			if player position ³ (duration - 3) then
			end if
		end if
	end tell
end tell