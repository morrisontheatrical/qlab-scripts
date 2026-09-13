-- S14 - Toggle Shuffle
-- The original compared "shuffling enabled" (a boolean) to 0/1, which is an
-- unreliable comparison in AppleScript. Negating the boolean directly avoids
-- the type mismatch entirely.

tell application id "com.figure53.QLab.4" to tell front workspace
	try
		tell application "Spotify" to set shuffling to not shuffling enabled
	on error errMsg
		display dialog "S14 (Toggle Shuffle) failed: " & errMsg buttons {"OK"} default button 1 with icon caution
	end try
end tell
