-- WRITE - Write To Log File
-- Appends the text stored in this cue's Notes field to a running text file on
-- the Desktop. Triggered by every other LOG*/duration cue in this system;
-- not normally run directly.

property mycue : "WRITE"
property logFileName : "SHOW LOGGER.txt" -- change here if you want a different file name

tell application id "com.figure53.QLab.4" to tell front workspace
	set target_file to ((path to desktop folder) as string) & logFileName
	try
		set this_data to (notes of cue mycue) & return
		set the open_target_file to open for access file target_file with write permission
		write this_data to the open_target_file starting at eof
		close access the open_target_file
	on error errMsg
		try
			close access file target_file
		end try
		display dialog "WRITE cue failed to log to " & target_file & ": " & errMsg buttons {"OK"} default button 1 with icon caution
	end try
end tell
