--==============================================================================
-- Function: parseDelimitedString( valueString (string), separator (string) )
-- Author:Jaddua Ross
-- Modified:03/31/11
-- Returns:A table of strings
-- Descript:parseDelimitedString takes two arguments, some kind of a delimited string and the separator.
-- The function then splits the delimited string into substrings and puts them into an indexed table
-- which it then returns.
--==============================================================================
function parseDelimitedString( valueString, separator )

    separator = separator or ","                    -- separator defaults to comma
    if valueString == "" then                       -- error check to make sure a string is passed
        print ("Error - no string passed.")
        return {}
    else
        valueString = string.gsub(valueString, " ", " ") --removes any white space from string
        local returnTable = {}                      -- initializes table
        local returnIndex = 1                       -- initializes returnIndex

        --returns the position of the beginning of the separator and the end of the separator and stores it in these variables
        --we don't really care about the position of the end since we know the length of the separator
        local separatorBegin, separatorEnd = string.find(valueString, separator)

        if separatorEnd == nil then                 -- error case if function could not find at least one instance of separator in the string
            print("Error - could not find separator in string")
        else
            wordBegin = 1                           -- once the white space is stripped off, the first word begins with the first character of the string
                                                    -- up to the space before the first instance of the separator
            repeat
                wordEnd = separatorBegin - 1        -- find the end of the word (one space behind the beginning of the next separator)

                -- and make a new entry in the table. the entry is the sub- string of the main string beginning at the beginning of the word
                -- (1 the first time and then set below for the next word) and the word end (set above)
                returnTable[returnIndex] = string.sub(valueString, wordBegin, wordEnd)
                --look for the next instance of the separator and store it in these variables, replacing the last set.  We don't really care about
                --separatorEnd because we know the length of the separator already.
                separatorBegin, separatorEnd = string.find(valueString, separator, (wordEnd + string.len(separator) + 1))
                wordBegin = wordEnd + string.len(separator) + 1  -- the position of the beginning of the next word is the position of the end of this one
                                                                 -- plus the length of the separator, plus 1
                returnIndex = returnIndex + 1
            until separatorBegin == nil              --until string.find returns no more instances of the separator in the string
            returnTable[returnIndex]=string.sub(valueString, wordBegin, #valueString)
        end
    return returnTable
    end
end

--==============================================================================
-- Function: readCSVFile(fileName)
-- Author: Jaddua Ross
-- Modified: 04/07/2011
-- Returns: An indexed table with strings for each line of data in the file.
-- Descript: This function opens a file and reads its contents into an indexed table line by line as strings, and returns
-- the table.
--==============================================================================
function readCSVFile( fileName )

    local fileLines = io.lines( fileName )  -- reads file into variable
    local fileTable = {}

    if fileLines == nil then
        print ("Error in readCSVFile - file was empty.")  --if file is empty, return error
        return nil
    else
        local lineNumber = 1
        for line in fileLines do                          --otherwise go through table line by line and store each line as
            fileTable[lineNumber] = line                  --an entry in an indexed table
            lineNumber = lineNumber + 1
        end
    return fileTable
    end
end


--==============================================================================
-- Function: loadCSVData (fileName)
-- Author: Jaddua Ross
-- Modified: 04/07/2011
-- Returns: An indexed table of subtables.
-- Descript: loadCSVData takes a filename.  It then calls readCSVFile on the filename and uses the ParseDelimited String function
-- to parse the data into a table of tables indexed by line with keyed entries for the data.
--==============================================================================
function loadCSVData( fileName )
    if fileName == nil then
        print ("Error in load CSVData - no file was passed")  -- if no file name is passed, return an error
    else
        if string.sub( fileName, -4, -4) ~= "." then     -- if no extension, signified by the 4th character from the end being a period,
            fileName = fileName..".csv"                  -- append .csv to the filename
        end
        local checkFile, errorMsg = io.open(fileName, "r")  --attempt to open the file, and if there is an error opening it, return an
        if errorMsg ~= nil then                             --error and quit out
            print ("Error - loadCSVData - could not find file.")
        else
            checkFile:close()                               --close the file
            local readTable = readCSVFile(fileName)         --calls the readCSVFile function, which returns the data from the file as a table
            local outputTable = {}                          --indexed by line
            local indexTable = parseDelimitedString(readTable[1])  --calls the parseDelimitedString function on the first line of the file, which 
                                                                   --should contain the names of the key entries for the remaining lines as an indexed
                                                                   --table.  The names are stored for use below.
            for i = 2, #readTable do                               --from the second line until the end of the file, read each line and parse it 
                                                                   --with parseDelimitedString.  The table that is returned is stored temporarily in 
                                                                   --holdTable
                local holdTable = parseDelimitedString(readTable[i])
                local tempTable = {}
                for a = 1, #holdTable do                           --within each line, step through the table entry by entry.  If the entry is a number
                                                                   --convert it to a number.
                    if tonumber(holdTable[a]) ~= nil then          --either way, the entry in the table becomes the entry in a new table, and the 
                                                                   --corresponding entry from the index table becomes the key
                        tempTable[indexTable[a]] = tonumber(holdTable[a])
                    else
                        tempTable[indexTable[a]] = holdTable[a]
                    end
                end
                outputTable[(i - 1)] = tempTable                   --as each line is completed, return the table that is created as an indexed entry
                                                                   --to the table that will ultimately be returned
            end
            return outputTable

        end
    end
end

function serializeTable(val, name, skipnewlines, depth)
    skipnewlines = skipnewlines or false
    depth = depth or 0

    local tmp = string.rep(" ", depth)

    if name then tmp = tmp .. name .. " = " end

    if type(val) == "table" then
        tmp = tmp .. "{" .. (not skipnewlines and "\n" or "")

        for k, v in pairs(val) do
            tmp =  tmp .. serializeTable(v, k, skipnewlines, depth + 1) .. "," .. (not skipnewlines and "\n" or "")
        end

        tmp = tmp .. string.rep(" ", depth) .. "}"
    elseif type(val) == "number" then
        tmp = tmp .. tostring(val)
    elseif type(val) == "string" then
        tmp = tmp .. string.format("%q", val)
    elseif type(val) == "boolean" then
        tmp = tmp .. (val and "true" or "false")
    else
        tmp = tmp .. "\"[inserializeable datatype:" .. type(val) .. "]\""
    end

    return tmp
end