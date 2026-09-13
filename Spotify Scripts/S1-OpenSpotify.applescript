-- S1 - Open Spotify
-- Launches Spotify, then returns focus to QLab so the operator's keyboard
-- shortcuts / GO button stay working.

tell application id "com.figure53.QLab.4" to tell front workspace
	try
		tell application "Spotify" to activate
		tell application "QLab" to activate
	on error errMsg
		display dialog "S1 (Open Spotify) failed: " & errMsg buttons {"OK"} default button 1 with icon caution
	end try
end tell
