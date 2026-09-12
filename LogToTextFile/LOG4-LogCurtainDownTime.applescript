-- LOG4 - Log Curtain Down Time (Act 2 / End of show)
-- See LOG1 for how this system works.

property mycue : "LOG4"
property themessage : "Curtain Down Act 2"
property writeCue : "WRITE"

tell application id "com.figure53.QLab.4" to tell front workspace
	try
		set notes of cue mycue to (do shell script "date +%s") as integer
		set thedate to current date
		set this_data to (thedate as string) & space & themessage & return
		set notes of cue writeCue to this_data
		start cue writeCue
	on error errMsg
		display dialog "LOG4 failed: " & errMsg buttons {"OK"} default button 1 with icon caution
	end try
end tell
