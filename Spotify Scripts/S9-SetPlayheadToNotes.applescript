-- S9 - Set Playhead To Notes
-- Notes on the triggering cue should be a number of seconds, e.g. "30" sets
-- the track playhead to 30s.

tell application id "com.figure53.QLab.4" to tell front workspace
	try
		set setpos to notes of last item of (active cues as list)
		if setpos is missing value or setpos = "" then error "No playhead position found in this cue's Notes"
		tell application "Spotify" to set player position to (setpos as number)
	on error errMsg
		display dialog "S9 (Set Playhead To Notes) failed: " & errMsg buttons {"OK"} default button 1 with icon caution
	end try
end tell
