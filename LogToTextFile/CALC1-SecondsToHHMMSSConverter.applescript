-- CALC1 - Seconds to HH:MM:SS Converter
-- Utility cue: converts a whole-second duration stored in this cue's own Notes
-- field into an "HH:MM:SS" string, written back into this cue's Notes.
--
-- NOTE: as of this revision, LOGA/LOGB/LOGI/LOGP/LOGR each do this conversion
-- inline and no longer call this cue - that removes the old race condition
-- where they used "start cue CALC1" + a fixed 0.2s delay and hoped it was
-- enough time. This cue is kept only as an optional standalone/manual utility;
-- it is not required for the rest of the logging system to work.

property mycue : "CALC1"

tell application id "com.figure53.QLab.4" to tell front workspace
	try
		set thesecs to notes of cue mycue
		if thesecs is missing value or thesecs = "" then error "No seconds value found in notes of cue " & mycue
		set notes of cue mycue to my secondsToHMS(thesecs as integer)
	on error errMsg
		display dialog "CALC1 failed: " & errMsg buttons {"OK"} default button 1 with icon caution
	end try
end tell

on secondsToHMS(theSeconds)
	set isNegative to theSeconds < 0
	if isNegative then set theSeconds to -theSeconds
	set theHours to theSeconds div 3600
	set theMinutes to (theSeconds mod 3600) div 60
	set theSecs to theSeconds mod 60
	set theResult to (my padTwo(theHours)) & ":" & (my padTwo(theMinutes)) & ":" & (my padTwo(theSecs))
	if isNegative then set theResult to "-" & theResult
	return theResult
end secondsToHMS

on padTwo(n)
	set n to n as text
	if length of n < 2 then set n to "0" & n
	return n
end padTwo
