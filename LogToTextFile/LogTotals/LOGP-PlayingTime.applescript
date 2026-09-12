-- LOGP - Playing Time (Act 1 + Act 2, excluding interval)
-- Unlike LOGA/LOGB/LOGI/LOGR, this one sums two separate durations rather than
-- subtracting a single pair of timestamps, so it reads all four LOG cues directly.

property mycue : "LOGP"
property writeCue : "WRITE"
property labelWidth : 50

tell application id "com.figure53.QLab.4" to tell front workspace
	try
		set t1 to notes of cue "LOG1"
		set t2 to notes of cue "LOG2"
		set t3 to notes of cue "LOG3"
		set t4 to notes of cue "LOG4"
		if t1 is missing value or t1 = "" or t2 is missing value or t2 = "" or t3 is missing value or t3 = "" or t4 is missing value or t4 = "" then
			error "Missing timestamp(s) - have LOG1 through LOG4 all fired yet?"
		end if

		set mystring to q name of cue mycue
		repeat while (length of mystring) < labelWidth
			set mystring to " " & mystring
		end repeat

		set thesecs to ((t2 as integer) - (t1 as integer)) + ((t4 as integer) - (t3 as integer))
		set notes of cue mycue to my secondsToHMS(thesecs)
		set notes of cue writeCue to return & mystring & ": " & (notes of cue mycue) & return
		start cue writeCue
	on error errMsg
		display dialog "LOGP failed: " & errMsg buttons {"OK"} default button 1 with icon caution
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
