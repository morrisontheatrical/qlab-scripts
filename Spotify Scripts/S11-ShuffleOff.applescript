-- S11 - Shuffle Off

tell application id "com.figure53.QLab.4" to tell front workspace
	try
		tell application "Spotify" to set shuffling to false
	on error errMsg
		display dialog "S11 (Shuffle Off) failed: " & errMsg buttons {"OK"} default button 1 with icon caution
	end try
end tell
