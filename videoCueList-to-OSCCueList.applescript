tell application id "com.figure53.QLab.4" to tell front workspace
	
	
	-- Define the names of the cue lists
	set videoCueListName to "Projection Video Cues"
	set oscCueListName to "OSC Projection Cues"
	
	-- Get the cue lists
	set videoCueList to first cue list whose q name is videoCueListName
	set oscCueList to first cue list whose q name is oscCueListName
	
	-- Get the cues from the video cue list
	set videoCues to cues of videoCueList
	set cueCounter to 1
	
	-- Loop through each cue in the video cue list
	repeat with videoCue in videoCues
		
		-- Rename the cue
		set cueNumber to cueCounter as string
		set newName to "V-" & cueNumber
		set q number of videoCue to newName
		set videocuetitle to q name of videoCue
		
		set oscCommand to "/cue/" & newName & "/go"
		
		-- Create a network cue in the OSC cue list
		--tell oscCueList
		make type "Network"
		set theselectedcue to last item of (selected as list)
		
		-- Optionally set the cue number
		set q name of theselectedcue to videocuetitle
		set custom message of theselectedcue to oscCommand
		--set notes of theselectedcue to NotesA
		set q color of theselectedcue to "Purple"
		set q number of theselectedcue to "P-" & cueNumber
		-- Customize the network address, port, and message according to your needs
		--end tell
		
		-- Increment the cue counter
		set cueCounter to cueCounter + 1
	end repeat
	
	
	
	
end tell
