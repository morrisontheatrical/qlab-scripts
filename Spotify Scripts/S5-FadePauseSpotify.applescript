tell application id "com.figure53.QLab.4" to tell front workspace
	set fadetime to 5
	tell application "Spotify"
		repeat with volumeset from 0 to 100 as integer
			set sound volume to 100 - volumeset
			delay fadetime / 100
		end repeat
		pause
	end tell
	
end tell