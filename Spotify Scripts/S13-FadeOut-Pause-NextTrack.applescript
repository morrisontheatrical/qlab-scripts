tell application id "com.figure53.QLab.4" to tell front workspace
	
	set houseTrack to notes of last item of (active cues as list)
	
	
	tell application "Spotify"
		set fadetime to 5
		repeat with volumeset from 0 to 100 as integer
			set sound volume to 100 - volumeset
			delay fadetime / 100
		end repeat
		pause
		
		
		--set houseTrack to notes of currentCue as string
		
		
		
		
		play (next track)
		set sound volume to 100
		
	end tell
	
	
end tell