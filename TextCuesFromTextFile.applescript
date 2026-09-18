tell application "QLab"
	tell front workspace
		-- Select the RTF or text file
		set fileToRead to choose file with prompt "Select your file:"
		set posixPath to POSIX path of fileToRead
		
		-- Convert RTF formatting into clean plain UTF-8 text using native macOS textutil
		set cleanText to do shell script "textutil -convert txt -stdout " & quoted form of posixPath
		set lineList to paragraphs of cleanText
		
		-- Loop through lines and create Text cues
		repeat with currentLine in lineList
			set currentText to currentLine as text
			if length of currentText > 0 then
				make type "Text"
				set newCue to last item of (selected as list)
				set text of newCue to currentText
				set q name of newCue to currentText
			end if
		end repeat
	end tell
end tell