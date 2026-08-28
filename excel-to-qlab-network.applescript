-- Reference the Excel application
tell application "Microsoft Excel"
	-- Reference the workbook and worksheet
	set workbookName to "sheet4.csv"
	set worksheetName to "netCues" -- Change to your worksheet name
	
	-- Open the workbook
	set theWorkbook to workbook workbookName
	set theWorksheet to sheet worksheetName of theWorkbook
	
	-- Get the used range
	set usedRange to used range of theWorksheet
	
	-- Get the number of rows in the used range
	set rowCount to count rows of usedRange
	
	-- Iterate over each row in the used range
	repeat with i from 1 to rowCount
		-- Get the values from columns A and B
		set cueNumber to value of cell ("I" & i) of theWorksheet
		set cueNumber to cueNumber as integer
		set cueName to value of cell ("C" & i) of theWorksheet
		set oscCommand to "/eos/cue/" & cueNumber & "/fire"
		set Notes1 to value of cell ("J" & i) of theWorksheet
		set Notes2 to value of cell ("K" & i) of theWorksheet
		set NotesA to Notes1 & return & Notes2
		
		
		
		-- Create a new OSC cue in QLab
		tell application "QLab"
			tell front workspace
				-- Create the OSC cue
				make type "Network"
				set theselectedcue to last item of (selected as list)
				
				-- Optionally set the cue number
				set q name of theselectedcue to cueName
				set custom message of theselectedcue to oscCommand
				set notes of theselectedcue to NotesA
				set q color of theselectedcue to "Orange"
				
			end tell
		end tell
	end repeat
end tell
