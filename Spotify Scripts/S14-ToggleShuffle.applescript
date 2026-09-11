tell application id "com.figure53.QLab.4" to tell front workspace
	tell application "Spotify"
		
		if shuffling enabled = 0 then
			set shuffling to 1
			
		end if
		if shuffling enabled = 1 then
			set shuffling to 0
		end if
		
	end tell
end tell