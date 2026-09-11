tell application id "com.figure53.QLab.4" to tell front workspace
	
	set houseTrack to notes of last item of (active cues as list)
	--"spotify:playlist:3ac7KKFi3O1pnBzVPtj7SB?si=e65e05c230a94490"
	
	tell application "Spotify"
		set fadetime to 5
		repeat with volumeset from 0 to 100 as integer
			set sound volume to 100 - volumeset
			delay fadetime / 100
		end repeat
		pause
		
		
		--set houseTrack to notes of currentCue as string
		
		
		
		
		play (next track)
		set currentvolume to the sound volume
		repeat with i from currentvolume to 100 by 2
			set the sound volume to i
			delay 0.1
		end repeat
		
	end tell
	
	
end tell