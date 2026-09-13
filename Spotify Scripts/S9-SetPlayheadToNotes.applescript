-- S9 - Set Playhead To Notes
-- Seeks Spotify to a position in the current track. By default reads the
-- position (in seconds, e.g. "30") from the triggering cue's Notes each time
-- it fires; set the setpos property below to override with a fixed value.

property setpos : "" -- leave blank to read from Notes; or set a number of seconds here to always seek there

tell application id "com.figure53.QLab.4" to tell front workspace
	try
		set targetPos to setpos
		if targetPos = "" then
			set targetPos to notes of last item of (active cues as list)
			if targetPos is missing value or targetPos = "" then error "No playhead position found - set this cue's Notes, or set the setpos property at the top of this script"
		end if
		tell application "Spotify" to set player position to (targetPos as number)
	on error errMsg
		display dialog "S9 (Set Playhead To Notes) failed: " & errMsg buttons {"OK"} default button 1 with icon caution
	end try
end tell
