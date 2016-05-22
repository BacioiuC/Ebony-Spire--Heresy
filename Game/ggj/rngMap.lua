local astray = require('Game.lib.astray')


rngMap = { }


function rngMap:init( )
	math.randomseed(os.time())

	environment:init( )

	self._mapWidth = 32
	self._mapHeight = 32
	self._blockSize = 100
		
	self._dungeonLevel = 1
	self._dungeonType = Game.dungeonType

	self._dungeonTower = 1
	self._dungeonRooms = 2
	self._dungeonCave = 3
	
	self._portalLevelType = { }
	self._portalLevelType[1] = 2 --1
	self._portalLevelType[2] = 2
	self._portalLevelType[3] = 3
	self._portalLevelType[4] = 2
	self._portalLevelType[5] = 3
	self._portalLevelType[6] = 3
	self._portalLevelType[7] = 2
	self._portalLevelType[8] = 3
	self._portalLevelType[9] = 2
	self._portalLevelType[10] = 2
	self._levelTiles = { }

	--[[self._levelTiles[1] = "1"
	self._levelTiles[2] = "2"
	self._levelTiles[3] = "3"
	self._levelTiles[4] = "4"--]]

	for i = 1, 10 do
		self._levelTiles[i] = ""..i..""
	end
	local rndlevel = math.random(1, #self._levelTiles)
	self._diggerTable = { }

	self._mapObjects = {}
	self._mapFloors = { }
	print("Dungeon level: "..Game.dungeoNLevel.."")
	self._mapFloors[1] = makeCube ( self._blockSize, "tiles/"..self._levelTiles[Game.dungeoNLevel].."/floor.png"  )
	self._mapFloors[2] = makeCube (self._blockSize, "tiles/"..self._levelTiles[Game.dungeoNLevel].."/floor2.png" )

	self._mapWalls = { }
	local textureToUse = Game.dungeoNLevel
	if self:isTowerLevel( ) then
		textureToUse = 1
	end
	self._mapWalls[1] = makeCube( self._blockSize, "tiles/"..self._levelTiles[textureToUse].."/wall.png" )
	self._mapWalls[2] = makeCube( self._blockSize, "tiles/"..self._levelTiles[textureToUse].."/wall2.png" )
	self._mapWalls[3] = makeCube( self._blockSize, "tiles/"..self._levelTiles[textureToUse].."/wall3.png" )
	self._mapWalls[4] = makeCube( self._blockSize, "tiles/"..self._levelTiles[textureToUse].."/wall4.png" )
	self._mapWalls[5] = makeCube( self._blockSize, "tiles/"..self._levelTiles[textureToUse].."/wall.png" )
	self._mapWalls[6] = makeCube( self._blockSize, "tiles/"..self._levelTiles[textureToUse].."/wall.png" )
	self._mapWalls[7] = makeCube( self._blockSize, "tiles/"..self._levelTiles[textureToUse].."/wall5.png" )
	--self._mapWalls[8] = makeCube( self._blockSize, "tiles/"..self._levelTiles[Game.dungeoNLevel].."/wall_special.png" )


	--self._caveWalls[1] = makeCube( self._blockSize, "tiles/cave/1/wall.png" )
	--self._caveWalls[1] = makeCube( self._blockSize, "tiles/cave/1/wall.png" )

	--self._mapWalls[9] = makeCube( self._blockSize, "tiles/"..self._levelTiles[1].."/wall_special_2.png")

	self._bookCases = {}
	self._bookCases[1] = makeBox(100, 100, 10, "tiles/"..self._levelTiles[1].."/BookCase.png" )


	self._columns = { }
	self._columns[1] = makeBox(50, 100, 50, "tiles/"..self._levelTiles[Game.dungeoNLevel].."/wall.png" )
	self._SPECIAL_WALL = 8

	self._mapDoors = { }
	self._mapDoors[1] = makeCube( self._blockSize, "door.png" )

	self._mapCeilings = { }
	self._mapCeilings[1] = makeCube(self._blockSize, "ceiling_1.png")
	self._mapCeilings[2] = makeCube(self._blockSize, "ceiling_2.png")
	self._mapCeilings[3] = makeCube(self._blockSize, "ceiling_3.png")

	self._stairsMesh = makeBox(100, 100, 0, "stairs.png")

	self._darkness = makeCube(self._blockSize, "darkness.png")
	self._darkpatch = makeCube(self._blockSize, "darkpatch.png")

	-- layers: 1 for MAP
	self._mainMapLayer = 1
	self._doneGenerating = false

	self._floorElevation = 0

	self._diggerSettings = { } -- randomizes the diggers stuff :D
	self._diggerSettings[1] = {life_min = 7, life_max = 10, maximStepMin = 3, maximStepMax = 9, maxChanceToSpawn = 18, _cellThreshold = 900}
	self._diggerSettings[2] = {life_min = 8, life_max = 12, maximStepMin = 5, maximStepMax = 12, maxChanceToSpawn = 14, _cellThreshold = 900}
	self._diggerSettings[3] = {life_min = 8, life_max = 9, maximStepMin = 3, maximStepMax = 8, maxChanceToSpawn = 18, _cellThreshold = 1100}

	self._rndDiggerSettings = math.random(1, #self._diggerSettings)

	self._cells = 0
	self._cellThreshold = self._diggerSettings[self._rndDiggerSettings]._cellThreshold
	self._marginDist = 8

	self._ldlX = 1 --last digger position x
	self._ldlY = 1 --last digger position y

	self._emptyCellTable = { } -- tabel that contains empty cells where stuff can be placed :)
	self._floorMapTable = { } -- pretty much a map with Walkable Zones. Used for pathfinding

	self._stairsX = nil
	self._stairsY = nil

	--[[floor = makeCube ( 100, "floor.png"  )
	floor2 = makeCube (100, "floor2.png" )
	wall = makeCube( 100, "wall.png" )
	ceiling = makeCube(100, "ceiling_1.png")

	local map = {}
	for x = 1, self._mapWidth do
		map[x] = { }
		for y = 1, self._mapHeight do
			map[x][y] = { }
			local rnd = math.random(1, 4)
			-- first, add the floors and type
			map[x][y].floorType = rnd
			if rnd == 4 then
				map[x][y].floor = image:new3DImage(floor2, x*100, 0, y*100, 1)
			else
				map[x][y].floor = image:new3DImage(floor, x*100, 0, y*100, 1)
				map[x][y].floor = image:new3DImage(ceiling, x*100, 300, y*100, 1)
			end
			if x == 1 or x == self._mapWidth then
				map[x][y].wall = image:new3DImage(wall, x*100, 100, y*100, 1)
				map[x][y].wall = image:new3DImage(wall, x*100, 200, y*100, 1)
			end

			if y == 1 or y == self._mapHeight then
				map[x][y].wall = image:new3DImage(wall, x*100, 100, y*100, 1)
				map[x][y].wall = image:new3DImage(wall, x*100, 200, y*100, 1)
			end

			if map[x][y].wall ~= nil then
				map[x][y].hasWalls = true
			else
				map[x][y].hasWalls = false
			end

		end
	end

	sprite = makeBox(100, 100, 0, "sprite_test.png")
	local Test = image:new3DImage(sprite, 400, 100, 4400, 2)


	self._map = map
	self:addRandomWalls( )--]]

	self._diggerDirTable = { }
	self._diggerDirTable[1] = {0, 1} -- UP, L, D, R
	self._diggerDirTable[2] = {1, 0}
	self._diggerDirTable[3] = {0, -1}
	self._diggerDirTable[4] = {-1, 0}
	self._maxDiggers = 4
	--self:generate( )

	if self:isTowerLevel( ) then
		self:generateTowerInterior( )
	elseif self._dungeonType == self._dungeonCave then
		self:generateCaveDungeon( )
	else
		self:generate( )
	end
	
	--self:load( )
end

function rngMap:getPortalLevelType( )
	return self._portalLevelType
end

function rngMap:isTowerLevel( )
	if self._dungeonType == self._dungeonTower then
		return true
	else
		return false
	end
end

function rngMap:setLevelType(_levelType)
	self._dungeonType = _levelType
	Game.dungeonType = _levelType
end

function rngMap:returnTowerLevelType( )
	return self._dungeonTower
end

function rngMap:returnCaveLevelType( )
	return self._dungeonCave
end

function rngMap:returnDungeonLevelType( )
	return self._dungeonRooms
end

function rngMap:setWall(_x, _y, _bool)
	self._map[_x][_y].hasWall = _bool
end

function rngMap:newDigger(_x, _y)
	--print("WORLD TIME: "..Game.worldTimer.."")

	local temp = {
		id = #self._diggerTable+1,
		x = _x,
		y = _y,
		chanceToSpawn = 4,
		sTimer = Game.worldTimer,
		timerCounter = 0.000000000001,
		maxDistanceFromEdge = 2,
		hasDigged = false,
		orient = math.random(1,4),
		life = math.random(self._diggerSettings[self._rndDiggerSettings].life_min, self._diggerSettings[self._rndDiggerSettings].life_max),
		step = 1,
		maximStep = math.random(self._diggerSettings[self._rndDiggerSettings].maximStepMin, self._diggerSettings[self._rndDiggerSettings].maximStepMax),
	}
	--
	--print("TEMP LIFE: "..temp.life.."")
	self:removeWallAt(_x, _y)
	table.insert(self._diggerTable, temp)
end

function rngMap:updateDigger(_id)
	local v = self._diggerTable[_id]
	if v~= nil and v.sTimer ~= nil then
		--if Game.worldTimer > v.sTimer + v.timerCounter then
			if v.hasDigged == false then
				if v.step > v.maximStep then
					v.step = 1
					v.life = v.life - 3

					--v.hasDigged = true
				end
				v.step = v.step + 1
					-- see if we should spawn a new digger --24
					local rndChance = math.random( 1, self._diggerSettings[self._rndDiggerSettings].maxChanceToSpawn	)
					if #self._diggerTable < self._maxDiggers and self._cells < self._cellThreshold then
						if rndChance <= v.chanceToSpawn then
							self:newDigger(v.x, v.y)
						end
					end
				v.orient = self:_diggerDecideOrientation(v)


				v.hasDigged = true
			else
				if v.orient ~= nil then
					self:removeWallAt(v.x+self._diggerDirTable[v.orient][1], v.y+self._diggerDirTable[v.orient][2] )

					v.x = v.x+self._diggerDirTable[v.orient][1]
					v.y = v.y+self._diggerDirTable[v.orient][2]
					v.life = v.life - 1

					if self._map[v.x] ~= nil then
						if self._map[v.x][v.y] ~= nil then
							self._map[v.x][v.y].wasVisited = true
						end
					end

					local _x = v.x
					local _y = v.y 
					local wBool = false
					for i = -1, 1 do
						for j = -1, 1 do
							if self:isWallAt(_x+i, _y+j) == true then
								wBool = true
							end
						end
					end

					if wBool == true then
						self._ldlX = v.x
						self._ldlY = v.y
					end

				end
				v.sTimer = Game.worldTimer
				v.hasDigged = false
			end
		--end
	end

end

function rngMap:returnDiggerAmmount( )
	return #self._diggerTable
end

-- leave it to true! Then, mane a new map, copy the new generated table
-- into a even bigger one, and put in the middle
function rngMap:_diggerDecideOrientation(_v)
	local v = _v
	if v.life > 0 then
		local orient = math.random(1, 4)
		local forient = 1
		local rCounter = 0
		local tendancy = 0
		repeat
			if v.step <= v.maximStep then
				orient = v.orient
			else
				orient = math.random(1, 4)
			end
			rCounter = rCounter + 1

			if rCounter == 4 then
				v.life = v.life - 3
				v.step = v.maximStep
				rCounter = 0
				
				break
			end
			-- UP, L, D, R
		until self:isWallAt(_v.x+self._diggerDirTable[orient][1], _v.y+self._diggerDirTable[orient][2]) == true  and _v.x+self._diggerDirTable[orient][1] > v.maximStep and
		_v.x+self._diggerDirTable[orient][1] < self._mapWidth-v.maximStep and _v.y+self._diggerDirTable[orient][2] > v.maximStep and _v.y+self._diggerDirTable[orient][2] < self._mapHeight-v.maximStep

		return orient
	end

end

function rngMap:update( )
	--[[for i,v in ipairs(self._diggerTable) do
		self:updateDigger(i)
		self:_dropDigger(i)
		

	end
	--print("DIGGER TABLE SIZE: "..#self._diggerTable.."")
	if Game.worldTimer > 0.02 and #self._diggerTable < 3 then
		if self._cells < self._cellThreshold then
			self:newDigger(self._ldlX, self._ldlY )
		else 
			self:addBoundaries( )

			self._doneGenerating = true
		end
	end--]]
	--print("CELLS: "..self._cells.."")
end

function rngMap:newTempBiggerMap( )


	-- now, copy the contents of old map into it.
end

function rngMap:updateMapGFX( )
	if self:isTowerLevel() == true then
		local rx, ry, rz = camera:getRot( )

		if self._stairsGFX ~= nil then
			image:setRot3D(self._stairsGFX, 0, ry, 0)
		end
	end
end

function rngMap:_dropDigger(_id)
	local v = self._diggerTable[_id]
	if v.life ~= nil then
		--print("V.Life: "..v.life.." ID: ".._id.."")
		if v.life < 1 then
			--print("DEADDDD")
			table.remove(self._diggerTable, _id)
		end
	end
	
end

function rngMap:getSize( )
	return self._mapWidth, self._mapHeight
end

function rngMap:isWallAt(_x, _y)

	local bool = false
	if self._map[_x] ~= nil and self._map[_x][_y] ~= nil then
		bool = self._map[_x][_y].hasWall
	end


	return bool
end

function rngMap:removeWallAt(_x, _y)
	local x = _x
	local y = _y
	if self._map[_x] ~= nil and self._map[_x][_y] ~= nil then
		--print("REMOVED AT: ".._x.." | ".._y.."")
		self._map[x][y].hasWall = false
		image:removeProp(self._map[x][y].wall, self._mainMapLayer)

		self._cells = self._cells + 1
	end
	
end



function rngMap:removeFloorAt(_x, _y)
	local x = _x
	local y = _y
	if self._map[_x] ~= nil and self._map[_x][_y] ~= nil then
		--print("REMOVED AT: ".._x.." | ".._y.."")
		self._map[x][y].hasFloor = false
		self._map[x][y].hasWall = true
		image:removeProp(self._map[x][y].floor, self._mainMapLayer)
		--self._cells = self._cells + 1
	end
	
end

function rngMap:removeCeilingAt(_x, _y)
	local x = _x
	local y = _y
	if self._map[_x] ~= nil and self._map[_x][_y] ~= nil then
		--print("REMOVED AT: ".._x.." | ".._y.."")
		self._map[x][y].hasCeiling = false
		image:removeProp(self._map[x][y].ceiling, self._mainMapLayer)
		self._cells = self._cells + 1
	end
	
end

function rngMap:addWallAt(_x, _y, _optional)
	local textureIDX = 1
	if _optional ~= nil then
		textureIDX = _optional
	end

	if self._map[_x] ~= nil and self._map[_x][_y] ~= nil then
		self._map[_x][_y].wall = image:new3DImage(self._mapWalls[textureIDX], _x*self._blockSize, self._floorElevation+self._blockSize, _y*self._blockSize, self._mainMapLayer)
		self._map[_x][_y].hasWall = true
	end
end

function rngMap:returnMap( )

	return self._map
	-- body
end

function rngMap:makePathFinderTable( )
	self._emptyFloor = { }
	for x = 1, self._mapWidth do
		self._floorMapTable[x] = { }
		for y = 1, self._mapHeight do
			if self._map[x][y].hasWall == true then
				self._floorMapTable[x][y] = 1
			else
				self._floorMapTable[x][y] = 0
			end
		end
	end


	Game.grid = mGrid:transformTableForJumper(self._floorMapTable)
	Game:initPathfinding( Game.grid )	
end

function rngMap:setPatherWalkableAt(_x, _y, _walkState)
	Game.grid[_x][_y] = _walkState
end

function rngMap:GenerateCave(w,h,seed)
	

   local map = {}
   --[[for x = 1, w do
      map[x] = {}
      for y = 1, h do
         if math.random(0,100) < 45 then
            map[x][y] = "#"
         else
            map[x][y] = "."
         end
      end
   end

   for x = 1, w do
      for y = 1, h do
         if x == 1 or x == w or y == 1 or y == h then
            map[x][y] = "#"
         end
      end
   end--]]
   -- a,b,c,d, seed, it1,it2
   -- width, height, lowest percentage of open space, amount of initial wall(44 or nil works best), random seed, growing iterations, smoothing iterations
   map = cavity.makemap(w,h, 12,nil,math.random(os.time()))
   return map
end

function rngMap:generateCaveDungeon( )
	self._map = {}
	self._dungeonType = self._dungeonCave
	local caveMap = self:GenerateCave(self._mapWidth, self._mapHeight, math.random(0, 2616123))
	for x = 1, self._mapWidth do
		self._map[x] = { }
		for y = 1, self._mapHeight do
			self._map[x][y] = { }

			-- for starts, we make the floor and cover it with walls
			self._map[x][y].floor = image:new3DImage(self._mapFloors[math.random(1, #self._mapFloors)], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
			image:set3DIndex(self._map[x][y].floor, math.random(1,5))
			self._map[x][y].hasFloor = true -- there is a floor there :)
			self._map[x][y].wasVisited = false

			-- fill the map with walls
			self._map[x][y].wall = image:new3DImage(self._mapWalls[math.random(1, #self._mapWalls)], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._mainMapLayer) --math.random(1, #self._mapWalls)
			image:set3DIndex(self._map[x][y].wall, math.random(1,5))
			self._map[x][y].hasWall = true

			if caveMap[x][y] ~= " " then -- wall
				self:removeFloorAt(x, y)
			elseif caveMap[x][y] ~= "#" then
				self:removeWallAt(x, y)
			end
			print(""..caveMap[x][y].."")

		end
	end

	self:addBoundaries(true)
	local _px, _py = self:returnEmptyLocations( )
	environment:createPortal(_px, _py, true)
	print("ASTA")
	self._doneGenerating = true
end

function rngMap:generateTowerInterior( )
		--local tiles = generator:CellToTiles( dungeon )
	local map = { }
	self._dungeonType = self._dungeonTower
	for x = 1, self._mapWidth do
		map[x] = { }
		for y = 1, self._mapHeight do
			map[x][y] = { }

			--map[x][y].floor = image:new3DImage(self._mapFloors[math.random(1, #self._mapFloors)], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
			--image:set3DIndex(map[x][y].floor, math.random(1,5))
			map[x][y].hasFloor = false -- there is a floor there :)
			map[x][y].wasVisited = false

			map[x][y].hasWall = true
            map[x][y].wasVisited = false

		end
	end

	local centerX = math.floor(self._mapWidth/2)
	local centerY = math.floor(self._mapHeight/2)
	local radius = 7
    local height = 100
    local radStep = 1/(radius)
    local towerLevels = 1
   --[[ for k = 0, towerLevels do
        for angle = 1, math.pi+radStep, radStep do
            local pX = math.cos( angle ) * radius * 2
            local pY = math.sin( angle ) * radius * 2
            for i=-1,1,2 do
                for j=-1,1,2 do
                	local gfx = nil
                	local x = math.floor((centerX +  i*pX))
                	local y = math.floor(centerY + j*pY)
                	print("X: "..x.." | Y "..y.."")
                	map[x][y].wall = image:new3DImage(self._mapWalls[math.random(1, #self._mapWalls)], (centerX +  i*pX)*self._blockSize, k*height,(centerY + j*pY)*self._blockSize, self._mainMapLayer)
               		map[x][y].hasWall = true
               		image:set3DIndex(map[x][y].wall, math.random(1,5))
               		map[x][y].wasVisited = false
                end
            end
        end
    end--]]

    self._map = map

    -- clean up unused floor
    for x = 1, self._mapWidth do
		for y = 1, self._mapHeight do
		--if self:isWallAt(x, y) == false  then
			if math.dist(centerX, centerY, x, y) < 2*radius then
				map[x][y].floor = image:new3DImage(self._mapFloors[math.random(1, #self._mapFloors)], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer)
				map[x][y].hasFloor = true
				map[x][y].hasWall = false
			elseif math.dist(centerX, centerY, x, y) == 2*radius then
			    map[x][y].wall = image:new3DImage(self._mapWalls[math.random(1, #self._mapWalls)], x*self._blockSize, self._blockSize, y*self._blockSize, self._mainMapLayer)
           		map[x][y].hasWall = true
           		image:set3DIndex(map[x][y].wall, math.random(1,5))
           		map[x][y].wasVisited = false
			end
			--[[if(x < self._mapWidth) then
				if( x <= centerX) then
					if (map[x][y].hasFloor == true and map[x+1][y].hasWall == true)  then -- means there's a floor on the right, just outside of a wall
						self:removeFloorAt(x, y)
						map[x][y].hasFloor = false
					end
				end
			end--]]
		end
	end

	radius = 4
	isEntrance = false
    -- clean up unused floor
    for x = 1, self._mapWidth do
		for y = 1, self._mapHeight do
		--if self:isWallAt(x, y) == false  then
			if math.dist(centerX, centerY, x, y) < 2*radius then
				map[x][y].floor = image:new3DImage(self._mapFloors[math.random(1, #self._mapFloors)], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer)
				map[x][y].hasFloor = true
				map[x][y].hasWall = false
			elseif math.dist(centerX, centerY, x, y) == 2*radius then
				if isEntrance == true then
				    map[x][y].wall = image:new3DImage(self._mapWalls[math.random(1, #self._mapWalls)], x*self._blockSize, self._blockSize, y*self._blockSize, self._mainMapLayer)
	           		map[x][y].hasWall = true
	           		image:set3DIndex(map[x][y].wall, math.random(1,5))
	           		map[x][y].wasVisited = false
	           	else
	           		environment:createDoor(x+1, y, 1)
	           		isEntrance = true
	           	end
           	end
		end
	end

	self._environmentTable = {} -- holds environmental objects like columns, book cases, etc
    self:addBoundaries(false)

	self:generateBookCasesOnTowerLevel( )
	--self:createRandomColumns( )
	
	local _px, _py = self:returnEmptyLocations( )
	environment:createPortal(_px, _py)
	self:placeStairs(true)
	self._doneGenerating = true


	
end

function rngMap:generateBookCasesOnTowerLevel( )
	
	for x = 1, self._mapWidth do
		for y = 1, self._mapHeight do
			if self._map[x][y].hasWall == true then
				foundFloor = false
				--for i = -1, 1 do
				i = math.random(-1, 1)
				if i ~= 0 then
					if x+i > 0 and x+1 < self._mapWidth then
						if self._map[x+i][y].hasFloor == true and foundFloor == false then
							foundFloor = true
							local temp = {
								gfx = image:new3DImage(self._bookCases[math.random(1, #self._bookCases)], (x)*self._blockSize, self._blockSize, y*self._blockSize+i*2+i*50, self._mainMapLayer),
								_x = (x)*self._blockSize,
								_y = y*self._blockSize
							}
							dir = math.random(0, 1)
							posx = x*self._blockSize
							posy = y*self._blockSize
							if dir == 0 then -- forward/backward 
								posx = x*self._blockSize
								posy = y*self._blockSize+i*2+i*50
							else -- left/right
								posx = x*self._blockSize+i*2+i*50
								posy = y*self._blockSize
								if(temp.gfx ~= nil) then
									image:setRot3D(temp.gfx, 0, 90, 0)
									image:setLoc(temp.gfx, posx, self._blockSize, posy)
								end
							end
							table.insert(self._environmentTable, temp)
						end
					end
				end

			end
		end
	end
end

function rngMap:createRandomColumns( )
	for x = 1, self._mapWidth do
		for y = 1, self._mapHeight do
			rndChance = math.random(1, 8)
			if rndChance == 4 then
				if self._map[x][y].hasFloor == true then
					enoughSpace = false
					spaceCounter = 0
					for i = -1, 1 do
						for j = -1, 1 do
							if x+i > 0 and x + i < self._mapWidth and y + j > 0 and y + j < self._mapHeight then
								if i ~= 0 and j ~= 0 then
									if self._map[x+i][y+j].hasWall == false then
										spaceCounter = spaceCounter + 1
										if(spaceCounter >= 4) then
											enoughSpace = true
											spaceCounter = 0
										end
									end
								end
							end
						end
					end

					if(enoughSpace == true) then
						local temp = {
							gfx = image:new3DImage(self._columns[math.random(1, #self._columns)], (x)*self._blockSize, self._blockSize, y*self._blockSize, self._mainMapLayer),
							_x = (x)*self._blockSize,
							_y = y*self._blockSize
						}
						table.insert(self._environmentTable, temp)
						self._map[x][y].hasFloor = false
						self._map[x][y].hasWall = true
					end
				end
			end
		end
	end
end

function rngMap:generate( )
	-- our game map :) INIT IT full of walls
	
	--[[for x = 1, self._mapWidth do
		map[x] = { }
		for y = 1, self._mapHeight do
			-- map becomes a table! It will store data such as
			-- what the tile it has is (floor, wall, etc)
			-- what type of a floor/wall it is
			-- etc
			map[x][y] = { }

			-- for starts, we make the floor and cover it with walls
			map[x][y].floor = image:new3DImage(self._mapFloors[math.random(1, #self._mapFloors)], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
			image:set3DIndex(map[x][y].floor, math.random(1,5))
			map[x][y].hasFloor = true -- there is a floor there :)
			map[x][y].wasVisited = false

			-- fill the map with walls
			map[x][y].wall = image:new3DImage(self._mapWalls[1], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._mainMapLayer) --math.random(1, #self._mapWalls)
			image:set3DIndex(map[x][y].wall, math.random(1,5))
			map[x][y].hasWall = true
		end
	end

	self._map = map

	-- place our digger
	local centerX = math.floor(self._mapWidth/2)
	local centerY = math.floor(self._mapHeight/2)
	self:newDigger(centerX, centerY)--]]

	--local generator = astray.Astray:new( 25, 25, 30, 70, 80, astray.RoomGenerator:new(8, 3, 6, 3, 6) )

	--local dungeon = generator:Generate()

	local generator = astray.Astray:new( math.floor(self._mapWidth/2)-1,  math.floor(self._mapHeight/2)-1, 30, 70, 80, astray.RoomGenerator:new(8, 3, 6, 3, 6) )

	local dungeon = generator:Generate()

	local tiles = generator:CellToTiles( dungeon ) --self:GenerateCave(self._mapWidth, self._mapHeight, math.random(1, 25225)) --

	self._dungeonType = self._dungeonRooms
	--self._mapWidth = #tiles
	--self._mapHeight = #tiles[1]
	--local tiles = generator:CellToTiles( dungeon )
	local map = { }
	for x = 1, self._mapWidth+1 do
		map[x] = { }
		for y = 1, self._mapHeight+1 do
			-- map becomes a table! It will store data such as
			-- what the tile it has is (floor, wall, etc)
			-- what type of a floor/wall it is
			-- etc
			map[x][y] = { }

			-- for starts, we make the floor and cover it with walls
			map[x][y].floor = image:new3DImage(self._mapFloors[math.random(1, #self._mapFloors)], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
			image:set3DIndex(map[x][y].floor, math.random(1,5))
			map[x][y].hasFloor = true -- there is a floor there :)
			map[x][y].wasVisited = false

			-- fill the map with walls
			map[x][y].wall = image:new3DImage(self._mapWalls[math.random(1, #self._mapWalls)], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._mainMapLayer) --math.random(1, #self._mapWalls)
			image:set3DIndex(map[x][y].wall, math.random(1,5))
			map[x][y].hasWall = true
		end
	end
	--local astray = require('astray')



	self._map = map

	for y = 2, #tiles[1] do

	    local line = ''
	    for x = 2, #tiles do
	        line = line .. tiles[x][y]
	        if(tiles[x-1] ~= nil and tiles[x-1][y-1] ~= nil) then
		        if tiles[x-1][y-1] ~= "#" then
		        	self:removeWallAt(x, y)
		        	if tiles[x-1][y-1] == "-" then --forward door
		        		environment:createDoor(x, y, 1)
		        	elseif tiles[x-1][y-1] == "|" then
		        		environment:createDoor(x, y, 2)
		        	end

		        else
		        	self:removeFloorAt(x, y)
		        end
		    end

	    end
	    print(line)
	end

	--[[for x = 1, self._mapWidth do
		for y = 1, self._mapHeight do
			if(tiles[x][y] ~= "#") then
				self:removeWallAt(x, y)
			end
		end
	end--]]


	self:addBoundaries( )

	local _px, _py = self:returnEmptyLocations( )
	environment:createPortal(_px, _py, true)

	environment:removeUnusedDoors( )
	--self:placeStairs()
	self._doneGenerating = true


	

end

function rngMap:returnEmptyCellList( )
	return self._emptyCellTable
end

function rngMap:getCellID(_x, _y)
	for i = 1, #self._emptyCellTable do
		if self._emptyCellTable[i]._x == _x and self._emptyCellTable[i]._y == _y then
			return i
		end
	end
end


function rngMap:addBoundaries(_optional)
	local emptyCellIdx = 1
	for x = 1, self._mapWidth do
		for y = 1, self._mapHeight do


		--[[	if x == 1 or x == self._mapWidth then
				if self:isWallAt(x, y) == false then
					self:addWallAt(x, y)
				end
			end

			if y == 1 or y == self._mapHeight then
				if self:isWallAt(x, y) == false then
					self:addWallAt(x, y)
				end				
			end--]]

			if self:isWallAt(x, y) == false and environment:isDoorNearby(x, y) == false then
				self._emptyCellTable[emptyCellIdx] = {_x = x, _y = y}
				emptyCellIdx = emptyCellIdx + 1
			end
		end
	end


	self:makeMiniMap( )
	self:removeUnusedWalls( )
	self._darknessTable = { }
	if(_optional == nill) then
		self:addDarkness( )
	end
	
end

function rngMap:returnDarknessTable( )
	return self._darknessTable
end

function rngMap:addDarkness(_isStatic)
	
	local _mesh = self._darkness
	if _isStatic ~= nil then
		_mesh = self._darkpatch
	end
	local eCell = self._emptyCellTable
	for i = 1, #eCell do
		local __x = eCell[i]._x
		local __y = eCell[i]._y
		self._darknessTable[i] = {x = __x, y = __y, prop = image:new3DImage(_mesh, __x*100, 100, __y*100, self._mainMapLayer ), isVisible = true, isStatic = _isStatic  }
		--image:setVisible(self._darknessTable[i].prop, true)
	end
end

function rngMap:addDarknessAt(_x, _y, _isStatic) 
	local _mesh = self._darkness
	if _isStatic ~= nil then
		_mesh = self._darkpatch
	end
	local __x = _x
	local __y = _y
	local tbDarkSize = #self._darknessTable+1
	self._darknessTable[tbDarkSize] = {x = __x, y = __y, prop = image:new3DImage(_mesh, __x*100, 100, __y*100, self._mainMapLayer ), isVisible = true, isStatic = _isStatic  }
	image:setVisible(self._darknessTable[tbDarkSize].prop, true)
end

-- Lots of iffs! Added the outer two ones to fix crash on resetting the stage
-- while the map is still building :(

function rngMap:isDarknessAt(_x, _y, _removeStatic)
	local bool = false
	if self._darknessTable ~= nil then
		local darknessTableSz = #self._darknessTable
		if darknessTableSz ~= nil then
			for i = 1, darknessTableSz do
				if self._darknessTable[i] ~= nil then
					if self._darknessTable[i].x == _x and self._darknessTable[i].y == _y then
						if self._darknessTable[i].isVisible == true then
							if self._darknessTable[i].isStatic == nil then
								image:setVisible(self._darknessTable[i].prop, false)
								image:removeProp(self._darknessTable[i].prop, self._mainMapLayer)

								self._darknessTable[i].prop = nil
								self._darknessTable[i].isVisible = false
							else
								if _removeStatic ~= nil then
									image:setVisible(self._darknessTable[i].prop, false)
									image:removeProp(self._darknessTable[i].prop, self._mainMapLayer)

									self._darknessTable[i].prop = nil
									self._darknessTable[i].isVisible = false
								end
							end
						end
					end
				end
			end
		end
	end
end

function rngMap:isPatchAt(_x, _y, _noCheckPlox)
	if _darknessTable ~= nil then
		for i = 1, #self._darknessTable do
			if self._darknessTable[i].x == _x and self._darknessTable[i].y == _y then
				if self._darknessTable[i].isVisible == true then
					if self._darknessTable[i].isStatic ~= nil then
						local rndChance = math.random(1, 300)
						if _noCheckPlox == false then
							log:newMessage("It is pitch black. You are likely to be eaten by a grue.")
						end
						return true, rndChance
					end
				end
			end
		end
	end
end

function rngMap:getDarknessAt(_x, _y)
	for i = 1, #self._darknessTable do
		if self._darknessTable[i].x == _x and self._darknessTable[i].y == _y then
			if self._darknessTable[i].isVisible == true then
				if self._darknessTable[i].isStatic ~= nil then
					return true
				end
			end
		end
	end
	return false
end

function rngMap:_DarknessAt(_x, _y)
	if _darknessTable ~= nil then
		for i = 1, #self._darknessTable do
			if self._darknessTable[i].x == _x and self._darknessTable[i].y == _y then
				if self._darknessTable[i].isVisible == true then
					return true
				end
			end
		end
	end
	return false
end

function rngMap:disableDarkness( )
	for x = 1, self._mapWidth do
		for y = 1, self._mapHeight do
			self:isDarknessAt(x, y, true)
		end
	end
end

function rngMap:removeDarkness( )
	local px, py = player:returnPosition( )
	local pStats = player:returnPlayerStats( )
	local vRange = math.floor(pStats.viewRange/2)
	--print("PX :"..px.." PY: "..py.."")
	for i = -vRange, vRange do
		for j = -vRange, vRange do
			self:isDarknessAt(px+i, py+j)
		end
	end
end

function rngMap:makeMiniMap( )

end

function rngMap:getMiniMap( )

end

function rngMap:addCeilings( )
	for x = 2, self._mapWidth do
		for y = 2, self._mapHeight do
			self._map[x][y].ceiling = image:new3DImage(self._mapCeilings[math.random(1, #self._mapCeilings )], x*self._blockSize, self._floorElevation+self._blockSize+self._blockSize, y*self._blockSize, self._mainMapLayer)
			self._map[x][y].hasCeiling = true
		end
	end
end

function rngMap:setRoofVisibility(_state)
	for x = 1, self._mapWidth do
		for y = 1, self._mapHeight do
			if self._map[x][y].hasCeiling == true then
				image:setVisible(self._map[x][y].ceiling, _state)
			end	
		end
	end
end



function rngMap:addRandomWalls( )
	for x = 2, self._mapWidth-1 do
		for y = 2, self._mapHeight-1 do
			local rnd = math.random(1, 16)
			if rnd == 4 then
				self._map[x][y].wall = image:new3DImage(wall, x*self._blockSize, 100, y*self._blockSize, 1)
				--if math.random(1, 8) == 6 then
					self._map[x][y].wall = image:new3DImage(wall, x*self._blockSize, 200, y*self._blockSize, 1)
				--end
				self._map[x][y].hasWalls = true
			elseif rnd == 2 then
				entity:new(x, y, math.random(1,2))
			end
		end
	end
end

function rngMap:returnGenStatus( )
	return self._doneGenerating
end

function rngMap:setGenStatus(_value)
	self._doneGenerating = _value
end

function rngMap:returnEmptyLocations( )
	local resTable = self._emptyCellTable[math.random(1, #self._emptyCellTable)]
	return resTable._x, resTable._y
end

-------------------------------------
----- GEOMETRY GENERATION STUFF -----
-------------------------------------

function rngMap:findCoridors( )

end



-------------------------------------
-- Save/Load Routine ----------------
-------------------------------------

function rngMap:save( )
	table.save(self._map,  "map/level1.gnrtd")
end

function rngMap:createDarkPatch(_x, _y)
--self._darkpatch
end

function rngMap:load( )
local tab = table.load("map/level1.gnrtd")
	local map = {}
	for x = 1, #tab do
		map[x] = { }
		for y = 1, #tab[x] do
			map[x][y] = { }

			if tab[x][y].hasFloor == true then
				map[x][y].hasFloor = true
				map[x][y].floor = image:new3DImage(self._mapFloors[math.random(1, #self._mapFloors)], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer)
			end

			if tab[x][y].hasWall == true then
				map[x][y].hasWall = true
				map[x][y].wall = image:new3DImage(self._mapWalls[1], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._mainMapLayer) --math.random(1, #self._mapWalls)
			end

		end
	end

	self._map = map
	self._doneGenerating = true
end

function rngMap:destroyMap( )
	for x = 1, self._mapWidth do
		for y = 1, self._mapHeight do
			if self._map[x] ~= nil then
				if self._map[x][y].hasFloor == true then
					image:removeProp(self._map[x][y].floor, self._mainMapLayer)
					self._cells = self._cells + 1
					self._map[x][y].floor = nil
				end

				if self._map[x][y].hasWall == true then
					self._map[x][y].hasWall = true
					image:removeProp(self._map[x][y].wall, self._mainMapLayer) 
					self._map[x][y].wall = nil
				end

				if self._map[x][y].hasCeiling == true then
					image:removeProp(self._map[x][y].ceiling, self._mainMapLayer) 
					self._map[x][y].ceiling = nil
				end	
			end
			self:isDarknessAt(x, y, true)		
		end


	end

	for i,v in ipairs(self._environmentTable) do
		image:removeProp(v.gfx, self._mainMapLayer) 
	end

	self._environmentTable = {}

	self:destroyStairs( )
	self:destroyStairs( )
	self:destroyStairs( )
	self:destroyStairs( )
	self:destroyStairs( )
	self:destroyStairs( )
	self:destroyStairs( )

	environment:removeAll( )
	
	--[[for i = 1, #self._darknessTable do
		if self._darknessTable[i].x == _x and self._darknessTable[i].y == _y then
			image:removeProp(self._darknessTable[i].prop, self._mainMapLayer)
			self._darknessTable[i].prop = nil
			self._darknessTable[i].isVisible = false
		end
	end--]]


end


-- places stairs somewhere on the map
-- Always safe the position of last stair point
-- to create upward stairs.
function rngMap:placeStairs(_isTower)
	if _isTower ~= true then
	else
		self._stairsX = self._mapWidth/2
		self._stairsY = self._mapHeight/2
		self._stairsGFX = image:new3DImage(self._stairsMesh, self._stairsX*100, 100, self._stairsY*100, 2 )
	end
	
end

function rngMap:destroyStairs( )
	if self._stairsGFX ~= nil then
		image:removeProp(self._stairsGFX, 2)
	end
end

function rngMap:returnStairsPosition( )
	return self._stairsX, self._stairsY
end

function rngMap:checkForIslands( )

end
-- loop through the walls
-- Check if there's a path anywhere next to it
-- if not, remove it
function rngMap:removeUnusedWalls( )
	local wallsToRemove = { }
	for x = 1, self._mapWidth do
		for y = 1, self._mapHeight do
			if self._map[x][y].hasWall == true then
				local bool = false
				local rx = x
				local ry = y
				for i = -1, 1 do
					for j = -1, 1 do
						if self._map[x-i] ~= nil then
							if self._map[x-i][y-j] ~= nil then
								if self._map[x-i][y-j].hasWall == false then
									bool = true
									rx = x-i
									ry = y-j
								end
							end
						end
					end
				end
				if bool == false then
					local temp = {
						_x = rx,
						_y = ry,
					}
					table.insert(wallsToRemove, temp)
				end
			end
		end
	end

	for y = 1, self._mapHeight do
		x = self._mapWidth+1
		local temp = {
			_x = x,
			_y = y,
		}
		table.insert(wallsToRemove, temp)
	end

		for x = 1, self._mapWidth+1 do
		y = self._mapHeight+1
		local temp = {
			_x = x,
			_y = y,
		}
		table.insert(wallsToRemove, temp)
	end

	for i,v in ipairs(wallsToRemove) do
		self:removeWallAt(v._x, v._y)
		self:removeFloorAt(v._x, v._y)
	end

	--self:textureWallChunks( )
	--self:addSpecialWall( )
end

function rngMap:textureWallChunks( )
	for x = 1, self._mapWidth do
		for y = 1, self._mapHeight do
			if self._map[x][y].hasWall == true then
				local rnd = math.random(1, 100)
				if rnd < 5 then
					self:removeWallAt(x, y)
					self:addWallAt(x, y, self._SPECIAL_WALL)
				end
			end
		end
	end
end

function rngMap:addSpecialWall( )
	local centerX = math.floor(self._mapWidth/2)
	local centerY = math.floor(self._mapHeight/2)
	if Game.dungeoNLevel == 1 then
		--self:removeWallAt(centerX, centerY+1)
		--self:addWallAt(centerX, centerY+1, 9)
		for x = -1, 1 do
			for y = -1, 1 do
				if self:isWallAt(centerX-x, centerY-y) == true then
					self:removeWallAt(centerX-x, centerY-y)
					self:addWallAt(centerX-x, centerY-y, 9)
				end
			end
		end
	end
end