tell application id "com.figure53.QLab.4" to tell front workspace
	set thecue to cue "12"
	tell application "Spotify"
		
		set artpath to artwork url of current track
	end tell
	set destination to "/Users/seth/Downloads/"
	do shell script "curl -L " & artpath & " -o " & POSIX path of the destination
end tell