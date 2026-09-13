-- S2 - Play/Resume Spotify
-- Sets volume to the house ceiling and resumes/plays.

property maxVolume : 100 -- ceiling for house music playback volume

tell application id "com.figure53.QLab.4" to tell front workspace
	try
		tell application "Spotify"
			set sound volume to maxVolume
			play
		end tell
	on error errMsg
		display dialog "S2 (Play/Resume Spotify) failed: " & errMsg buttons {"OK"} default button 1 with icon caution
	end try
end tell
