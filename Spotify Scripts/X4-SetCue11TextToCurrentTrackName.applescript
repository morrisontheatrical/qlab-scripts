-- X4 - Set Cue Text To Current Track Name
-- Writes the currently-playing Spotify track name into a Text cue, for
-- on-screen display (e.g. a lobby/projection display of "now playing").

property targetCueNumber : "11" -- cue number of the Text cue to update

tell application id "com.figure53.QLab.4" to tell front workspace
	try
		set thecue to cue targetCueNumber
		tell application "Spotify" to set trackname to name of current track
		set text of thecue to trackname
	on error errMsg
		display dialog "X4 (Set Cue Text To Track Name) failed: " & errMsg buttons {"OK"} default button 1 with icon caution
	end try
end tell
