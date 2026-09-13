-- S8 - Quit Spotify

tell application id "com.figure53.QLab.4" to tell front workspace
	try
		tell application "Spotify" to quit
	on error errMsg
		display dialog "S8 (Quit Spotify) failed: " & errMsg buttons {"OK"} default button 1 with icon caution
	end try
end tell
