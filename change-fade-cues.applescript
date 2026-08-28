tell application id "com.figure53.QLab.4" to tell front workspace
	
	set activeCues to active cues
	set fadeout to cue "V-000"
	set fadein to cue "V-100"
	
	-- Loop through each active cue
	repeat with aCue in activeCues
		-- Check if the cue is a video cue
		if class of aCue is video cue then
			set cue target of fadeout to aCue
			set cue target of fadein to aCue
			
			
			
		end if
	end repeat
	
	
end tell
