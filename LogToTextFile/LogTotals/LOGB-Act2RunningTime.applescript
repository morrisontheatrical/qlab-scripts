-- LOGB - Act 2 Running Time
-- Computes elapsed time between LOG3 (curtain up act 2) and LOG4 (curtain down).
-- See LOGA for full notes on how this pattern works.

property mycue : "LOGB"
property startLogCue : "LOG3"
property endLogCue : "LOG4"
property writeCue : "WRITE"
property labelWidth : 50

tell application id "com.figure53.QLab.4" to tell front workspace
	try
		set startTime to notes of cue startLogCue
		set endTime to notes of cue endLogCue
		if startTime is missing value or startTime = "" or endTime is missing value or endTime = "" then
			error "Missing timestamp(s) - have " & startLogCue & " and " & endLogCue & " both fired yet?"
		end if

		set mystring to q name of cue mycue
		repeat while (length of mystring) < labelWidth
			set mystring to " " & mystring
		end repeat

		set thesecs to (endTime as integer) - (startTime as integer)
		set notes of cue mycue to my secondsToHMS(thesecs)
		set notes of cue writeCue to return & mystring & ": " & (notes of cue mycue) & return
		start cue writeCue
	on error errMsg
		display dialog "LOGB failed: " & errMsg buttons {"OK"} default button 1 with icon caution
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
