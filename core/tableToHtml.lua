--[[
* The MIT License
* Copyright (C) 2014 Bacioiu "Zapa" Ciprian (bacioiu.ciprian@gmail.com).  All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining
* a copy of this software and associated documentation files (the
* "Software"), to deal in the Software without restriction, including
* without limitation the rights to use, copy, modify, merge, publish,
* distribute, sublicense, and/or sell copies of the Software, and to
* permit persons to whom th be Software is furnished to do so, subject to
* the following conditions:
*
* The above copyright notice and this permission notice shall be
* included in all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
* MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
* IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
* CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
* TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
* SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
--]]

htmParser = {}

--- Outputs a LUA table into a HTML file
-- @public function htmParser:init() - initialised the parser with the default styles. 
-- @public function htmParser:setBorderWidth( _arg ) - sets the border wide of the Table Element to _arg's value
-- @public function htmParser:setCellPadding( _arg ) - sets the cell padding of the Table Element to _arg's value
-- @public function htmParser:setCellSpacing( _arg ) - sets the cell spacing of the Table Element to _arg's value
-- @public function htmParser:setStyleParams( _arg1, _arg2, _arg3 ) - set's the background to the user
-- 		specified background picture, the color of the Daddy Row's text and the color for the child row text.
-- 		if no background is specified, it will use the default media/background.png image. Both color 
-- 		arguments are needed
-- @public function htmParser:setCategoryColor( _arg ) - set's the color for the Daddy Row. Color value = 1 - > 4 to
--		match the table of colors created in self:init( )
-- @public function htmParser:dumpToHTML(_table, _file) - exports the <_table> and creates a <_file> in which it stores
--		it. 
-- @public function htmParser:dumpSparseToHTML(_table, _file, _sizeX, _sizeY) - exports a SPARSE (X*Y) table to a <_file>.
--		_sizeX and _sizeY specifies the width and height of the table. -- WORK IN PROGRESS! Maybe contribute to it? :D

function htmParser:init( )
	self._table = {}
	self._border = 1
	self._cellpadding = 1
	self._cellspacing = 1
	self._styleString = ""

	self._color = {}
	self._color[1] = "#FF0000"
	self._color[2] = "#013ADF"
	self._color[3] = "#0174DF"
	self._color[4] = "#3ADF00"

	self._curColor = 3

	self.parseSecond = false

	self._nestedTables = {}
	self._nCounter = 0
	self._file = nil

	self._maxDepth = 60

	self._curLevel = 1

	self._gridX = 0
	self._gridY = 0

	local td_sS = "<td>"
	local td_eS = "</td>"

end

function htmParser:setBorderWidth(_bWidth)
	self._border = _bWidth
end

function htmParser:setCellPadding(_cPadding)
	self._cellpadding = _cPadding
end

function htmParser:setCellSpacing(_cSpacing)
	self._cellspacing = _cSpacing
end

function htmParser:setStyleParams(_bgImage, _titleColor, _contentColor)
	--background-image:url('paper.gif');
	--background-repeat:repeat-y;
	local __bgImage
	if _bgImage == nil then
		-- use a default image
		__bgImage = "media/background.png"
	else
		__bgImage = _bgImage
	end
	local styleString = "<style type='text/css'> body { background-image:url('".._bgImage.."'); background-repeat:repeat-y:repeat-x; } p {color:".. _contentColor.."} h4 {color:".._titleColor.."} </style>"

	self._styleString = styleString
end

function htmParser:setCategoryColor(_color)
	if _color > #self._color or _color < 1 then
		print("SORRY! Collor out of range! Setting color to #0174DF")
		self._curColor = 3
	else
		self._curColor = _color
	end
end

function htmParser:dumpToHTML(_table, _file)
	self:_setHeader(_table, _file, self._bWidth, self._curColor)
	
	self:_writeToFile(_table, 1)
	self:_setFooter( )
end

function htmParser:dumpSparseToHTML(_table, _file, _szX, _szY)
	self:_setHeader(_table, _file, self._bWidth, self._curColor)
	self._gridX = _szX
	self._gridY = _szY
	self:_writeSparseToFile(_table)
	self:_setFooter( )
end

function htmParser:_setHeader(_table, _file)

	self._file = io.open(_file, "w")
	print("FILE OPENED: ".._file.."")
	self._file:write("<!DOCTYPE html>")
	self._file:write("<html>")
	self._file:write("<title>".."TABLE".."</title>")
	self._file:write("<head>")
	self._file:write(""..self._styleString.."")
	self._file:write("</head>")
	self._file:write("<body>")
	self._file:write("<center>")
	self._file:write("<table border="..self._border.." cellpadding="..self._cellpadding.." cellspacing="..self._cellspacing.." >")

	self._table = _table
	self._lastTable = {}
	--self._deepness = 0
	--htmParser:writeToFile()
end

-- returns a list of inner tables nested into the main table
function htmParser:_getTableDepth(_table)
	for i,v in ipairs(_table) do
		if type(v) == "table" then
			table.insert(self._nestedTables, i)
			self:_getTableDepth(v)
			self._nCounter = self._nCounter + 1
		end
	end

	return self._nCounter, self._nestedTables
end

-- Writes a SPARSE Table (game map?) to file
function htmParser:_writeSparseToFile(_table)
	if type(_table) == "table" then
		for i,v in ipairs(_table) do
			self._file:write("<tr>")
			for i2, v2 in ipairs(_table[i]) do
				if i2 <= self._gridX then
					if type(v2) ~= "table" then
						self._file:write("<td>"..v2.."</td>")
					else
						print("IT'S A TABLE MAN! IT'S A TABLE")
						if nil ~= v2.img then -- first check to see if we have an IMAGE ELEMENT.
							-- if so, display that! Else, check for a NODE element.
							-- else... pff
							self._file:write("<td><img src='"..v2.img.."'></td>")
						elseif nil ~= v2.node then
							self._file:write("<td>"..v2.node.."</td>")
						else
							self._file:write("ERROR! Unknown Table Element")
						end
					end
				end

			end
			if i <= self._gridY-#v then
				if nil ~= v[i] then
					self._file:write("<td>"..v[i].."</td>")
				end
			end
			self._file:write("</tr>")
		end
	end


end

-- Writes a regular (aka NON SPARSE) table to file
function htmParser:_writeToFile(_table, _level)
	local canWriteTable = false
	--self._file:write("<table border=1>")
	-- check if we really passed a table
	if type(_table) == "table" then
		local i,v = next(_table) -- we do not use ipairs or pairs since we have to keep switching between them and the
		-- code can get ugly. 
		self._file:write("<tr bgcolor="..self._color[self._curColor]..">")
		while (i) do
			if type(v) == "table" then -- check if the entry is a table
				if _level < self._maxDepth then
					self._file:write("<table border=1>")
					self:_writeToFile(v, _level + 1)

				else
					print("We cannot go deeper into the rabbit hole")
				end
			elseif type(v) ~= "boolean" and type(v) ~= "thread" then
				if type(i) ~= "number" then
					self._file:write("<td bgcolor="..self._color[self._curColor].."><h4>"..i.."</h4></td>")
				else
					self._file:write("<td bgcolor="..self._color[self._curColor].."><h4>".."".."</h4></td>")
				end


				
			end

			i, v = next(_table, i)
		end
		self._file:write("</tr>")
		--self._file:write("</table>")
		-- nowthat the "TITLES" are done, let's add the entries
		self._file:write("<tr>")
		local i2,v2 = next(_table)
		
		while (i2) do
			if type(v2) ~= "table" and type(v2) ~= "boolean" then -- check if the entry is a table
				
				-- check if the string ends in .jpg, jpeg, .png
				if self:_endswith(""..v2.."",".png") or self:_endswith(""..v2.."",".jpg") or self:_endswith(""..v2.."",".jpeg")then
					self._file:write("<td><img src='"..v2.."'></td>")
				elseif type(v) ~= "boolean" and type(v) ~= "thread" then
					self._file:write("<td><p>"..v2.."</p></td>")
				end

			elseif type(v2) == "table" then

				
			end
			i2, v2 = next(_table, i2)
		end
		self._file:write("</tr>")
	end

end

function htmParser:_endswith(_string, _stringEnd)
	return #_string >= #_stringEnd and _string:find(_stringEnd, #_string-#_stringEnd+1, true) and true or false
end

function htmParser:_setFooter( )
	
	self._file:write("</table>")
	self._file:write("</center>")
	self._file:write("</body>")
	self._file:write("</html>")
	self._file:flush()
	self._file:close()
	
	print("FINISHED WRITTING")
end