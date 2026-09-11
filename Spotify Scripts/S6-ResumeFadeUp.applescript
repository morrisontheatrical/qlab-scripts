tell application id "com.figure53.QLab.4" to tell front workspace
	tell application "Spotify"
		play
		set currentvolume to the sound volume
		repeat with i from currentvolume to 100 by 2
			set the sound volume to i
			delay 0.1
		end repeat
	end tell
end tell