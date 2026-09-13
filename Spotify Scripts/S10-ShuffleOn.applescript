-- S10 - Shuffle On
-- Uses true/false rather than 1/0 - "shuffling" is a boolean property in
-- Spotify's AppleScript dictionary (see S14 for why this matters more there).

tell application id "com.figure53.QLab.4" to tell front workspace
	try
		tell application "Spotify" to set shuffling to true
	on error errMsg
		display dialog "S10 (Shuffle On) failed: " & errMsg buttons {"OK"} default button 1 with icon caution
	end try
end tell
