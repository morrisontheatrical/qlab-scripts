-- QLabUtilities.applescript
-- Shared handlers used by multiple QLab script cues in this repo.
--
-- INSTALLATION (do this once per machine):
-- 1. Open this file in Script Editor.
-- 2. File > Export... > File Format: "Script" > save as "QLabUtilities.scpt"
--    into ~/Library/Script Libraries/ (create that folder if it doesn't
--    already exist).
-- 3. In any QLab script cue that wants these handlers, add
--        use script "QLabUtilities"
--    as the very first line (before any tell blocks), then call handlers as
--    "my getSetting(...)", "my fadeSpotifyVolume(...)".
--
-- NOTE: "use script" hasn't been tested against a live QLab instance from
-- inside a Script cue - please verify it resolves correctly before relying
-- on it in a show. If it doesn't, the fallback is
--   set utils to load script (POSIX file "/full/path/to/QLabUtilities.scpt")
-- and call handlers as "tell utils to getSetting(...)" instead of "my ...".

on getSetting(keyName, defaultValue)
	-- Reads "key=value" pairs, separated by ";", from the Notes of a memo
	-- cue named "SETTINGS" in the front QLab workspace. Example Notes value:
	--   maxVolume=100;fadeOutSeconds=5;fadeInSeconds=5;crossfadeLeadSeconds=5
	-- Returns defaultValue unchanged if the SETTINGS cue doesn't exist, its
	-- Notes are empty, or keyName isn't found in it - so a workspace with no
	-- SETTINGS cue at all still works using each script's own fallback.
	try
		tell application id "com.figure53.QLab.4" to tell front workspace
			set settingsText to notes of cue "SETTINGS"
		end tell
		if settingsText is missing value or settingsText = "" then return defaultValue

		set oldDelims to AppleScript's text item delimiters
		set AppleScript's text item delimiters to ";"
		set pairs to text items of settingsText
		set AppleScript's text item delimiters to oldDelims

		repeat with aPair in pairs
			set oldDelims to AppleScript's text item delimiters
			set AppleScript's text item delimiters to "="
			set parts to text items of aPair
			set AppleScript's text item delimiters to oldDelims
			if (count of parts) = 2 and (item 1 of parts) = keyName then
				return (item 2 of parts)
			end if
		end repeat
	on error
		-- SETTINGS cue missing, or something else went wrong reading it -
		-- fall through to the default rather than failing the caller.
	end try
	return defaultValue
end getSetting

on fadeSpotifyVolume(startLevel, endLevel, durationSeconds)
	-- Ramps Spotify's sound volume from startLevel to endLevel over
	-- durationSeconds, one integer step at a time. Always pass the ACTUAL
	-- current volume as startLevel (e.g. "sound volume of application
	-- \"Spotify\"") rather than a hardcoded number, so the fade never jumps.
	if startLevel = endLevel then return
	if endLevel > startLevel then
		set stepCount to endLevel - startLevel
	else
		set stepCount to startLevel - endLevel
	end if
	set stepDelay to durationSeconds / stepCount
	tell application "Spotify"
		if endLevel > startLevel then
			repeat with v from startLevel to endLevel
				set sound volume to v
				delay stepDelay
			end repeat
		else
			repeat with v from startLevel to endLevel by -1
				set sound volume to v
				delay stepDelay
			end repeat
		end if
	end tell
end fadeSpotifyVolume
