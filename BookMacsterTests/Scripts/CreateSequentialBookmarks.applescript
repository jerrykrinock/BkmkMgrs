-- Creates 10,000 bookmarks in BookMacster with sequential names and URLs
-- Bookmark names: "Bkmk0000" through "Bkmk9999"
-- URLs: "https://example.com/0000" through "https://example.com/9999"

-- Helper function to pad numbers with leading zeros
on padZeros(theNumber, totalDigits)
	set theString to theNumber as string
	set zerosNeeded to totalDigits - (length of theString)
	repeat zerosNeeded times
		set theString to "0" & theString
	end repeat
	return theString
end padZeros

-- Main script
tell application "BookMacster"
	activate
	
	-- Get the front document
	if (count of documents) is 0 then
		display dialog "Please open a BookMacster document first." buttons {"OK"} default button 1
		return
	end if
	
	set theDoc to front document
	
	-- Disable undo registration to prevent memory bloat during batch operations
	tell theDoc
		disable undo registration
	end tell
	
	-- Create 10,000 bookmarks
	repeat with i from 1 to 10000
		set paddedNumber to my padZeros(i, 4)
		set bookmarkName to "Bkmk" & paddedNumber
		set bookmarkURL to "https://example.com/" & paddedNumber
		
		-- Create the bookmark
		tell theDoc
			land new bookmark name bookmarkName url bookmarkURL with show inspector override
		end tell
		
		-- Progress indicator every 1000 bookmarks
		if (i mod 1000) is 0 then
			log "Created " & i & " bookmarks..."
		end if
	end repeat
	
	-- Re-enable undo registration
	tell theDoc
		enable undo registration
	end tell
	
	display dialog "Successfully created 10,000 bookmarks!" buttons {"OK"} default button 1
end tell
