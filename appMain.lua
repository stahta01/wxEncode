-- ----------------------------------------------------------------------------
--
--  wxEncode - guess file encoding
--
-- note that almost everywhere in this file is used the operator
-- string.len instead of #array because strings can contain
-- embedded zeros
-- ----------------------------------------------------------------------------

local trace		= require "trace"		-- shortcut for tracing
local wxWinMain	= require "wxMain"		-- GUI for the application
local samples	= require "uniBlocks"	-- create a list of Unicode blocks
				  require "extrastr"	-- extra string processor

local _floor	= math.floor
local _toChar	= string.char
local _format	= string.format
local _strrep	= string.rep
local _utf8sub	= string.utf8sub		-- extract utf8 bytes (1-4)
local _utf8lup  = string.utf8lup		-- lookup for validity
local _wordsub	= string.wordsub		-- extract words
local _fmtkilo	= string.fmtkilo		-- pretty format byte size
local _insert	= table.insert
local _concat	= table.concat

-- ----------------------------------------------------------------------------
-- binary search for the index in this special tablefor the file in memory
-- table's rows are:
-- { total sum of previous text length, line of text }
--
local function OnLookupInterval(inTable, inByteIndex)

	local iStart = 1
	local iEnd	 = #inTable
	local iIndex
	local tCurr
	local iSum
	
	while iStart <= iEnd do
		
		iIndex = _floor(iStart + (iEnd - iStart) / 2)
		
		tCurr = inTable[iIndex]
		iSum  = tCurr[1] + tCurr[2]:len()
		
		if tCurr[1] <= inByteIndex and inByteIndex < iSum then
			return iIndex
		end
		
		if iSum <= inByteIndex then iStart = iIndex + 1 else iEnd = iIndex - 1 end		
	end
	
	return -1
end

-- ----------------------------------------------------------------------------
-- find text from optional start pos
-- follow the Lua standard of indexing from 1 (0 is not a valid option)
-- if the 'no case' option is enabled this will succeed only for ASCII text
--
local function OnFindText(inText, inStartPos, inNoCase)
--	trace.line("OnFindText")

	if not inText or 0 == #inText then return -1 end
	
	-- upon getting an automatic value then
	-- shif it up a position so to retrieve 
	-- the next match
	--
	local tLines  = thisApp.tFileLines
	local iCursor = wxWinMain.GetCursorPos() + 1
	
	-- sanity check
	--
	inStartPos = inStartPos or iCursor
	if 0 > inStartPos then inStartPos = iCursor end
	if 0 > inStartPos then return -1 end

	-- get the current line from the optional position
	--
	local iLineIndex = OnLookupInterval(tLines, inStartPos)	-- get line of text	
	if 0 > iLineIndex then return -1 end
	
	inStartPos = inStartPos - tLines[iLineIndex][1]			-- normalize
	
	if inNoCase then inText = inText:upper() end			-- check for case
		
	-- the first find might be on the current line
	--
	local sLine = tLines[iLineIndex][2]
	
	if inNoCase then
		iCursor = sLine:upper():find(inText, inStartPos, true)
	else
		iCursor = sLine:find(inText, inStartPos, true)
	end
	
	-- search each line for the text
	--
	if not iCursor then
		
		for i=iLineIndex + 1, #tLines do
		
			sLine = tLines[i][2]
			
			if inNoCase then
				iCursor = sLine:upper():find(inText, 1, true)
			else
				iCursor = sLine:find(inText, 1, true)
			end
			
			if iCursor then iLineIndex = i break end
		end
	end
	
	if iCursor then
		
		-- align the cursor to the global pos
		-- within the file
		--
		iCursor = iCursor + tLines[iLineIndex][1]
		wxWinMain.SetCursorPos(iCursor)
		
		return iCursor
	end
	
	return -1
end

-- ----------------------------------------------------------------------------
-- get text from source buffer with the line starting at 
-- at inStopStart and the offset at inOffset
-- depending on the configuration will extract
-- 1 byte
-- an UTF_8 code made of 1 to 4 bytes
-- a word starting from punctuation to punctuation
-- a sequence of words stopping at the new line
--
local function OnGetTextAtPos(inStopStart, inOffset, inOption)
--	trace.line("OnGetTextAtPos")

	local iLineIndex = OnLookupInterval(thisApp.tFileLines, inStopStart)	-- get line of text	
	if 0 == iLineIndex then return 0, "Nothing in memory" end
	
	inOption = inOption or thisApp.tConfig.CopyOption						-- check for option
	
	local sSource= thisApp.tFileLines[iLineIndex][2]
	
	if "Line" == inOption then return sSource:len(), sSource end
	
	local iPosition = inOffset - inStopStart + 1							-- normalize offset
	
	if 0 < iPosition and iPosition < sSource:len() then
	
		if "Byte" == inOption then return 1, sSource:sub(iPosition, iPosition) end
		
		if "UTF_8" == inOption then

			local sCopyBuff = _utf8sub(sSource, iPosition)
			
			return sCopyBuff:len(), sCopyBuff
		end
		
		-- handle the Word selection
		--	
		local sCopyBuff = _wordsub(sSource, iPosition)
		if sCopyBuff then return sCopyBuff:len(), sCopyBuff end
	
	end

	return 0, "Error !"
end

-- ----------------------------------------------------------------------------
--
local function OnCheckEncoding()
--	trace.line("OnCheckEncoding")

	trace.lnTimeStart("Testing UTF_8 validity ...")
	
	local tCounters = {0, 0, 0, 0, 0}		-- UTF1, UTF2, UTF3, UTF4, ERRORS
	
	local iIndex 
	local chCurr
	local sLine
	local iEnd
	local iRetCode
	local tLineOut = { }
	
	-- format for each line is
	-- {offset from start of file, line of text}
	--	
	for iCurLine, tLine in ipairs(thisApp.tFileLines) do
		
		sLine = tLine[2]
		
		-- UTF_8 aware splitting
		--
		iIndex	= 1
		iEnd	= sLine:len()
		
		while iEnd >= iIndex do
		
			-- get next char, which might span from 1 byte to 4 bytes
			--
			chCurr, iRetCode = _utf8sub(sLine, iIndex)			
			_insert(tLineOut, chCurr)			
			
			-- a negative index is an error
			--
			if 0 > iRetCode then
				
				if thisApp.tConfig.Pedantic then
					trace.line(_format("Line [%4d:%2d] -> [%s]", iCurLine, iIndex, chCurr))
				end
				
				tCounters[5] = tCounters[5] + 1
				
			else
				
				tCounters[iRetCode] = tCounters[iRetCode] + 1
			end
			
			iIndex = iIndex + chCurr:len()
		end
		
		-- perform the test, old string compared to sum of tokens
		--
		local sTest = _concat(tLineOut, nil)
		if sLine ~= sTest then
			trace.line(_format("Line [%4d] fails test", iCurLine))
		end

		-- prepare for next line of text
		--
		tLineOut = { }
	end
	
	-- number of characters below 0x20 (space) should be equal to the newline counter
	--
	local sText = _format("[UTF8 1: %d] [UTF8 2: %d] [UTF8 3: %d] [UTF8 4: %d] [ERRORS: %d]", 
							tCounters[1], tCounters[2], tCounters[3], tCounters[4], tCounters[5])
	trace.line(sText)	
	
	trace.lnTimeEnd("UTF_8 test end")
	
	return true, sText
end

-- ----------------------------------------------------------------------------
--
local function OnReadSetupInf()
--	trace.line("OnReadSetupInf")

	thisApp.tConfig = dofile(thisApp.sConfigIni)
	if not thisApp.tConfig then return false end
	
	trace.line("Configuration script read")
	return true
end

-- ----------------------------------------------------------------------------
--
local function OnLoadFile()
--	trace.line("OnLoadFile")

	-- reset content
	--
	thisApp.tFileLines = { }
	thisApp.iFileBytes = 0
	
	-- refresh setup
	--
	if not OnReadSetupInf() then return 0, "Configuration file load failed." end
	
	-- get names from configuration file
	--
	local sSourceFile = thisApp.tConfig.InFile
	local sOpenMode	  = thisApp.tConfig.ReadMode
	
	local sText = _format("Loading [%s] (%s)", sSourceFile, sOpenMode)
	trace.line(sText)
		
	-- get the file's content
	--
	local  fhSrc = io.open(sSourceFile, sOpenMode)
	if not fhSrc then 
		
		sText = "Unable to open [" .. sSourceFile .. "] (" .. sOpenMode .. ")"
		trace.line(sText)
		return 0, sText
	end
	
	-- read the whole line with the end of line too
	--	
	local iCount = 0
	local tFile  = { } 
	local tLine  = {0, ""}
	
	-- add line by line, set the global bytes counter in each line
	--
	local sLine = fhSrc:read("*L")
			
	while sLine do
		
		tLine[1] = iCount					-- progressive count of bytes read so far
		tLine[2] = sLine					-- the actual line of text
		tFile[#tFile + 1] = tLine
		
		iCount = iCount + tLine[2]:len()
		tLine  = {0, ""}
		
		sLine = fhSrc:read("*L")
	end
	
	fhSrc:close()
	
	-- assign to the app
	--
	thisApp.tFileLines = tFile
	thisApp.iFileBytes = iCount
	
	-- test for utf_8 validity
	--
	if thisApp.tConfig.AutoCheck then OnCheckEncoding() end
	
	-- give feedback
	--
	sText = _format("Read [file: %s] (%s) [lines: %d] [size: %s]", 
					sSourceFile, sOpenMode, #thisApp.tFileLines, _fmtkilo(thisApp.iFileBytes))
	trace.line(sText)

	return thisApp.iFileBytes, sText
end

-- ----------------------------------------------------------------------------
--
local function OnEncode_UTF_8()
--	trace.line("OnEncode_UTF_8")

	local iLimit = thisApp.iFileBytes
	if 0 >= iLimit then return 0, "Nothing in memory" end
	
	trace.lnTimeStart("Encoding memory as UTF_8")	
	
	local tFile = thisApp.tFileLines
	local sLine
	local iIndex
	local iEnd
	local ch
	local iNumSet = 0
	local tCurrLine = { }
	local tLinesSeq = { }
	local iCountPrev= 0				-- addition of line by line length
	
	-- process char by char
	--
	for _, tLine in ipairs(tFile) do
		
		sLine	= tLine[2]
		iIndex	= 1
		iEnd	= sLine:len()
		
		while iEnd >= iIndex do
	
			ch = sLine:byte(iIndex)
		
			if tUtf8Code[1][1] <= ch and tUtf8Code[1][2] >= ch then
			
				-- first 127 bytes are std ascii
				--
				
			elseif tUtf8Code[3][1] <= ch and tUtf8Code[3][2] >= ch then	
				
				-- ASCII extended #2
				--			
				_insert(tCurrLine, _toChar(tUtf8Code[3][3]))
				
				ch = 0x80 + (ch - tUtf8Code[3][1])

				iNumSet = iNumSet + 1				
				
			elseif tUtf8Code[2][1] <= ch and tUtf8Code[2][2] >= ch then	
				
				-- ASCII extended #1
				--
				_insert(tCurrLine, _toChar(tUtf8Code[2][3]))
					
				ch = 0x80 + (ch - tUtf8Code[2][1])

				iNumSet = iNumSet + 1			

			end
		
			-- write the char
			--
			_insert(tCurrLine, _toChar(ch))
			
			iIndex = iIndex + 1
		end
		
		sLine = _concat(tCurrLine, nil)
		_insert(tLinesSeq, {iCountPrev, sLine})
		
		iCountPrev = iCountPrev + sLine:len()
		tCurrLine  = { }
	end
	
	-- swap buffers
	--
	thisApp.tFileLines = tLinesSeq
	thisApp.iFileBytes = iCountPrev
	
	trace.lnTimeEnd("Encoding conversion")

	local sText = _format("Memory encoded UTF_8 with %d conversions", iNumSet)
	trace.line(sText)	
	
	return iIndex, sText
end

-- ----------------------------------------------------------------------------
--
local function OnSaveFile()
--	trace.line("OnSaveFile")
	
	if 0 == thisApp.iFileBytes then return 0, "Nothing in memory" end
	
	local sTargetFile = thisApp.tConfig.OutFile
	local sOpenMode	  = thisApp.tConfig.WriteMode
	
	-- open outut file
	--
	local fhTgt = io.open(sTargetFile, sOpenMode)
	if not fhTgt then return 0, "Unable to open output file" end
	
	for _, tLine in ipairs(thisApp.tFileLines) do		
		fhTgt:write(tLine[2])
	end

	fhTgt:close()

	local sText = "File saved in [" .. sTargetFile .. "] (" .. sOpenMode .. ")"
	trace.line(sText)	
	
	return thisApp.iFileBytes, sText
end

-- ----------------------------------------------------------------------------
--
local function OnCreateByBlock()
--	trace.line("OnCreateByBlock")

	local sTargetFile = thisApp.tConfig.SamplesFile
	local sOpenMode	  = "a+"
	local tBlocks	  = thisApp.tConfig.ByBlocksRow
	
	if not tBlocks then return false end
		
	-- remove the file and allow the application to
	-- open the file in append mode so to handle
	-- properly n calls to createbyblock
	--
	if not os.remove(thisApp.tConfig.SamplesFile) then
		trace.line("Failed to remove old file ...")	
--		return false
	end
	
	trace.lnTimeStart("Creating samples file ...")		
		
	-- scan the table, each row is a table itself
	-- where the first element is enable flag
	-- and the second element is a generic label
	--
	local iAlignAt = thisApp.tConfig.AlignByCols
	local bCompact = thisApp.tConfig.OnlyGroups
	
	for iRow, iBlock in ipairs(thisApp.tConfig.ByBlocksRow) do

		if iBlock[1] then
			
--			local sLine = _format("Sampling row: [%3d] title: [%s]", iRow, iBlock[2])
--			trace.line(sLine)			
			
			if not samples.ByBlock(iRow, iBlock[2], sTargetFile, sOpenMode, iAlignAt, bCompact) then
				
				trace.lnTimeEnd("Create samples interrupted, quitting...")
				break
			end		
		end		
	end			

	trace.lnTimeEnd("Create samples end")
	
	return true
end

-- ----------------------------------------------------------------------------
-- check for memory usage and call a collector walk
-- a megabyte measure is used instead of kilos to reduce
-- the trace messaging using a gross unit of measure
--
local function OnGarbageTest()
--	trace.line("OnGarbageTest")

	local iKilo = collectgarbage("count")
	local iMega = _floor(iKilo / 1024)
	
	if thisApp.iGarbageCount ~= iMega then
		
		if iMega > thisApp.iGarbageCount  then
			
--			collectgarbage("step", 4)
			collectgarbage("collect")
		end

		-- store for later
		--
		thisApp.iGarbageCount = iMega
		
		if thisApp.tConfig.TraceMemory then

			local sLine = _format("Memory: [%3d Mb] %s", iMega, _strrep("•", iMega))
			trace.line(sLine)
		end
	end
end

-- ----------------------------------------------------------------------------
-- preamble
--
local function SetUpApplication()
--	trace.line("SetUpApplication")

	collectgarbage("generational")

	trace.line(thisApp.sAppName .. " (Ver. " .. thisApp.sAppVersion .. ")")
	trace.line("Released: " .. thisApp.sAppRelDate)	
	trace.line("_VERSION: " .. _VERSION)

	assert(thisApp.sChkVer == _VERSION, "Error: " .. thisApp.sChkVer .. " required")
	
	assert(os.setlocale('ita', 'all'))
	trace.line("Current locale is [" .. os.setlocale() .. "]")
	
	samples.Init()

	if not OnReadSetupInf() then return false end
	
	return true
end

-- ----------------------------------------------------------------------------
-- leave clean
--
local function QuitApplication()
--	trace.line("QuitApplication")

	-- call the close (shall be not necessary)
	--
	wxWinMain.CloseWindow()
	
	trace.line(thisApp.sAppName .. " terminated")
end

-- ----------------------------------------------------------------------------
--
local function main()
  
	-- redirect logging
	--
	io.output(thisApp.sLogFilename)

	if SetUpApplication() then 
		
		if thisApp.tConfig.AutoLoad then OnLoadFile() end
		
		wxWinMain.ShowWindow()
	end

	-- we'll get here only when the main window loop closes
	--
	QuitApplication()

	io.output():close()
end

-- ----------------------------------------------------------------------------
--
thisApp =
{
	sAppVersion		= "0.0.6",				-- application's version
	sAppRelDate		= "9-dec-18",			-- date of release update
	sAppName		= "wxEncode",			-- name for the application
	sChkVer			= "Lua 5.2",			-- Lua's version required
	sIconFile		= "wxEncode.ico",		-- icon for the application
	sLogFilename	= "wxEncode.log",		-- logging filename
	
	sConfigIni		= "appConfig.lua",		-- filename for the config
	tConfig			= { },					-- configuration for the app.
	iGarbageCount	= 0,					-- last memory check value

	tFileLines		= { },					-- line by line memory file
	iFileBytes		= 0,					-- sum of all bytes in tFileLines

	ReadSetupInf	= OnReadSetupInf,		-- read the setupinf.lua file
	LoadFile		= OnLoadFile,			-- load the file in memory
	SaveFile		= OnSaveFile,			-- save memory to file
	CheckEncoding	= OnCheckEncoding,		-- check chars in current file
	Encode_UTF_8	= OnEncode_UTF_8,		-- save the current file UTF_8
	CreateByBlock	= OnCreateByBlock,		-- crate samples of characters
	LookupInterval	= OnLookupInterval,		-- test find the row of index
	GetTextAtPos	= OnGetTextAtPos,		-- get text at pos (see setupinf.lua)
	FindText		= OnFindText,			-- find text within the file
	GarbageTest		= OnGarbageTest,		-- test memory and call collect
}

-- ----------------------------------------------------------------------------
-- run it
--
main()

-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------