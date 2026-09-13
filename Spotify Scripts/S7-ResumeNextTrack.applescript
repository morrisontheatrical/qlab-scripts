-- S7 - Resume Next Track
-- Hard cut (no fade) to full volume and the next track.

property maxVolume : 100

tell application id "com.figure53.QLab.4" to tell front workspace
	try
		tell application "Spotify"
			set sound volume to maxVolume
			play (next track)
		end tell
	on error errMsg
		display dialog "S7 (Resume Next Track) failed: " & errMsg buttons {"OK"} default button 1 with icon caution
	end try
end tell
