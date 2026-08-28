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
	
	--global lastVid1
	set lastVid1 to "V-1.2"
	--global lastVid2
	set lastVid2 to "V-1.1"
	
	-- Loop through each cue in the video cue list
	repeat with videoCue in videoCues
		
		
		set VidCueId to uniqueID of videoCue
		
		-- Renumber Cue
		set vidcueNumber to q number of videoCue
		set subvidnum to vidcueNumber & ".1"
		set q number of videoCue to subvidnum
		--set theselectedcue to subvidnum of (selected as number)
		
		set playback position of videoCueList to videoCue
		--moveSelectionUp
		
		-- Make Group
		make type "Group"
		
		set groupcue to last item of (selected as list)
		set mode of groupcue to timeline
		set q number of groupcue to q name of videoCue
		set groupList to parent of groupcue
		move cue id VidCueId of groupList to end of groupcue
		set q name of groupcue to q name of cue id VidCueId
		
		-- Make Fade In & Out Cues
		make type "Fade"
		set fadeincue to last item of (selected as list)
		set FinCueId to uniqueID of fadeincue
		set q number of fadeincue to vidcueNumber & ".2"
		set q name of fadeincue to "Fade In"
		set do opacity of cue id FinCueId to true
		set q color of fadeincue to "Green"
		move cue id FinCueId of groupList to end of groupcue
		
		
		make type "Fade"
		set fadeoutcue to last item of (selected as list)
		set FoutCueId to uniqueID of fadeoutcue
		set q number of fadeoutcue to vidcueNumber & ".3"
		--set q name of fadeoutcue to "Fade Out"
		set do opacity of cue id FoutCueId to true
		set opacity of cue id FoutCueId to "0"
		set stop target when done of fadeoutcue to true
		set q color of fadeoutcue to "Red"
		move cue id FoutCueId of groupList to end of groupcue
		
		-- Upadate Last Video Cue Tracker
		
		
		
		set q number of groupcue to vidcueNumber
		set cue target of fadeincue to cue subvidnum
		
		if cueCounter ≤ 2 then
			--
		else
			set fadeouttarget to "V-" & cueCounter - 1 & ".1"
			set cue target of fadeoutcue to cue fadeouttarget
			set lastVid2 to lastVid1
		end if
		set lastVid1 to cue subvidnum
		-- Increment the cue counter
		set cueCounter to cueCounter + 1
	end repeat
	
end tell
