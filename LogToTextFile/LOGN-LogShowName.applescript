-- LOGN - Log Show Name
-- Writes a header line to the log marking the start of a new performance/session.
--
-- FLAGGED FOR REVIEW: the original script read "q number of front document".
-- "q number" is a CUE property (a cue's number/tag), not a normal property of a
-- workspace/document object, so this line may error or return something other
-- than what was intended. Swapped below to "name of front document", which is
-- more likely to give you the actual show file name - but please test this cue
-- on its own before relying on it, since it wasn't possible to verify against a
-- live QLab instance.

property writeCue : "WRITE"

tell application id "com.figure53.QLab.4" to tell front workspace
	try
		set showLabel to name of front document -- <-- verify this returns what you expect
		set themessage to "----------------------------------------------------------------------" & return & "SHOW FILE: " & showLabel & return
		set notes of cue writeCue to themessage
		start cue writeCue
	on error errMsg
		display dialog "LOGN failed: " & errMsg buttons {"OK"} default button 1 with icon caution
	end try
end tell
