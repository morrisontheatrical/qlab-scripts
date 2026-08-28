tell application id "com.figure53.QLab.4" to tell front workspace
	
	set activeCues to active cues
	
	-- Loop through each active cue
	repeat with aCue in activeCues
		-- Check if the cue is a video cue
		if class of aCue is video cue then
			-- Set the opacity of the video cue to 0%
			set opacity of aCue to 100
		end if
	end repeat
	
	
end tell
