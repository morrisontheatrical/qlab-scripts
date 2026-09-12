-- LOG1 - Log Curtain Up Time
-- Fires at top of show. Stores this moment's Unix epoch (seconds) in this cue's
-- own Notes field for later duration math, then hands a dated line to WRITE.

property mycue : "LOG1"
property themessage : "Curtain Up"
property writeCue : "WRITE"

tell application id "com.figure53.QLab.4" to tell front workspace
	try
		set notes of cue mycue to (do shell script "date +%s") as integer
		set thedate to current date
		set this_data to (thedate as string) & space & themessage & return
		set notes of cue writeCue to this_data
		start cue writeCue
	on error errMsg
		display dialog "LOG1 failed: " & errMsg buttons {"OK"} default button 1 with icon caution
	end try
end tell
