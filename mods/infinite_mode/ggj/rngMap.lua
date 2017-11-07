local astray = require('Game.lib.astray.astray')
require "mods.infinite_mode.ggj.proc"


--mods.infinite_mode.ggj.

rngMap = { }


function rngMap:init( )
	Game.lightFactor = 0
	--Game.clearFlag = false
	math.randomseed(os.time())
	self._testMapFile = "test_map.lua"--"city_map.lua"--"test_map.lua"
	self._tmxMap = dofile("map/"..self._testMapFile.."")

	self._towerLevels = {}
	self._towerLevels[1] = "ntower_level_1.lua"--"testmap2.lua"--"island_2.lua"--cove_1.lua"--"tower_level_1.lua"
	self._towerLevels[2] = "ntower_level_2.lua"
	self._towerLevels[3] = "ntower_level_3.lua"
	self._towerLevels[4] = "ntower_level_4.lua"
	self._towerLevels[5] = "ntower_level_5.lua"
	self._towerLevels[6] = "ntower_level_6.lua"
	self._towerLevels[7] = "ntower_level_7.lua"
	self._towerLevels[8] = "ntower_level_8.lua"
	self._towerLevels[9] = "ntower_level_9.lua"
	self._towerLevels[10] = "ntower_level_10.lua"
	self._towerLevels[11] = "victory_map.lua"


	self._portalLevels = {}
	self._portalLevels[1] = {}
	self._portalLevels[1][1] = "market_district.lua"
	self._portalLevels[1][2] = "arena_2.lua"

	self._portalLevels[2] = {}
	self._portalLevels[2][1] = "cove_1.lua"
	self._portalLevels[2][2] = "island_2.lua"

	self._portalLevels[3] = {}
	self._portalLevels[3][1] = "forest_ruins.lua"
	self._portalLevels[3][2] = "forest_ruins2.lua"

	self._portalLevels[4] = {}
	self._portalLevels[4][1] = "snow_world_1.lua"

	self._portalLevels[5] = {}
	self._portalLevels[5][1] = "snow_world_2.lua"

	self._portalLevels[6] = {}
	self._portalLevels[6][1] = "desolation_2.lua"

	self._portalLevels[7] = {}
	self._portalLevels[7][1] = "desolation_1.lua"

	self._portalLevels[8] = {}
	self._portalLevels[8][1] = "snow_world_1.lua"

	self._portalLevels[9] = {}
	self._portalLevels[9][1] = "snow_world_1.lua"

	self._portalLevels[10] = {}
	self._portalLevels[10][1] = "snow_world_1.lua"
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

	self._enemyLevelRatio = { }
	self._enemyLevelRatio[1] = 7
	self._enemyLevelRatio[2] = 7
	self._enemyLevelRatio[3] = 11
	self._enemyLevelRatio[4] = 6
	self._enemyLevelRatio[5] = 0
	self._enemyLevelRatio[6] = 5
	self._enemyLevelRatio[7] = 11
	self._enemyLevelRatio[8] = 4
	self._enemyLevelRatio[9] = 5
	self._enemyLevelRatio[10] = 7

	self._bossLevelList = { }
	self._bossLevelList[1] = false
	self._bossLevelList[2] = false
	self._bossLevelList[3] = false
	self._bossLevelList[4] = false
	self._bossLevelList[5] = true
	self._bossLevelList[6] = false
	self._bossLevelList[7] = false
	self._bossLevelList[8] = true
	self._bossLevelList[9] = false
	self._bossLevelList[10] = true


	--[[self._levelTiles[1] = "1"
	self._levelTiles[2] = "2"
	self._levelTiles[3] = "3"
	self._levelTiles[4] = "4"--]]

	for i = 1, 11 do
		self._levelTiles[i] = ""..i..""
	end
	local rndlevel = math.random(1, #self._levelTiles)
	self._diggerTable = { }
	
	self._levelType = "tower"

	self._mapObjects = {}
	self._mapFloors = { }
	----print("Dungeon level: "..Game.dungeoNLevel.."")
	self._mapFloors[1] = makeCube ( self._blockSize, "tiles/"..self._levelTiles[Game.dungeoNLevel].."/floor.png"  )
	self._mapFloors[2] = makeCube (self._blockSize, "tiles/"..self._levelTiles[Game.dungeoNLevel].."/floor2.png" )
	self._mapFloors[3] = makeCube (self._blockSize, "tiles/"..self._levelTiles[Game.dungeoNLevel].."/lava.png" )
	self._mapFloors[4] = makeCube (self._blockSize, "tiles/Houses/dirt.png" )

	self._playerSpawnPoint = makeCube( self._blockSize, "tiles/spawn_point.png" )

	self._mapWalls = { }
	local textureToUse = Game.dungeoNLevel
	--if Game.dungeonType == self._dungeonTower then
	textureToUse = 1
	--end
	self._mapWalls[1] = makeCube( self._blockSize, "tiles/"..self._levelTiles[textureToUse].."/wall.png" )
	self._mapWalls[2] = makeCube( self._blockSize, "tiles/"..self._levelTiles[textureToUse].."/wall2.png" )
	self._mapWalls[3] = makeCube( self._blockSize, "tiles/"..self._levelTiles[textureToUse].."/wall3.png" )
	self._mapWalls[4] = makeCube( self._blockSize, "tiles/"..self._levelTiles[textureToUse].."/wall4.png" )
	self._mapWalls[5] = makeCube( self._blockSize, "tiles/"..self._levelTiles[textureToUse].."/wall5.png" )
	self._mapWalls[6] = makeCube( self._blockSize, "tiles/"..self._levelTiles[textureToUse].."/wall.png" )
	self._mapWalls[7] = makeCube( self._blockSize, "tiles/"..self._levelTiles[textureToUse].."/wall5.png" )

	self._mapBuildings = { }
	self._mapBuildings[1] = makeCube( self._blockSize, "tiles/Houses/house1.png" )
	self._mapBuildings[2] = makeCube( self._blockSize, "tiles/Houses/house1_walls2.png" )
	self._mapBuildings[3] = makeCube( self._blockSize, "tiles/Houses/house1_walls.png" )
	self._mapBuildings[4] = makeCube( self._blockSize, "tiles/Houses/house1_walls3.png" )
	self._mapBuildings[5] = makeCube( self._blockSize, "tiles/Houses/house1_walls4.png" )
	self._mapBuildings[6] = makeCube( self._blockSize, "tiles/Houses/house1_walls5.png" )
	self._mapBuildings[7] = makeCube( self._blockSize, "tiles/Houses/house1_walls2.png" )
	self._mapBuildings[8] = makeCube( self._blockSize, "tiles/Houses/house1_walls2.png" )
	self._mapBuildings[9] = makeCube( self._blockSize, "tiles/Houses/house1_walls2.png" )
	self._mapBuildings[10] = makeCube( self._blockSize, "tiles/Houses/house1_walls3.png" )
	self._mapBuildings[11] = makeCube( self._blockSize, "tiles/Houses/house1_walls4.png" )
	self._mapBuildings[12] = makeCube( self._blockSize, "tiles/Houses/house1_walls2.png" )
	self._mapBuildings[13] = makeCube( self._blockSize, "tiles/Houses/house1_walls2.png" )	
	self._mapBuildings[14] = makeCube( self._blockSize, "tiles/Houses/house1_walls2.png" )
	self._mapBuildings[15] = makeCube( self._blockSize, "tiles/Houses/house2.png" )
	self._mapBuildings[16] = makeCube( self._blockSize, "tiles/Houses/house2_walls.png" )
	self._mapBuildings[17] = makeCube( self._blockSize, "tiles/Houses/house2_walls3.png" )
	self._mapBuildings[18] = makeCube( self._blockSize, "tiles/Houses/house2_walls4.png" )
	self._mapBuildings[19] = makeCube( self._blockSize, "tiles/Houses/house2_walls5.png" )
	self._mapBuildings[20] = makeCube( self._blockSize, "tiles/Houses/house2_walls2.png" )
	self._mapBuildings[21] = makeCube( self._blockSize, "tiles/Houses/house1_walls6.png" )
	self._mapBuildings[22] = makeCube( self._blockSize, "tiles/Houses/house2_walls6.png" )
	self._mapBuildings[23] = makeCube( self._blockSize, "tiles/Houses/house3.png" )
	self._mapBuildings[24] = makeCube( self._blockSize, "tiles/Houses/house3_walls.png" )
	self._mapBuildings[25] = makeCube( self._blockSize, "tiles/Houses/house3_walls3.png" )
	self._mapBuildings[26] = makeCube( self._blockSize, "tiles/Houses/house3_walls4.png" )
	self._mapBuildings[27] = makeCube( self._blockSize, "tiles/Houses/house3_walls5.png" )
	self._mapBuildings[28] = makeCube( self._blockSize, "tiles/Houses/house3_walls2.png" )
	self._mapBuildings[29] = makeCube( self._blockSize, "tiles/Houses/house3_walls6.png" )

	self._mossWall = {}
	self._mossWall[1] = makeCube( self._blockSize, "tiles/Forest/moss_wall.png" )
	self._mossWall[2] = makeCube( self._blockSize, "tiles/Forest/moss_wall2.png" )
	self._mossWall[2] = makeCube( self._blockSize, "tiles/Forest/moss_wall3.png" )

	self._mossFloor = {}
	self._mossFloor[1] = makeCube( self._blockSize, "tiles/Forest/moss_floor.png" )
	self._mossFloor[2] = makeCube( self._blockSize, "tiles/Forest/moss_floor2.png" )
	self._mossFloor[3] = makeCube( self._blockSize, "tiles/Forest/moss_floor3.png" )

	self._mossCeiling = {}
	--moss_ceiling.png
	self._mossCeiling[1] = makeCube( self._blockSize, "tiles/Forest/moss_ceiling.png" )
	
	self._signPost = {}
	self._signPost[1] = makeBox(self._blockSize, self._blockSize, 0, "tiles/Houses/sign_post.png")

	self._shipWheel = {}
	self._shipWheel[1] = makeBox(self._blockSize, self._blockSize, 0, "tiles/Docks/ship_wheel.png")

	self._columnsTower = {}
	self._columnsTower[1] = makeBox(self._blockSize, self._blockSize, 0, "tiles/column_1.png")

	self._fence ={}
	self._fence[1] = makeCube ( self._blockSize, "tiles/Houses/fence_1.png")
	self._fence[2] = makeCube ( self._blockSize, "tiles/Houses/fence_2.png")
	self._fence[3] = makeBox ( self._blockSize, self._blockSize, 5, "tiles/Houses/fence.png")

	self._treeHeight = 0
	self._trees = {}
	self._trees[1] = makeBox ( self._blockSize-10, self._blockSize+self._treeHeight, 0, "tiles/Forest/Tree1.png")
	self._trees[2] = makeBox ( self._blockSize-10, self._blockSize+self._treeHeight, 0, "tiles/Forest/Tree0.png")
	self._trees[3] = makeBox ( self._blockSize-10, self._blockSize+self._treeHeight, 0, "tiles/Forest/bush_tree.png")

	self._rockSprite = {}
	self._rockSprite[1] = makeBox ( self._blockSize, self._blockSize+self._treeHeight, 0, "tiles/Forest/rock.png")
	self._rockSprite[2] = makeBox ( self._blockSize, self._blockSize+self._treeHeight, 0, "tiles/Forest/rock_2.png")

	self._treeTrunks = {}
	self._treeTrunks[1] = makeBox ( self._blockSize, self._blockSize+self._treeHeight, 0, "tiles/Forest/tree_trunk_1.png")
	
	self._forestShacks = {}
	self._forestShacks[1] = makeCube ( self._blockSize, "tiles/Forest/forest_shack.png")
	self._forestShacks[2] = makeCube ( self._blockSize, "tiles/Forest/forest_shack2.png")
	self._forestShacks[3] = makeCube ( self._blockSize, "tiles/Forest/forest_shack3.png")
	 

	self._bench = {}
	self._bench[1] = makeBox ( self._blockSize, self._blockSize, 0, "tiles/Houses/bench.png")

	self._decorationTable = {}

	self._specialFloor = { }
	self._specialFloor[1] = makeCube ( self._blockSize, "tiles/Houses/floor.png"  )
	self._specialFloor[2] = makeCube ( self._blockSize, "tiles/portal_floor.png"  )
	self._specialFloor[3] = makeCube ( self._blockSize, "tiles/Forest/floor_1.png"  )
	self._specialFloor[4] = makeCube ( self._blockSize, "tiles/Forest/floor_2.png"  )
	self._specialFloor[5] = makeCube ( self._blockSize, "tiles/Forest/grass_1.png"  )

	self._grassSprite = {}
	self._grassSprite[1] = makeBox ( self._blockSize, self._blockSize, 0, "tiles/Forest/grass_1_sprite.png")
	self._grassSprite[2] = makeBox ( self._blockSize, self._blockSize, 0, "tiles/Forest/grass_2_sprite.png")
	
	--self._mapWalls[8] = makeCube( self._blockSize, "tiles/"..self._levelTiles[Game.dungeoNLevel].."/wall_special.png" )


	--self._caveWalls[1] = makeCube( self._blockSize, "tiles/cave/1/wall.png" )
	--self._caveWalls[1] = makeCube( self._blockSize, "tiles/cave/1/wall.png" )

	--self._mapWalls[9] = makeCube( self._blockSize, "tiles/"..self._levelTiles[1].."/wall_special_2.png")

	self._bookCases = {}
	self._bookCases[1] = makeBox(100, 100, 100, "tiles//BookCase.png" )
	self._bookCases[2] = makeBox(100, 100, 100, "tiles//BookCase2.png" )

	self._drawer = {}
	self._drawer[1] = makeBox(60, 30, 60, "tiles/Docks/drawer.png" )

	self._columns = { }
	self._columns[1] = makeBox(50, 100, 50, "tiles/"..self._levelTiles[Game.dungeoNLevel].."/wall.png" )
	self._SPECIAL_WALL = 8

	self._mapDoors = { }
	self._mapDoors[1] = makeCube( self._blockSize, "door.png" )

	self._mapCeilings = { }
	self._mapCeilings[1] = makeCube(self._blockSize, "ceiling_1.png")
	self._mapCeilings[2] = makeCube(self._blockSize, "ceiling_2.png")
	self._mapCeilings[3] = makeCube(self._blockSize, "ceiling_3.png")

	self._waterTiles = {}
	self._waterTiles[1] = makeCube(self._blockSize, "tiles/water.png")

	self._woodenWalls = { }
	self._woodenWalls[1] = makeCube(self._blockSize, "tiles/Docks/wall.png")
	self._woodenWalls[2] = makeCube(self._blockSize, "tiles/Docks/wall22.png")
	self._woodenWalls[3] = makeCube(self._blockSize, "tiles/Docks/wall.png")
	self._woodenWalls[4] = makeCube(self._blockSize, "tiles/Docks/wall2.png")
	self._woodenWalls[5] = makeCube(self._blockSize, "tiles/Docks/wall3.png")
	self._woodenWalls[6] = makeCube(self._blockSize, "tiles/Docks/wall.png")
	self._woodenWalls[7] = makeCube(self._blockSize, "tiles/Docks/wall.png")
	self._woodenWalls[8] = makeBox(100, 30, 100, "tiles/Docks/wall_small_ship.png")

	self._planks = {}
	self._planks[1] = makeBox(100, 1, 100, "tiles/Docks/planks_side.png")
	self._planks[2] = makeBox(100, 1, 100, "tiles/Docks/planks_front.png")
	self._woodenFloors = { }
	self._woodenFloors[1] = makeCube(self._blockSize, "tiles/Docks/floor.png")

	self._woodenBox = {}
	self._woodenBox[1] = makeBox(60, 40, 60, "tiles/Docks/box_texture_1.png")--makeCube(60, "tiles/Docks/box_texture_1.png")
	self._woodenBox[2] = makeBox(40, 40, 40, "tiles/Docks/box_texture_1.png")--makeCube(60, "tiles/Docks/box_texture_1.png")
	self._woodenBox[3] = makeBox(40, 40, 40, "tiles/Docks/box_texture_1.png")--makeCube(60, "tiles/Docks/box_texture_1.png")
	
	self._floorLamp = { }
	self._floorLamp[1] = makeBox(20, 20, 0, "tiles/Docks/floor_lamp.png")
	self._floorLamp[2] = makeBox(60, 40, 60, "tiles/Docks/box_texture_1.png")

	self._stairsMesh = makeBox(100, 100, 0, "stairs.png")

	self._darkness = makeCube(self._blockSize, "darkness.png")
	self._darkpatch = makeCube(self._blockSize, "darkpatch.png")

	self._planeWorld = {}
	local blueGrass = 1
	local blueTree = 2
	local blueTree2 = 3
	local sandArea = 4
	local blueWater = 5
	local house1Walls = 6
	self._planeWorld[blueGrass] = makeCube(self._blockSize, "tiles/PlaneWorld1/blue_grass.png")
	self._planeWorld[blueTree] = makeCube(self._blockSize, "tiles/PlaneWorld1/Blue_Tree.png")
	self._planeWorld[blueTree2] = makeCube(self._blockSize, "tiles/PlaneWorld1/Blue_Tree1.png")
	self._planeWorld[sandArea] = makeCube(self._blockSize, "tiles/PlaneWorld1/sand_area.png")
	self._planeWorld[blueWater] = makeCube(self._blockSize, "tiles/PlaneWorld1/water_overlay.png")
	self._planeWorld[house1Walls] = makeCube(self._blockSize, "tiles/PlaneWorld1/house1_walls.png")
	
	self._decor = {}
	self._decor[1] = makeCube ( self._blockSize, "tiles/dungeon_blocked_access.png")
	self._decor[2] = makeCube ( self._blockSize, "tiles/dungeon_blocked_access2.png")
	self._decor[3] = makeCube ( self._blockSize, "tiles/dungeon_blocked_access3.png")
	self._decor[4] = makeCube ( self._blockSize, "tiles/dungeon_blocked_access4.png")


	self._snowFloor =  makeCube(self._blockSize, "tiles/SnowWorld/snow1.png")
	self._snowTrees = {}
	self._snowTrees[1] =  makeBox ( self._blockSize-10, self._blockSize+self._treeHeight, 0, "tiles/SnowWorld/snow_bush_tree.png")
	self._snowTrees[2] =  makeBox ( self._blockSize-10, self._blockSize+self._treeHeight, 0, "tiles/SnowWorld/snow_stump.png")
	self._snowTrees[3] =  makeBox ( self._blockSize-10, self._blockSize+self._treeHeight, 0, "tiles/SnowWorld/snow_tree.png")
	self._snowTrees[4] =  makeBox ( self._blockSize-10, self._blockSize+self._treeHeight, 0, "tiles/SnowWorld/snow_tree_2.png")
	
	self._rockNew = {}
	self._rockNew[1] = makeBox ( self._blockSize-10, self._blockSize+self._treeHeight, 0, "tiles/rock_new.png")
	self._rockNew[2] = makeBox ( self._blockSize-10, self._blockSize+self._treeHeight, 0, "tiles/rock2.png")

	self._ashFloor = {}
	self._ashFloor[1] = makeCube(self._blockSize, "tiles/AshWorld/ground_1.png")
	self._ashFloor[2] = makeCube(self._blockSize, "tiles/AshWorld/ground_2.png")
	self._ashFloor[3] = makeCube(self._blockSize, "tiles/AshWorld/ground_3.png")
	self._ashFloor[4] = makeCube(self._blockSize, "tiles/AshWorld/ground_4.png")

	self._ashDecor = {}
	self._ashDecor[1] =  makeBox ( self._blockSize-10, self._blockSize+self._treeHeight, 0, "tiles/AshWorld/small_volcano.png") 
	self._ashDecor[2] =  makeBox ( self._blockSize-10, self._blockSize+self._treeHeight, 0, "tiles/AshWorld/burnt_tree.png") 
	self._ashDecor[3] =  makeBox ( self._blockSize-10, self._blockSize+self._treeHeight, 0, "tiles/AshWorld/burnt_tree2.png") 

	self._lavaFloor = {}
	self._lavaFloor[1] = makeCube(self._blockSize, "tiles/AshWorld/lava.png")
	
	self._lavaBorder = {}
	for i = 1, 4 do
		self._lavaBorder[i] = makeCube(self._blockSize, "tiles/AshWorld/lava_border_"..i..".png")
	end

	self._waterTile = { }
	self._waterTile[1] = makeCube(self._blockSize, "tiles/water2.png")

	self._hatDecor = {}
	self._hatDecor[1] = makeBox(40, 40, 0, "tiles/Docks/hat.png")

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

	self._scenaryLayer = 2

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

	self._darknessTable = {}
	self._diggerDirTable = { }
	self._diggerDirTable[1] = {0, 1} -- UP, L, D, R
	self._diggerDirTable[2] = {1, 0}
	self._diggerDirTable[3] = {0, -1}
	self._diggerDirTable[4] = {-1, 0}
	self._maxDiggers = 4
	--self:generate( )

	local portalID = Game.portalID
	--print("PortalID: "..portalID.."")
	if Game.dungeonType == self._dungeonTower  then
		self._currentMap = self._towerLevels[Game.dungeoNLevel]
	else
		if portalID == nil then
			--print("Game Dungeon Level: "..Game.dungeoNLevel.."")
			self._currentMap = self._portalLevels[Game.dungeoNLevel][1]
		else
			self._currentMap = self._portalLevels[Game.dungeoNLevel][portalID]
		end
		
	end

	
	self._cameraPointsTable = { }
	self._cameraLookAtTable = { }

	if Game.dungeonType ~= 1 then
		local skyTile = makeCube(-10000, "tiles/Menu/sky_backdrop.png")
		self._skyTileBg = image:new3DImage(skyTile, 0, -100, 0, self._mainMapLayer)
	end

	self._creatureToSpawnTable = { }

	self._spawnPointLoc = {x = nil, y = nil}
	self._stairsEnvironment = false
	--self:load( )
end

function spairs(t, order)
    -- collect the keys
    local keys = {}
    for k in pairs(t) do keys[#keys+1] = k end

    -- if order function given, sort by it by passing the table and keys a, b,
    -- otherwise just sort the keys 
    if order then
        table.sort(keys, function(a,b) return order(t, a, b) end)
    else
        table.sort(keys)
    end

    -- return the iterator function
    local i = 0
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], t[keys[i]]
        end
    end
end

function rngMap:getCameraPoints( )
	-- sort by Y
	local orderedPoints = { }
	--[[for k,v in spairs(self._cameraPointsTable, function(t,a,b) return t[b].x < t[a].x end) do
    	table.insert(orderedPoints, v)
	end--]]
	orderedPoints[1] = {}
	orderedPoints[1].x = 11
	orderedPoints[1].y = 11
	orderedPoints[1].rotY = -90

	orderedPoints[2] = {}
	orderedPoints[2].x = 20
	orderedPoints[2].y = 12
	orderedPoints[2].rotY = -180


	orderedPoints[3] = {}
	orderedPoints[3].x = 20
	orderedPoints[3].y = 21
	orderedPoints[3].rotY = -270


	orderedPoints[4] = {}
	orderedPoints[4].x = 9
	orderedPoints[4].y = 21
	orderedPoints[4].rotY = -360
	
	return orderedPoints
end

function rngMap:getCameraLookAtPoints( )
	return self._cameraLookAtTable
end

function rngMap:loadLevel( )
	self._tmxMap = dofile("map/"..self._currentMap.."")
	--self:generateFromTMX()
	--self:generateFromTMXV2( )
	if Game.optionSettings.infinite_mode == 1 and self._bossLevelList[Game.dungeoNLevel] == false then
		if Game.dungeonType == self._dungeonTower then
			self:generateRandomDungeon( )
		else
			self:generateFromTMXV2( )
		end
	else
		self:generateFromTMXV2( )
	end
end

function rngMap:loadMainMenuLevel( )
	self._tmxMap = dofile("map/main_menu_intro.lua")
	self:generateFromTMXV2(false)
end
function rngMap:_getLevelSeed( )
	return self._levelSeed
end

function rngMap:_setSeed(_seed)
	--self._levelSeed = _seed
end

function rngMap:generateRandomDungeon( )
	local seed = Game.levelSeed
	if Game.levelSeed == nil then
		Game.levelSeed = gen:init( )
	else
		Game.levelSeed = gen:init(seed)
	end
	local benchFront = 1
	local bookCase1 = 2
	local bookCase2 = 3
	local box1 = 4
	local box2 = 5
	local emptyCollision = 6
	local dirtFloor = 8
	local doorFrontLocked = 9
	local doorFront = 10
	local sideDoorLocked = 11 
	local sideDoor = 12 
	local boxDrawer = 14
	local fence = 15
	local fence2 = 16
	local smallFenceFront = 17
	local smallFenceSide = 18
	local sandFloor1 = 20
	local floorGrassDetailed = 21
	local floorLamp = 22
	local floorWood = 23
	local floorNormal = 24 
	local floorNormal2 = 25 
	local grass1 = 26
	local grassfloor1 = 27
	local grass2 = 28
	local hatSprite = 29
	local house0Window = 30
	local house0Wall = 31
	local house0Wall2 = 32
	local house0Wall3 = 33
	local house0Wall4 = 34
	local house0Wall42 = 35
	local house0Wall5 = 36
	local house0Wall6 = 37
	local house1Window = 38
	local house1Wall = 39
	local house1Wall2 = 40
	local house1Wall3 = 41
	local house1Wall4 = 42
	local house1Wall5 = 43
	local house1Wall6 = 44
	---- TODO: Implement from here
	local house2Window = 45
	local house2Wall = 46
	local house2WallWindowBroken = 47
	local house2WallBroken = 48
	local house2WallShop = 49
	local house2WallWindowTop = 50
	local house2WallEntrance = 51
	--- pause
	local key = 52
	local portal = 53 

	local sandFloor2 = 54
	local signPost = 55

	--
	local treeSprite1 = 56
	local treeSprite2 = 57
	-- pause
	local wall1Dungeon = 58
	local wall2Dungeon = 59
	local wall3Dungeon = 60
	local wall4Dungeon = 61
	local wall5Dungeon = 62

	local woodenWall1 = 63
	local woodenWall2 = 64
	local woodenWall3 = 65

	local column1 = 66
	local wallDecor1 = 67
	local wallDecor2 = 68
	local wallDecor3 = 69
	local wallDecor4 = 70
	local stairs = 71
	local benchSide = 72
	-- camera stuff
	local cameraPoint = 73
	local cameraPointRight = 75
	local cameraPointLeft = 74

	local waterTile = 76
	local wallSmallShip = 77
	local planksSide = 78
	local planksFront = 79
	
	local mossWall = 80
	local mossFloor = 81

	local rock = 82
	local treeTrunk = 83
	local rock2 = 84
	local forestShack = 85
	local bushTree = 86
	local shipWheel = 87

	local snowBush = 88
	local snowStump = 89
	local snow = 90
	local snowTree = 91
	local snowTree2 = 92
	local rockNew = 93
	local rockNew2 = 94
	local NOCTUS = 95
	local GOLEM = 96
	local boulder = 97

	local ashFloor1 = 98
	local ashFloor2 = 99
	local ashFloor3 = 100
	local ashFloor4 = 101
	local smallVolcano = 102
	local burntTree = 103
	local burntTree2 = 104

	local lavaTile = 105
	local lavaBorder = 106

	local spellBookSleep = 107

	local playerSpawnPoint = 108
	local playerSpawnPointPortal = 110
	local daeria = 111
	local doubleBarrelGun = 112
	local daeriaTentacles = 113
	local spellbookOfHealing = 114
	local ringOfHealth25 = 115
	local reaper = 116
	local randomItem = 117

	local pixieWings = 119

	local dungeonWallArrays = {}
	dungeonWallArrays[1] = wall1Dungeon
	dungeonWallArrays[2] = wall2Dungeon 
	dungeonWallArrays[3] = wall3Dungeon
	dungeonWallArrays[4] = wall4Dungeon
	dungeonWallArrays[5] = wall5Dungeon

	--gen:init( )
	local genMap = gen:_returnGeneratedMap( )
	local map = {}
	local bSpawnPoint = false
	local bPortal = false
	local bStairs = false
	local emptySpotList = {}
	for x = 1, #genMap do
		map[x] = {}
		for y = 1, #genMap[x] do
			map[x][y] = { }
			if genMap[x][y] == "#" then
				map[x][y].value = dungeonWallArrays[math.random(1, #dungeonWallArrays)]
			elseif genMap[x][y] == "s" then
				local rndWoodZone = math.random(1, 4)
				if rndWoodZone == 1 then
					map[x][y].value = box2
				else
					map[x][y].value = floorWood
				end
			elseif genMap[x][y] == "@" then

					map[x][y].value = floorNormal

			elseif genMap[x][y] == "|" then
				map[x][y].value = sideDoor
			elseif genMap[x][y] == "-" then
				map[x][y].value = doorFront
			else
				map[x][y].value = floorNormal
				local temp = {
					_x = x,
					_y = y,
				}
				table.insert(emptySpotList, temp)

			end
		end
	end

	local rndStairs = math.random(1, #emptySpotList)
	map[emptySpotList[rndStairs]._x][emptySpotList[rndStairs]._y].value = stairs
	table.remove(emptySpotList, rndStairs)

	local rndStairs = math.random(1, #emptySpotList)
	map[emptySpotList[rndStairs]._x][emptySpotList[rndStairs]._y].value = portal
	table.remove(emptySpotList, rndStairs)

	local rndStairs = math.random(1, #emptySpotList)
	map[emptySpotList[rndStairs]._x][emptySpotList[rndStairs]._y].value = playerSpawnPoint



	self._tmxMap = map
	self:generateFromTMXV2(true, self._tmxMap)	
	

end

function rngMap:loadMainMenu(_level)
	local skyTile = makeCube(-10000, "tiles/Menu/sky_backdrop.png")
	self._skyTileBg = image:new3DImage(skyTile, 0, -100, 0, self._mainMapLayer)
	self._tmxMap = dofile("map/".._level.."")
	self:generateFromTMXV2(false)
end

function rngMap:_getSkyTile( )
	return self._skyTileBg
end

function rngMap:returnDungeonTower( )
	return self._dungeonTower
end


function rngMap:returnPortalLevelType( )
	return self._portalLevelType
end

function rngMap:getEnemyLevelRatio( )
	return self._enemyLevelRatio
end

function rngMap:getPortalLevelType( )
	return self._portalLevelType
end

function rngMap:getLevelType( )
	return self._dungeonType 
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
	----print("WORLD TIME: "..Game.worldTimer.."")

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
	----print("TEMP LIFE: "..temp.life.."")
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
	----print("DIGGER TABLE SIZE: "..#self._diggerTable.."")
	if Game.worldTimer > 0.02 and #self._diggerTable < 3 then
		if self._cells < self._cellThreshold then
			self:newDigger(self._ldlX, self._ldlY )
		else 
			self:addBoundaries( )

			self._doneGenerating = true
		end
	end--]]
	----print("CELLS: "..self._cells.."")
	self:updateDecorations( )
	
end

function rngMap:newTempBiggerMap( )


	-- now, copy the contents of old map into it.
end

function rngMap:updateMapGFX( )
	local rx, ry, rz = camera:getRot( )

	if self._stairsGFX ~= nil then
		image:setRot3D(self._stairsGFX, 0, ry, 0)
	end

end

function rngMap:_dropDigger(_id)
	local v = self._diggerTable[_id]
	if v.life ~= nil then
		----print("V.Life: "..v.life.." ID: ".._id.."")
		if v.life < 1 then
			----print("DEADDDD")
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
		----print("REMOVED AT: ".._x.." | ".._y.."")
		self._map[x][y].hasWall = false
		image:removeProp(self._map[x][y].wall, self._mainMapLayer)

		self._cells = self._cells + 1
	end
	
end



function rngMap:removeFloorAt(_x, _y)
	local x = _x
	local y = _y
	if self._map[_x] ~= nil and self._map[_x][_y] ~= nil then
		----print("REMOVED AT: ".._x.." | ".._y.."")
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
		----print("REMOVED AT: ".._x.." | ".._y.."")
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
			--print(""..caveMap[x][y].."")

		end
	end

	self:addBoundaries(true)
	local _px, _py = self:returnEmptyLocations( )
	environment:createPortal(_px, _py, true)
	--print("ASTA")
	self._doneGenerating = true
end

function rngMap:generateFromTMXV2(cinematicMode, _optionalMap)
	self._mapWidth = 30
	self._mapHeight = 30
	local map ={}
	self._dungeonType = self._dungeonTower

	if _optionalMap == nil then
		for x = 1, self._mapWidth do
			map[x] = { }
			for y = 1, self._mapHeight do
				map[x][y] = { }
				map[x][y].value = self._tmxMap.layers[1].data[self._mapWidth * x + y]
			end
		end
	else
		map = _optionalMap
	end



	self._environmentTable = {} -- holds environmental objects like columns, book cases, etc
	self._emptyCellTable = {}
	emptyCellIdx = 1

	self._map = map

	local benchFront = 1
	local bookCase1 = 2
	local bookCase2 = 3
	local box1 = 4
	local box2 = 5
	local emptyCollision = 6
	local dirtFloor = 8
	local doorFrontLocked = 9
	local doorFront = 10
	local sideDoorLocked = 11 
	local sideDoor = 12 
	local boxDrawer = 14
	local fence = 15
	local fence2 = 16
	local smallFenceFront = 17
	local smallFenceSide = 18
	local sandFloor1 = 20
	local floorGrassDetailed = 21
	local floorLamp = 22
	local floorWood = 23
	local floorNormal = 24 
	local floorNormal2 = 25 
	local grass1 = 26
	local grassfloor1 = 27
	local grass2 = 28
	local hatSprite = 29
	local house0Window = 30
	local house0Wall = 31
	local house0Wall2 = 32
	local house0Wall3 = 33
	local house0Wall4 = 34
	local house0Wall42 = 35
	local house0Wall5 = 36
	local house0Wall6 = 37
	local house1Window = 38
	local house1Wall = 39
	local house1Wall2 = 40
	local house1Wall3 = 41
	local house1Wall4 = 42
	local house1Wall5 = 43
	local house1Wall6 = 44
	---- TODO: Implement from here
	local house2Window = 45
	local house2Wall = 46
	local house2WallWindowBroken = 47
	local house2WallBroken = 48
	local house2WallShop = 49
	local house2WallWindowTop = 50
	local house2WallEntrance = 51
	--- pause
	local key = 52
	local portal = 53 

	local sandFloor2 = 54
	local signPost = 55

	--
	local treeSprite1 = 56
	local treeSprite2 = 57
	-- pause
	local wall1Dungeon = 58
	local wall2Dungeon = 59
	local wall3Dungeon = 60
	local wall4Dungeon = 61
	local wall5Dungeon = 62

	local woodenWall1 = 63
	local woodenWall2 = 64
	local woodenWall3 = 65

	local column1 = 66
	local wallDecor1 = 67
	local wallDecor2 = 68
	local wallDecor3 = 69
	local wallDecor4 = 70
	local stairs = 71
	local benchSide = 72
	-- camera stuff
	local cameraPoint = 73
	local cameraPointRight = 75
	local cameraPointLeft = 74

	local waterTile = 76
	local wallSmallShip = 77
	local planksSide = 78
	local planksFront = 79
	
	local mossWall = 80
	local mossFloor = 81

	local rock = 82
	local treeTrunk = 83
	local rock2 = 84
	local forestShack = 85
	local bushTree = 86
	local shipWheel = 87

	local snowBush = 88
	local snowStump = 89
	local snow = 90
	local snowTree = 91
	local snowTree2 = 92
	local rockNew = 93
	local rockNew2 = 94
	local NOCTUS = 95
	local GOLEM = 96
	local boulder = 97

	local ashFloor1 = 98
	local ashFloor2 = 99
	local ashFloor3 = 100
	local ashFloor4 = 101
	local smallVolcano = 102
	local burntTree = 103
	local burntTree2 = 104

	local lavaTile = 105
	local lavaBorder = 106

	local spellBookSleep = 107

	local playerSpawnPoint = 108
	local playerSpawnPointPortal = 110
	local daeria = 111
	local doubleBarrelGun = 112
	local daeriaTentacles = 113
	local spellbookOfHealing = 114
	local ringOfHealth25 = 115
	local reaper = 116
	local randomItem = 117

	local pixieWings = 119

	local _porX = 1
	local _porY = 1
	local _stairsX = 1
	local _stairsY = 1
	for x = 1, #map do
		for y = 1, #map[x] do
			if map[x][y].value == benchFront then -- bench front
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._bench[1], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._scenaryLayer)
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._specialFloor[1], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))	
					image:setRot3D(map[x][y].wall, 0, 90, 0)

			elseif map[x][y].value == bookCase1 then
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._bookCases[1], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._mainMapLayer) --math.random(1, #self._mapWalls)
					image:setRot3D(map[x][y].wall, 0, 90, 0)					
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._mapFloors[1], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random	
			elseif map[x][y].value == bookCase2 then
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._bookCases[2], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._mainMapLayer) --math.random(1, #self._mapWalls)
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._mapFloors[1], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random			
			elseif map[x][y].value == box1 then
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					local boxType = math.random(1, 2)
					local heightTable = {}
					heightTable[1] = 30
					heightTable[2] = 30
					map[x][y].hasWall = false
					entity:createBoxEntity(x, y, 1)
					map[x][y].floor = image:new3DImage(self._woodenFloors[1], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))	
			elseif map[x][y].value == box2 then
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].hasWall = false
					entity:createBoxEntity(x, y, 1)
					map[x][y].floor = image:new3DImage(self._woodenFloors[1], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
			elseif map[x][y].value == emptyCollision then
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					--self._map[x][y].wall = image:new3DImage(self._bench[1], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._scenaryLayer)
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._specialFloor[1], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
			elseif map[x][y].value == dirtFloor then
					map[x][y].floor = image:new3DImage(self._mapFloors[4], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, 1)
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = true	
           			map[x][y].hasWall = false
           			self._emptyCellTable[emptyCellIdx] = {_x = x, _y = y}		
			elseif map[x][y].value == doorFrontLocked then	
					map[x][y].floor = image:new3DImage(self._mapFloors[1], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					--image:set3DIndex(map[x][y].floor, 1)
					environment:createLockedDoor(x, y, 1)	
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = true	
           			map[x][y].hasWall = true
           			self._emptyCellTable[emptyCellIdx] = {_x = x, _y = y}
					emptyCellIdx = emptyCellIdx + 1	
			elseif map[x][y].value == doorFront then
					map[x][y].floor = image:new3DImage(self._mapFloors[1], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, 1)
					environment:createDoor(x, y, 1)	
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = true	
           			map[x][y].hasWall = true
           			self._emptyCellTable[emptyCellIdx] = {_x = x, _y = y}
					emptyCellIdx = emptyCellIdx + 1
			elseif map[x][y].value == sideDoorLocked then
					map[x][y].floor = image:new3DImage(self._mapFloors[1], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, 1)
					environment:createLockedDoor(x, y, 2)	
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = true	
           			map[x][y].hasWall = true
           			self._emptyCellTable[emptyCellIdx] = {_x = x, _y = y}
			elseif 	map[x][y].value == sideDoor	then	
					map[x][y].floor = image:new3DImage(self._mapFloors[1], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, 2)
					environment:createDoor(x, y, 2)	
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = true	
           			map[x][y].hasWall = true
           			self._emptyCellTable[emptyCellIdx] = {_x = x, _y = y}
			elseif 	map[x][y].value == boxDrawer then
					map[x][y].hasWall = false
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = true
					entity:createBoxEntity(x, y, 3)
					--map[x][y].wall = image:new3DImage(self._drawer[1], x*self._blockSize, self._floorElevation+self._blockSize-35, y*self._blockSize, self._mainMapLayer) --math.random(1, #self._mapWalls)
					map[x][y].hasWall = false
					map[x][y].floor = image:new3DImage(self._mapFloors[1], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
			elseif 	map[x][y].value == fence then							
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					self:addFenceAt(x, y)
					map[x][y].floor = image:new3DImage(self._mapFloors[1], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					
			elseif 	map[x][y].value == fence2 then
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					self:addFenceAt(x, y)
					map[x][y].floor = image:new3DImage(self._mapFloors[1], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					
			elseif map[x][y].value == smallFenceFront then
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._fence[3], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._scenaryLayer)
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._specialFloor[1], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))	
					image:setRot3D(map[x][y].wall, 0, 90, 0)
			elseif map[x][y].value == smallFenceSide then
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._fence[3], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._scenaryLayer)
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._specialFloor[1], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))	
			elseif map[x][y].value == sandFloor1 then		
					map[x][y].floor = image:new3DImage(self._specialFloor[3], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = true	
           			map[x][y].hasWall = false
           			self._emptyCellTable[emptyCellIdx] = {_x = x, _y = y}
					emptyCellIdx = emptyCellIdx + 1	
			elseif map[x][y].value == floorGrassDetailed then 
					map[x][y].floor = image:new3DImage(self._specialFloor[1], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = true	
           			map[x][y].hasWall = false
           			self._emptyCellTable[emptyCellIdx] = {_x = x, _y = y}
					emptyCellIdx = emptyCellIdx + 1	
			elseif map[x][y].value == floorLamp then 			
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._floorLamp[1], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._scenaryLayer)
					entity:createBoxEntity(x, y, 4, map[x][y].wall)
					map[x][y].hasWall = false
					map[x][y].floor = image:new3DImage(self._woodenFloors[1], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					table.insert(self._decorationTable, map[x][y].wall)			
			elseif map[x][y].value == floorWood then 	-- --print WAAAH TAKE CARE HERE	####################	
					map[x][y].floor = image:new3DImage(self._woodenFloors[1], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = true	
           			map[x][y].hasWall = false
           			self._emptyCellTable[emptyCellIdx] = {_x = x, _y = y}
					emptyCellIdx = emptyCellIdx + 1
			elseif map[x][y].value == floorNormal then 
					map[x][y].floor = image:new3DImage(self._mapFloors[1], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = true	
           			map[x][y].hasWall = false
           			self._emptyCellTable[emptyCellIdx] = {_x = x, _y = y}
					emptyCellIdx = emptyCellIdx + 1	
			elseif map[x][y].value == floorNormal2 then 
					map[x][y].floor = image:new3DImage(self._mapFloors[1], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = true	
           			map[x][y].hasWall = false
           			self._emptyCellTable[emptyCellIdx] = {_x = x, _y = y}
					emptyCellIdx = emptyCellIdx + 1	
			elseif map[x][y].value == grass1 then 
					map[x][y].floor = image:new3DImage(self._specialFloor[5], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = true	
           			map[x][y].hasWall = false

					local temp = {}
					temp.gfx = image:new3DImage(self._grassSprite[1], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._scenaryLayer)
					temp.x = x
					temp.y = y 
					table.insert(self._decorationTable, temp)	

           			self._emptyCellTable[emptyCellIdx] = {_x = x, _y = y}
					emptyCellIdx = emptyCellIdx + 1	
			elseif map[x][y].value == grassfloor1 then 
					map[x][y].floor = image:new3DImage(self._specialFloor[5], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = true	
           			map[x][y].hasWall = false
           			self._emptyCellTable[emptyCellIdx] = {_x = x, _y = y}
					emptyCellIdx = emptyCellIdx + 1						
			elseif map[x][y].value == grass2 then  
					map[x][y].floor = image:new3DImage(self._specialFloor[5], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = true	
           			map[x][y].hasWall = false

					local temp = {}
					temp.gfx = image:new3DImage(self._grassSprite[2], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._scenaryLayer)
					temp.x = x
					temp.y = y 
					table.insert(self._decorationTable, temp)	

           			self._emptyCellTable[emptyCellIdx] = {_x = x, _y = y}
					emptyCellIdx = emptyCellIdx + 1		
			elseif map[x][y].value == hatSprite then  
					map[x][y].hasWall = false
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._hatDecor[1], x*self._blockSize, self._floorElevation+self._blockSize+10, y*self._blockSize, self._scenaryLayer)
					entity:createBoxEntity(x, y, 4, map[x][y].wall)
					--map[x][y].wall2 = image:new3DImage(self._floorLamp[2], x*self._blockSize, self._floorElevation+self._blockSize-30, y*self._blockSize, self._mainMapLayer)
					--map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._woodenFloors[1], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					table.insert(self._decorationTable, map[x][y].wall)	
			elseif map[x][y].value == house0Window then
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._mapBuildings[3], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._mainMapLayer) --math.random(1, #self._mapWalls)
					image:set3DIndex(map[x][y].wall, math.random(1,5))
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._mapFloors[4], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))	
			elseif map[x][y].value == house0Wall then
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._mapBuildings[2], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._mainMapLayer) --math.random(1, #self._mapWalls)
					image:set3DIndex(map[x][y].wall, math.random(1,5))
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._mapFloors[4], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))	
			elseif map[x][y].value == house0Wall2 then 		
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._mapBuildings[4], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._mainMapLayer) --math.random(1, #self._mapWalls)
					image:set3DIndex(map[x][y].wall, math.random(1,5))
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._mapFloors[4], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))			
			elseif 	map[x][y].value == 33 then 		
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._mapBuildings[5], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._mainMapLayer) --math.random(1, #self._mapWalls)
					image:set3DIndex(map[x][y].wall, math.random(1,5))
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._mapFloors[4], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))		
			elseif 	map[x][y].value == house0Wall4 then 		
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._mapBuildings[6], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._mainMapLayer) --math.random(1, #self._mapWalls)
					image:set3DIndex(map[x][y].wall, math.random(1,5))
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._mapFloors[4], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))				

			elseif 	map[x][y].value == house0Wall5 then 		
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._mapBuildings[21], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._mainMapLayer) --math.random(1, #self._mapWalls)
					image:set3DIndex(map[x][y].wall, math.random(1,5))
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._mapFloors[4], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))
			elseif 	map[x][y].value == house0Wall6 then 		
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._mapBuildings[1], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._mainMapLayer) --math.random(1, #self._mapWalls)
					image:set3DIndex(map[x][y].wall, math.random(1,5))
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._mapFloors[4], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))				
			elseif 	map[x][y].value == house1Window then 		
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._mapBuildings[16], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._mainMapLayer) --math.random(1, #self._mapWalls)
					image:set3DIndex(map[x][y].wall, math.random(1,5))
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._mapFloors[4], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))
			elseif 	map[x][y].value == house1Wall then 		
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._mapBuildings[20], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._mainMapLayer) --math.random(1, #self._mapWalls)
					image:set3DIndex(map[x][y].wall, math.random(1,5))
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._mapFloors[4], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))
			elseif 	map[x][y].value == house1Wall2 then 			
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._mapBuildings[17], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._mainMapLayer) --math.random(1, #self._mapWalls)
					image:set3DIndex(map[x][y].wall, math.random(1,5))
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._mapFloors[4], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))
			elseif 	map[x][y].value == house1Wall3 then 			
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._mapBuildings[18], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._mainMapLayer) --math.random(1, #self._mapWalls)
					image:set3DIndex(map[x][y].wall, math.random(1,5))
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._mapFloors[4], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))	
			elseif map[x][y].value == house1Wall4 then
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._mapBuildings[19], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._mainMapLayer) --math.random(1, #self._mapWalls)
					image:set3DIndex(map[x][y].wall, math.random(1,5))
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._mapFloors[4], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))		
			elseif map[x][y].value == house1Wall5 then
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._mapBuildings[22], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._mainMapLayer) --math.random(1, #self._mapWalls)
					image:set3DIndex(map[x][y].wall, math.random(1,5))
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._mapFloors[4], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))	
			elseif map[x][y].value == house1Wall6 then
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._mapBuildings[15], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._mainMapLayer) --math.random(1, #self._mapWalls)
					image:set3DIndex(map[x][y].wall, math.random(1,5))
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._mapFloors[4], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))		
			elseif map[x][y].value == house2Window then
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._mapBuildings[24], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._mainMapLayer) --math.random(1, #self._mapWalls)
					image:set3DIndex(map[x][y].wall, math.random(1,5))
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._mapFloors[4], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))		
			elseif map[x][y].value == house2Wall then
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._mapBuildings[28], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._mainMapLayer) --math.random(1, #self._mapWalls)
					image:set3DIndex(map[x][y].wall, math.random(1,5))
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._mapFloors[4], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))		
			elseif map[x][y].value == house2WallWindowBroken then
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._mapBuildings[25], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._mainMapLayer) --math.random(1, #self._mapWalls)
					image:set3DIndex(map[x][y].wall, math.random(1,5))
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._mapFloors[4], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))	
			elseif map[x][y].value == house2WallBroken then
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._mapBuildings[26], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._mainMapLayer) --math.random(1, #self._mapWalls)
					image:set3DIndex(map[x][y].wall, math.random(1,5))
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._mapFloors[4], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))				
			elseif map[x][y].value == house2WallShop then
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._mapBuildings[27], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._mainMapLayer) --math.random(1, #self._mapWalls)
					image:set3DIndex(map[x][y].wall, math.random(1,5))
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._mapFloors[4], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))		
			elseif map[x][y].value == house2WallWindowTop then
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._mapBuildings[29], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._mainMapLayer) --math.random(1, #self._mapWalls)
					image:set3DIndex(map[x][y].wall, math.random(1,5))
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._mapFloors[4], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))		
			elseif map[x][y].value == house2WallEntrance then	
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._mapBuildings[23], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._mainMapLayer) --math.random(1, #self._mapWalls)
					image:set3DIndex(map[x][y].wall, math.random(1,5))
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._mapFloors[4], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))															
			-------------------------------- 41
			elseif map[x][y].value == key then
					map[x][y].floor = image:new3DImage(self._mapFloors[1], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, 1)
					item:new(x, y, 61) -- 62 is key item
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = true	
           			map[x][y].hasWall = false
           			self._emptyCellTable[emptyCellIdx] = {_x = x, _y = y}
					emptyCellIdx = emptyCellIdx + 1		
			elseif map[x][y].value == portal then
					map[x][y].hasWall = false
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = true
					_porX = x
					_porY = y
					environment:createPortal(_porX, _porY)
					map[x][y].floor = image:new3DImage(self._specialFloor[2], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					table.insert(self._decorationTable, map[x][y].wall)
			elseif map[x][y].value == wall1Dungeon then
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._mapWalls[1], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._mainMapLayer)
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._mapFloors[1], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))	

			elseif map[x][y].value == wall2Dungeon then
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._mapWalls[2], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._mainMapLayer)
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._mapFloors[1], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))	
			elseif map[x][y].value == wall3Dungeon then
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._mapWalls[3], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._mainMapLayer)
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._mapFloors[1], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))	
			elseif map[x][y].value == wall4Dungeon then
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._mapWalls[4], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._mainMapLayer)
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._mapFloors[1], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))	
			elseif map[x][y].value == wall5Dungeon then
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._mapWalls[5], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._mainMapLayer)
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._mapFloors[1], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))	

			elseif map[x][y].value == column1 then
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._columnsTower[1], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._scenaryLayer)
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._mapFloors[1], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))	
					table.insert(self._decorationTable, map[x][y].wall)	

			elseif map[x][y].value == wallDecor1 then
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._decor[1], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._scenaryLayer)
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._mapFloors[1], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))	
			elseif map[x][y].value == wallDecor2 then
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._decor[2], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._scenaryLayer)
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._mapFloors[1], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
			elseif map[x][y].value == wallDecor3 then
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._decor[3], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._scenaryLayer)
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._mapFloors[1], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
			elseif map[x][y].value == wallDecor4 then
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._decor[4], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._scenaryLayer)
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._mapFloors[1], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
			elseif map[x][y].value == stairs then
					map[x][y].hasWall = false
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = true
           			self._emptyCellTable[emptyCellIdx] = {_x = x, _y = y}
					emptyCellIdx = emptyCellIdx + 1	
					_stairsX = x
					_stairsY = y 
					self:placeStairsAt(x, y)
					
					map[x][y].floor = image:new3DImage(self._mapFloors[1], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))	
					table.insert(self._decorationTable, map[x][y].wall)	
			elseif map[x][y].value == waterTile then
					map[x][y].floor = image:new3DImage(self._waterTiles[1], x*self._blockSize, self._floorElevation-self._blockSize/4, y*self._blockSize, self._mainMapLayer) -- set floors to be random					
					--map[x][y].floor = image:new3DImage(self._waterTiles[1],  x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer)
           			map[x][y].hasFloor = false	
           			map[x][y].hasWall = true	

			elseif map[x][y].value == woodenWall1 then
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._woodenWalls[1], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._scenaryLayer) --math.random(1, #self._mapWalls)
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._woodenFloors[1], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
			elseif map[x][y].value == woodenWall2 then
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._woodenWalls[1], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._scenaryLayer) --math.random(1, #self._mapWalls)
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._woodenFloors[1], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
			elseif map[x][y].value == woodenWall3 then 													
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._woodenWalls[2], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._scenaryLayer) --math.random(1, #self._mapWalls)
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._woodenFloors[1], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
			elseif map[x][y].value == sandFloor2 then
					map[x][y].floor = image:new3DImage(self._specialFloor[4], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = true	
           			map[x][y].hasWall = false
           			self._emptyCellTable[emptyCellIdx] = {_x = x, _y = y}
					emptyCellIdx = emptyCellIdx + 1	
			elseif map[x][y].value == signPost then
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._signPost[1], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._scenaryLayer)
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._specialFloor[1], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))	
					table.insert(self._decorationTable, map[x][y].wall)	

			elseif map[x][y].value == wallSmallShip then
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._woodenWalls[8], x*self._blockSize, self._floorElevation+self._blockSize-30, y*self._blockSize, self._mainMapLayer) --math.random(1, #self._mapWalls)
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._woodenFloors[1], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random

			elseif map[x][y].value == planksSide then
					map[x][y].floor = image:new3DImage(self._waterTiles[1], x*self._blockSize, self._floorElevation-self._blockSize/4, y*self._blockSize, self._mainMapLayer) -- set floors to be random					
           			map[x][y].hasFloor = false	
           			map[x][y].hasWall = false
					map[x][y].wall = image:new3DImage(self._planks[2], x*self._blockSize, self._floorElevation+self._blockSize-50, y*self._blockSize, self._mainMapLayer)
			elseif map[x][y].value == planksFront then
					map[x][y].floor = image:new3DImage(self._waterTiles[1], x*self._blockSize, self._floorElevation-self._blockSize/4, y*self._blockSize, self._mainMapLayer) -- set floors to be random					
           			map[x][y].hasFloor = false	
           			map[x][y].hasWall = false
					map[x][y].wall = image:new3DImage(self._planks[1], x*self._blockSize, self._floorElevation+self._blockSize-50, y*self._blockSize, self._mainMapLayer)
			elseif map[x][y].value == treeSprite1 then
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._trees[1], x*self._blockSize, self._floorElevation+self._blockSize+self._treeHeight/2, y*self._blockSize, self._scenaryLayer)
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._specialFloor[5], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))	
					table.insert(self._decorationTable, map[x][y].wall)																	
			elseif map[x][y].value == treeSprite2 then
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._trees[2], x*self._blockSize, self._floorElevation+self._blockSize+self._treeHeight/2, y*self._blockSize, self._scenaryLayer)
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._specialFloor[5], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))	
					table.insert(self._decorationTable, map[x][y].wall)		
			elseif map[x][y].value == benchSide then
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._bench[1], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._scenaryLayer)
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._specialFloor[1], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))	
					image:setRot3D(map[x][y].wall, 0, 0, 0)			
			-- planksSide			
			elseif map[x][y].value == cameraPoint then
					local temp = {}
					temp.x = x
					temp.y = y
					table.insert(self._cameraPointsTable, temp)	
					map[x][y].floor = image:new3DImage(self._mapFloors[1], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, 1)
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = true	
           			map[x][y].hasWall = false
           			self._emptyCellTable[emptyCellIdx] = {_x = x, _y = y}
					emptyCellIdx = emptyCellIdx + 1			
			elseif map[x][y].value == cameraPointLeft then
					local temp = { }
					temp.x = x
					temp.y = y 
					temp.rotY = 90
					temp.rotX = 0
					temp.rotZ = 0	
					table.insert(self._cameraLookAtTable, temp)		
			elseif map[x][y].value == cameraPointRight then
					local temp = { }
					temp.x = x
					temp.y = y 
					temp.rotY = 0
					temp.rotX = 0
					temp.rotZ = 0	
					table.insert(self._cameraLookAtTable, temp)	
			elseif map[x][y].value == mossWall then
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._mossWall[math.random(1, #self._mossWall)], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._mainMapLayer)
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._mapFloors[1], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))	
			elseif map[x][y].value == mossFloor then
					map[x][y].hasWall = false
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].hasWall = false
					map[x][y].floor = image:new3DImage(self._mossFloor[math.random(1, #self._mossFloor)], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))	
           			self._emptyCellTable[emptyCellIdx] = {_x = x, _y = y}
					emptyCellIdx = emptyCellIdx + 1	
					--map[x][y].wall2 = image:new3DImage(self._mossCeiling[1], x*self._blockSize, self._floorElevation+self._blockSize*2, y*self._blockSize, self._mainMapLayer) -- set floors to be random
			elseif map[x][y].value == rock then
					--_rockSprite
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._rockSprite[1], x*self._blockSize, self._floorElevation+self._blockSize+self._treeHeight/2, y*self._blockSize, self._scenaryLayer)
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._specialFloor[5], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))	
					table.insert(self._decorationTable, map[x][y].wall)	
			elseif map[x][y].value == treeTrunk then
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._treeTrunks[1], x*self._blockSize, self._floorElevation+self._blockSize+self._treeHeight/2, y*self._blockSize, self._scenaryLayer)
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._specialFloor[5], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))	
					table.insert(self._decorationTable, map[x][y].wall)	
			elseif map[x][y].value == rock2 then
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._rockSprite[2], x*self._blockSize, self._floorElevation+self._blockSize+self._treeHeight/2, y*self._blockSize, self._scenaryLayer)
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._specialFloor[5], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))	
					table.insert(self._decorationTable, map[x][y].wall)		
			elseif map[x][y].value == forestShack then
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._forestShacks[math.random(1, #self._forestShacks)], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._mainMapLayer) --math.random(1, #self._mapWalls)
					image:set3DIndex(map[x][y].wall, math.random(1,5))
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._specialFloor[5], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))						
			elseif map[x][y].value == bushTree then
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._trees[3], x*self._blockSize, self._floorElevation+self._blockSize+self._treeHeight/2, y*self._blockSize, self._scenaryLayer)
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._specialFloor[5], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))	
					table.insert(self._decorationTable, map[x][y].wall)		
			elseif map[x][y].value == shipWheel then
			--_shipWheel
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._shipWheel[1], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._scenaryLayer)
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._woodenFloors[1], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					table.insert(self._decorationTable, map[x][y].wall)		


			elseif map[x][y].value == snowBush then
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._snowTrees[1], x*self._blockSize, self._floorElevation+self._blockSize+self._treeHeight/2, y*self._blockSize, self._scenaryLayer)
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._snowFloor, x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))	
					table.insert(self._decorationTable, map[x][y].wall)	
--[[
	self._snowTrees[1] =  makeBox ( self._blockSize-10, self._blockSize+self._treeHeight, 0, "tiles/SnowWorld/snow_bush_tree.png")
	self._snowTrees[2] =  makeBox ( self._blockSize-10, self._blockSize+self._treeHeight, 0, "tiles/SnowWorld/snow_stump.png")
	self._snowTrees[3] =  makeBox ( self._blockSize-10, self._blockSize+self._treeHeight, 0, "tiles/SnowWorld/snow_tree.png")
	self._snowTrees[4] =  makeBox ( self._blockSize-10, self._blockSize+self._treeHeight, 0, "tiles/SnowWorld/snow_tree_2.png")	
]]
			elseif map[x][y].value == snowStump then
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._snowTrees[2], x*self._blockSize, self._floorElevation+self._blockSize+self._treeHeight/2, y*self._blockSize, self._scenaryLayer)
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._snowFloor, x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))	
					table.insert(self._decorationTable, map[x][y].wall)	
			elseif map[x][y].value == snow then
					map[x][y].floor = image:new3DImage(self._snowFloor, x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = true	
           			map[x][y].hasWall = false
           			self._emptyCellTable[emptyCellIdx] = {_x = x, _y = y}
					emptyCellIdx = emptyCellIdx + 1	
			elseif map[x][y].value == snowTree then
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._snowTrees[3], x*self._blockSize, self._floorElevation+self._blockSize+self._treeHeight/2, y*self._blockSize, self._scenaryLayer)
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._snowFloor, x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))	
					table.insert(self._decorationTable, map[x][y].wall)	
			elseif map[x][y].value == snowTree2 then
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._snowTrees[4], x*self._blockSize, self._floorElevation+self._blockSize+self._treeHeight/2, y*self._blockSize, self._scenaryLayer)
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._snowFloor, x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))	
					table.insert(self._decorationTable, map[x][y].wall)		
			elseif map[x][y].value == rockNew then
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._rockNew[1], x*self._blockSize, self._floorElevation+self._blockSize+self._treeHeight/2, y*self._blockSize, self._scenaryLayer)
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._snowFloor, x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					table.insert(self._decorationTable, map[x][y].wall)		
			elseif map[x][y].value == rockNew2 then
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._rockNew[2], x*self._blockSize, self._floorElevation+self._blockSize+self._treeHeight/2, y*self._blockSize, self._scenaryLayer)
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._snowFloor, x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					table.insert(self._decorationTable, map[x][y].wall)		
			elseif map[x][y].value == NOCTUS then -- VAMPIRE
					map[x][y].floor = image:new3DImage(self._snowFloor, x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = true	
           			map[x][y].hasWall = false
           			self._emptyCellTable[emptyCellIdx] = {_x = x, _y = y}
					emptyCellIdx = emptyCellIdx + 1	
					--entity:newCreature(x, y, 19, false)			
					local temp = { 
						_x = x,
						_y = y,
						_type = 20,
						_bool = false,
					}
					table.insert(self._creatureToSpawnTable, temp)
			elseif map[x][y].value == GOLEM then -- VAMPIRE
					map[x][y].floor = image:new3DImage(self._mapFloors[1], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = true	
           			map[x][y].hasWall = false
           			self._emptyCellTable[emptyCellIdx] = {_x = x, _y = y}
					emptyCellIdx = emptyCellIdx + 1	
					--entity:newCreature(x, y, 19, false)			
					local temp = { 
						_x = x,
						_y = y,
						_type = 21,
						_bool = false,
					}
					table.insert(self._creatureToSpawnTable, temp)			
			elseif map[x][y].value == boulder then
					map[x][y].floor = image:new3DImage(self._mapFloors[1], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = true	
           			map[x][y].hasWall = false
           			self._emptyCellTable[emptyCellIdx] = {_x = x, _y = y}
					emptyCellIdx = emptyCellIdx + 1	
					item:new(x, y, 70)
			elseif map[x][y].value == ashFloor1 then
					map[x][y].floor = image:new3DImage(self._ashFloor[1], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = true	
           			map[x][y].hasWall = false
           			self._emptyCellTable[emptyCellIdx] = {_x = x, _y = y}
					emptyCellIdx = emptyCellIdx + 1	
			elseif map[x][y].value == ashFloor2 then
					map[x][y].floor = image:new3DImage(self._ashFloor[2], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = true	
           			map[x][y].hasWall = false
           			self._emptyCellTable[emptyCellIdx] = {_x = x, _y = y}
					emptyCellIdx = emptyCellIdx + 1	
			elseif map[x][y].value == ashFloor3 then
					map[x][y].floor = image:new3DImage(self._ashFloor[3], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = true	
           			map[x][y].hasWall = false
           			self._emptyCellTable[emptyCellIdx] = {_x = x, _y = y}
					emptyCellIdx = emptyCellIdx + 1	
			elseif map[x][y].value == ashFloor4 then
					map[x][y].floor = image:new3DImage(self._ashFloor[4], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = true	
           			map[x][y].hasWall = false
           			self._emptyCellTable[emptyCellIdx] = {_x = x, _y = y}
					emptyCellIdx = emptyCellIdx + 1					
				-------------------------------- 
				elseif map[x][y].value == smallVolcano then
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._ashDecor[1], x*self._blockSize, self._floorElevation+self._blockSize+self._treeHeight/2, y*self._blockSize, self._scenaryLayer)
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._ashFloor[1], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					table.insert(self._decorationTable, map[x][y].wall)	
				elseif map[x][y].value == burntTree then
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._ashDecor[2], x*self._blockSize, self._floorElevation+self._blockSize+self._treeHeight/2, y*self._blockSize, self._scenaryLayer)
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._ashFloor[1], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					table.insert(self._decorationTable, map[x][y].wall)	
				elseif map[x][y].value == burntTree2 then
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._ashDecor[3], x*self._blockSize, self._floorElevation+self._blockSize+self._treeHeight/2, y*self._blockSize, self._scenaryLayer)
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._ashFloor[1], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					table.insert(self._decorationTable, map[x][y].wall)	
				elseif map[x][y].value == lavaTile then
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					--map[x][y].wall = image:new3DImage(self._ashDecor[1], x*self._blockSize, self._floorElevation+self._blockSize+self._treeHeight/2, y*self._blockSize, self._scenaryLayer)
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._lavaFloor[1], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					--table.insert(self._decorationTable, map[x][y].wall)	
				elseif map[x][y].value == lavaBorder then
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._lavaBorder[math.random(1, #self._lavaBorder)], x*self._blockSize, self._floorElevation+self._blockSize+self._treeHeight/2, y*self._blockSize, self._scenaryLayer)
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._ashFloor[1], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					--table.insert(self._decorationTable, map[x][y].wall)		
				elseif map[x][y].value == spellBookSleep then
					map[x][y].floor = image:new3DImage(self._specialFloor[1], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = true	
           			map[x][y].hasWall = false
           			self._emptyCellTable[emptyCellIdx] = {_x = x, _y = y}
					emptyCellIdx = emptyCellIdx + 1		
					item:new(x, y, 72)			
				elseif map[x][y].value == playerSpawnPoint then
					map[x][y].floor = image:new3DImage(self._playerSpawnPoint, x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = true	
           			map[x][y].hasWall = false
					self._spawnPointLoc.x = x
					self._spawnPointLoc.y = y
				elseif map[x][y].value == playerSpawnPointPortal then
					map[x][y].floor = image:new3DImage(self._specialFloor[2], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = true	
           			map[x][y].hasWall = false
					self._spawnPointLoc.x = x
					self._spawnPointLoc.y = y
				elseif map[x][y].value == daeria then
					map[x][y].floor = image:new3DImage(self._mapFloors[1], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = true	
           			map[x][y].hasWall = false
           			self._emptyCellTable[emptyCellIdx] = {_x = x, _y = y}
					emptyCellIdx = emptyCellIdx + 1	
					--entity:newCreature(x, y, 19, false)			
					local temp = { 
						_x = x,
						_y = y,
						_type = 22,
						_bool = false,
					}
					table.insert(self._creatureToSpawnTable, temp)		
				elseif map[x][y].value == doubleBarrelGun then
					map[x][y].floor = image:new3DImage(self._mapFloors[1], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, 1)
					item:new(x, y, 92) 
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = true	
           			map[x][y].hasWall = false
           			self._emptyCellTable[emptyCellIdx] = {_x = x, _y = y}
					emptyCellIdx = emptyCellIdx + 1	
				elseif map[x][y].value == daeriaTentacles then
					map[x][y].floor = image:new3DImage(self._mapFloors[1], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = true	
           			map[x][y].hasWall = false
           			self._emptyCellTable[emptyCellIdx] = {_x = x, _y = y}
					emptyCellIdx = emptyCellIdx + 1	
					local temp = { 
						_x = x,
						_y = y,
						_type = 23,
						_bool = false,
					}
					table.insert(self._creatureToSpawnTable, temp)	
				elseif map[x][y].value == spellbookOfHealing then
					map[x][y].floor = image:new3DImage(self._mapFloors[1], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, 1)
					item:new(x, y, 93) 
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = true	
           			map[x][y].hasWall = false
           			self._emptyCellTable[emptyCellIdx] = {_x = x, _y = y}
					emptyCellIdx = emptyCellIdx + 1		
				elseif map[x][y].value == ringOfHealth25 then
					map[x][y].floor = image:new3DImage(self._mapFloors[1], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, 1)
					item:new(x, y, 91) 
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = true	
           			map[x][y].hasWall = false
           			self._emptyCellTable[emptyCellIdx] = {_x = x, _y = y}
					emptyCellIdx = emptyCellIdx + 1		
				elseif map[x][y].value == reaper then
					map[x][y].floor = image:new3DImage(self._mapFloors[1], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = true	
           			map[x][y].hasWall = false
           			self._emptyCellTable[emptyCellIdx] = {_x = x, _y = y}
					emptyCellIdx = emptyCellIdx + 1	
					local temp = { 
						_x = x,
						_y = y,
						_type = 24,
						_bool = false,
					}
					table.insert(self._creatureToSpawnTable, temp)		
				elseif map[x][y].value == 117 then
					map[x][y].floor = image:new3DImage(self._mapFloors[1], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, 1)
					item:new(x, y, math.random(46, 94)) 
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = true	
           			map[x][y].hasWall = false
           			self._emptyCellTable[emptyCellIdx] = {_x = x, _y = y}
					emptyCellIdx = emptyCellIdx + 1		
				elseif map[x][y].value == 118 then -- wizard	
					map[x][y].floor = image:new3DImage(self._lavaFloor[1], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = true	
           			map[x][y].hasWall = false
           			self._emptyCellTable[emptyCellIdx] = {_x = x, _y = y}
					emptyCellIdx = emptyCellIdx + 1	
					local temp = { 
						_x = x,
						_y = y,
						_type = 25,
						_bool = false,
					}
					table.insert(self._creatureToSpawnTable, temp)		
				elseif map[x][y].value == pixieWings then
					map[x][y].floor = image:new3DImage(self._mapFloors[1], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, 1)
					item:new(x, y, 34) 
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = true	
           			map[x][y].hasWall = false
           			self._emptyCellTable[emptyCellIdx] = {_x = x, _y = y}
					emptyCellIdx = emptyCellIdx + 1		
				elseif map[x][y].value == 120 then
					map[x][y].hasWall = false
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = true
					_porX = x
					_porY = y
					environment:createSpecialPortal(_porX, _porY)
					map[x][y].floor = image:new3DImage(self._specialFloor[2], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					table.insert(self._decorationTable, map[x][y].wall)																				
			else 

			end


		end
	end	

	if cinematicMode == nil or cinematicMode == true then
		self._doneGenerating = true
	end
end

function rngMap:getSpawnPointLoc( )
	return self._spawnPointLoc.x, self._spawnPointLoc.y
end

function rngMap:getCreatureToSpawnTable( )
	return self._creatureToSpawnTable
end

function rngMap:generateFromTMX( )
	self._mapWidth = 30
	self._mapHeight = 30
	local map ={}
	self._dungeonType = self._dungeonTower
	for x = 1, self._mapWidth do
		map[x] = { }
		for y = 1, self._mapHeight do
			map[x][y] = { }
            map[x][y].value = self._tmxMap.layers[1].data[self._mapWidth * x + y]
		end
	end

	self._environmentTable = {} -- holds environmental objects like columns, book cases, etc
	self._emptyCellTable = {}
	emptyCellIdx = 1
	self._map = map

	--[[
		Tiles: 
		20 - fence
		21 - grass
		19 - ground
		22 - house1 walls
		23 - house1 walls 1

	]]
	local _porX = 1
	local _porY = 1
	local _stairsX = 1
	local _stairsY = 1
	for x = 1, #map do
		for y = 1, #map[x] do
			
			if map[x][y].value == 4 then
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._mapWalls[math.random(1, #self._mapWalls)], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._mainMapLayer) --math.random(1, #self._mapWalls)
					image:set3DIndex(map[x][y].wall, math.random(1,5))
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._mapFloors[math.random(1, 2)], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))
			elseif map[x][y].value == 21 or map[x][y].value == 2 then
					map[x][y].floor = image:new3DImage(self._specialFloor[1], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = true	
           			map[x][y].hasWall = false
           			self._emptyCellTable[emptyCellIdx] = {_x = x, _y = y}
					emptyCellIdx = emptyCellIdx + 1
			elseif map[x][y].value == 11 then
					map[x][y].floor = image:new3DImage(self._mapFloors[math.random(1, #self._mapFloors)], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, 1)
					environment:createDoor(x, y, 1)	
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = true	
           			map[x][y].hasWall = true
           			self._emptyCellTable[emptyCellIdx] = {_x = x, _y = y}
					emptyCellIdx = emptyCellIdx + 1	
			elseif map[x][y].value == 9 then
					map[x][y].floor = image:new3DImage(self._waterTile[1],  x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer)
           			map[x][y].hasFloor = false	
           			map[x][y].hasWall = true
			elseif map[x][y].value == 12 then
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = true	
           			map[x][y].hasWall = false	
			elseif map[x][y].value == 14 then
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._mapBuildings[1], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._mainMapLayer) --math.random(1, #self._mapWalls)
					image:set3DIndex(map[x][y].wall, math.random(1,5))
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._mapFloors[4], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))
			elseif map[x][y].value == 19 then
					map[x][y].floor = image:new3DImage(self._mapFloors[4], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, 1)
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = true	
           			map[x][y].hasWall = false
           			self._emptyCellTable[emptyCellIdx] = {_x = x, _y = y}
			elseif map[x][y].value == 16 then
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._mapBuildings[math.random(2, #self._mapBuildings)], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._mainMapLayer) --math.random(1, #self._mapWalls)
					image:set3DIndex(map[x][y].wall, math.random(1,5))
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._mapFloors[4], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))
			elseif map[x][y].value == 20 then
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					self:addFenceAt(x, y)
			elseif map[x][y].value == 22 then -- house 1 walls
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._mapBuildings[3], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._mainMapLayer) --math.random(1, #self._mapWalls)
					image:set3DIndex(map[x][y].wall, math.random(1,5))
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._mapFloors[4], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))	
			elseif map[x][y].value == 23 then -- house 1 walls2
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._mapBuildings[2], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._mainMapLayer) --math.random(1, #self._mapWalls)
					image:set3DIndex(map[x][y].wall, math.random(1,5))
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._mapFloors[4], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))	
			elseif map[x][y].value == 24 then -- house 1 walls 2
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._mapBuildings[2], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._mainMapLayer) --math.random(1, #self._mapWalls)
					image:set3DIndex(map[x][y].wall, math.random(1,5))
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._mapFloors[4], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))		
			elseif map[x][y].value == 25 then -- house 1 walls 3
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._mapBuildings[4], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._mainMapLayer) --math.random(1, #self._mapWalls)
					image:set3DIndex(map[x][y].wall, math.random(1,5))
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._mapFloors[4], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))
			elseif map[x][y].value == 26 then -- house 1 walls 4
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._mapBuildings[5], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._mainMapLayer) --math.random(1, #self._mapWalls)
					image:set3DIndex(map[x][y].wall, math.random(1,5))
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._mapFloors[4], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))
			elseif map[x][y].value == 27 then -- house 1 walls 5
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._mapBuildings[6], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._mainMapLayer) --math.random(1, #self._mapWalls)
					image:set3DIndex(map[x][y].wall, math.random(1,5))
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._mapFloors[4], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))
			elseif map[x][y].value == 29 then -- house 1
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._mapBuildings[1], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._mainMapLayer) --math.random(1, #self._mapWalls)
					image:set3DIndex(map[x][y].wall, math.random(1,5))
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._mapFloors[4], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))
			elseif map[x][y].value == 30 then -- house 2 walls
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._mapBuildings[16], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._mainMapLayer) --math.random(1, #self._mapWalls)
					image:set3DIndex(map[x][y].wall, math.random(1,5))
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._mapFloors[4], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))
			elseif map[x][y].value == 31 then -- house 2 walls 2
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._mapBuildings[20], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._mainMapLayer) --math.random(1, #self._mapWalls)
					image:set3DIndex(map[x][y].wall, math.random(1,5))
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._mapFloors[4], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))
			elseif map[x][y].value == 32 then -- house 2 walls 3
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._mapBuildings[17], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._mainMapLayer) --math.random(1, #self._mapWalls)
					image:set3DIndex(map[x][y].wall, math.random(1,5))
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._mapFloors[4], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))
			elseif map[x][y].value == 33 then -- house 2 walls 4
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._mapBuildings[18], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._mainMapLayer) --math.random(1, #self._mapWalls)
					image:set3DIndex(map[x][y].wall, math.random(1,5))
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._mapFloors[4], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))	
			elseif map[x][y].value == 34 then -- house 2 walls 5
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._mapBuildings[19], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._mainMapLayer) --math.random(1, #self._mapWalls)
					image:set3DIndex(map[x][y].wall, math.random(1,5))
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._mapFloors[4], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))	
			elseif map[x][y].value == 35 then -- house 2 walls 6
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._mapBuildings[22], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._mainMapLayer) --math.random(1, #self._mapWalls)
					image:set3DIndex(map[x][y].wall, math.random(1,5))
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._mapFloors[4], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))		
			elseif map[x][y].value == 36 then -- house 2
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._mapBuildings[15], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._mainMapLayer) --math.random(1, #self._mapWalls)
					image:set3DIndex(map[x][y].wall, math.random(1,5))
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._mapFloors[4], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))	
			elseif map[x][y].value == 28 then -- house 1 wall 6
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._mapBuildings[21], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._mainMapLayer) --math.random(1, #self._mapWalls)
					image:set3DIndex(map[x][y].wall, math.random(1,5))
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._mapFloors[4], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))
			elseif map[x][y].value == 37 then -- house 3 wall 
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._mapBuildings[24], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._mainMapLayer) --math.random(1, #self._mapWalls)
					image:set3DIndex(map[x][y].wall, math.random(1,5))
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._mapFloors[4], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))	
			elseif map[x][y].value == 38 then -- house 3 wall 2
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._mapBuildings[28], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._mainMapLayer) --math.random(1, #self._mapWalls)
					image:set3DIndex(map[x][y].wall, math.random(1,5))
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._mapFloors[4], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))	
			elseif map[x][y].value == 39 then -- house 3 wall 3
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._mapBuildings[25], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._mainMapLayer) --math.random(1, #self._mapWalls)
					image:set3DIndex(map[x][y].wall, math.random(1,5))
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._mapFloors[4], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))		
			elseif map[x][y].value == 40 then -- house 3 wall 4
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._mapBuildings[26], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._mainMapLayer) --math.random(1, #self._mapWalls)
					image:set3DIndex(map[x][y].wall, math.random(1,5))
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._mapFloors[4], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))		
			elseif map[x][y].value == 41 then -- house 3 wall 5
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._mapBuildings[27], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._mainMapLayer) --math.random(1, #self._mapWalls)
					image:set3DIndex(map[x][y].wall, math.random(1,5))
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._mapFloors[4], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))	
			elseif map[x][y].value == 42 then -- house 3 wall 5
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._mapBuildings[29], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._mainMapLayer) --math.random(1, #self._mapWalls)
					image:set3DIndex(map[x][y].wall, math.random(1,5))
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._mapFloors[4], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))		
			elseif map[x][y].value == 43 then -- house 3 wall 5
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._mapBuildings[23], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._mainMapLayer) --math.random(1, #self._mapWalls)
					image:set3DIndex(map[x][y].wall, math.random(1,5))
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._mapFloors[4], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))		
			elseif map[x][y].value == 44 then -- sign post
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._signPost[1], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._scenaryLayer)
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._specialFloor[1], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))	
					table.insert(self._decorationTable, map[x][y].wall)	
			elseif map[x][y].value == 45 then
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._fence[3], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._scenaryLayer)
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._specialFloor[1], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))	
			elseif map[x][y].value == 46 then
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._fence[3], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._scenaryLayer)
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._specialFloor[1], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))	
					image:setRot3D(map[x][y].wall, 0, 90, 0)
					--table.insert(self._decorationTable, map[x][y].wall)	
			-- 47/ 48
			elseif map[x][y].value == 47 then --bench front
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._bench[1], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._scenaryLayer)
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._specialFloor[1], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))	
					image:setRot3D(map[x][y].wall, 0, 90, 0)
			elseif map[x][y].value == 48 then --bench side
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._bench[1], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._scenaryLayer)
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._specialFloor[1], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))	
					--image:setRot3D(map[x][y].wall, 0, 90, 0)	
			elseif map[x][y].value == 49 then --Empty/CollisionTile
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					--self._map[x][y].wall = image:new3DImage(self._bench[1], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._scenaryLayer)
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._specialFloor[1], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))	
					--image:setRot3D(map[x][y].wall, 0, 90, 0)
			elseif map[x][y].value == 52 or map[x][y].value == 53 then --tower_ground
					map[x][y].floor = image:new3DImage(self._mapFloors[1], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = true	
           			map[x][y].hasWall = false
           			self._emptyCellTable[emptyCellIdx] = {_x = x, _y = y}
					emptyCellIdx = emptyCellIdx + 1	
			elseif map[x][y].value == 54 then --Empty/CollisionTile
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._mapWalls[math.random(1, #self._mapWalls)], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._mainMapLayer)
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._mapFloors[1], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))	
					--image:setRot3D(map[x][y].wall, 0, 90, 0)		
			elseif map[x][y].value == 59 then
					map[x][y].floor = image:new3DImage(self._mapFloors[1], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, 1)
					environment:createDoor(x, y, 1)	
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = true	
           			map[x][y].hasWall = true
           			self._emptyCellTable[emptyCellIdx] = {_x = x, _y = y}
					emptyCellIdx = emptyCellIdx + 1		
			elseif map[x][y].value == 60 then
					map[x][y].floor = image:new3DImage(self._mapFloors[1], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, 2)
					environment:createDoor(x, y, 2)	
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = true	
           			map[x][y].hasWall = true
           			self._emptyCellTable[emptyCellIdx] = {_x = x, _y = y}   
					emptyCellIdx = emptyCellIdx + 1		
			elseif map[x][y].value == 61 then
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._columnsTower[1], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._scenaryLayer)
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._mapFloors[1], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))	
					table.insert(self._decorationTable, map[x][y].wall)	
			elseif map[x][y].value == 62 then
					map[x][y].hasWall = false
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = true
           			self._emptyCellTable[emptyCellIdx] = {_x = x, _y = y}
					emptyCellIdx = emptyCellIdx + 1	
					_stairsX = x
					_stairsY = y 
					self:placeStairsAt(x, y)
					map[x][y].floor = image:new3DImage(self._mapFloors[1], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))	
					table.insert(self._decorationTable, map[x][y].wall)	
			elseif map[x][y].value == 63 then
					map[x][y].hasWall = false
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = true
					_porX = x
					_porY = y
					environment:createPortal(_porX, _porY)
					map[x][y].floor = image:new3DImage(self._specialFloor[2], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					table.insert(self._decorationTable, map[x][y].wall)								
			elseif map[x][y].value == 64 then
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._trees[1], x*self._blockSize, self._floorElevation+self._blockSize+self._treeHeight/2, y*self._blockSize, self._scenaryLayer)
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._specialFloor[5], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))	
					table.insert(self._decorationTable, map[x][y].wall)		
			elseif map[x][y].value == 65 then
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._trees[2], x*self._blockSize, self._floorElevation+self._blockSize+self._treeHeight/2, y*self._blockSize, self._scenaryLayer)
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._specialFloor[5], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))	
					table.insert(self._decorationTable, map[x][y].wall)	
			elseif map[x][y].value == 66 then
					map[x][y].floor = image:new3DImage(self._specialFloor[3], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = true	
           			map[x][y].hasWall = false
           			self._emptyCellTable[emptyCellIdx] = {_x = x, _y = y}
					emptyCellIdx = emptyCellIdx + 1	
			elseif map[x][y].value == 67 then
					map[x][y].floor = image:new3DImage(self._specialFloor[4], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = true	
           			map[x][y].hasWall = false
           			self._emptyCellTable[emptyCellIdx] = {_x = x, _y = y}
					emptyCellIdx = emptyCellIdx + 1		
			elseif map[x][y].value == 68 then
					map[x][y].floor = image:new3DImage(self._specialFloor[5], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = true	
           			map[x][y].hasWall = false
					local rMath = math.random(1, 5)
					if rMath == 3 then
						local grassSprite = image:new3DImage(self._grassSprite[math.random(1,2)], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._scenaryLayer)
						table.insert(self._decorationTable, grassSprite)	
					end
           			self._emptyCellTable[emptyCellIdx] = {_x = x, _y = y}
					emptyCellIdx = emptyCellIdx + 1	
			elseif map[x][y].value == 69 then
					map[x][y].floor = image:new3DImage(self._mapFloors[1], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, 1)
					environment:createLockedDoor(x, y, 1)	
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = true	
           			map[x][y].hasWall = true
           			self._emptyCellTable[emptyCellIdx] = {_x = x, _y = y}
					emptyCellIdx = emptyCellIdx + 1		
			elseif map[x][y].value == 70 then
					map[x][y].floor = image:new3DImage(self._mapFloors[1], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, 1)
					environment:createLockedDoor(x, y, 2)	
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = true	
           			map[x][y].hasWall = true
           			self._emptyCellTable[emptyCellIdx] = {_x = x, _y = y}
					emptyCellIdx = emptyCellIdx + 1		
			elseif map[x][y].value == 71 then
					map[x][y].floor = image:new3DImage(self._mapFloors[1], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, 1)
					item:new(x, y, 62) -- 62 is key item
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = true	
           			map[x][y].hasWall = false
           			self._emptyCellTable[emptyCellIdx] = {_x = x, _y = y}
					emptyCellIdx = emptyCellIdx + 1		
			elseif map[x][y].value == 72 then
					map[x][y].floor = image:new3DImage(self._waterTiles[1], x*self._blockSize, self._floorElevation-self._blockSize/4, y*self._blockSize, self._mainMapLayer) -- set floors to be random
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = true	
           			map[x][y].hasWall = true
			elseif map[x][y].value == 73 then
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._woodenWalls[2], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._scenaryLayer) --math.random(1, #self._mapWalls)
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._woodenFloors[1], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
			elseif map[x][y].value == 74 then
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._woodenWalls[math.random(3, 7)], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._mainMapLayer) --math.random(1, #self._mapWalls)
					image:set3DIndex(map[x][y].wall, math.random(1,5))
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._woodenFloors[1], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))	
			elseif map[x][y].value == 75 then
					map[x][y].floor = image:new3DImage(self._woodenFloors[1], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = true	
           			map[x][y].hasWall = false
           			self._emptyCellTable[emptyCellIdx] = {_x = x, _y = y}
					emptyCellIdx = emptyCellIdx + 1	
			elseif map[x][y].value == 76 then
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._woodenFloors[1], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
			elseif map[x][y].value == 77 then
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					local boxType = math.random(1, 2)
					local heightTable = {}
					heightTable[1] = 30
					heightTable[2] = 30
					--map[x][y].wall = image:new3DImage(self._woodenBox[boxType], x*self._blockSize, self._floorElevation+self._blockSize-heightTable[boxType], y*self._blockSize, self._mainMapLayer) --math.random(1, #self._mapWalls)
					--image:set3DIndex(map[x][y].wall, math.random(1,5))
					--[[if math.random(1, 4) == 3 then
						boxType = math.random(1, 2)
						map[x][y].wall2 = image:new3DImage(self._woodenBox[boxType], x*self._blockSize, self._floorElevation+self._blockSize+heightTable[boxType]/4, y*self._blockSize, self._mainMapLayer) --math.random(1, #self._mapWalls)	
					end--]]
					--image:setRot3D(map[x][y].wall, 0, math.random(1, 4)*90, 0 )
					map[x][y].hasWall = false
					entity:createBoxEntity(x, y, 1)
					map[x][y].floor = image:new3DImage(self._woodenFloors[1], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))		
			elseif map[x][y].value == 78 then
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._floorLamp[1], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._scenaryLayer)
					map[x][y].wall2 = image:new3DImage(self._floorLamp[2], x*self._blockSize, self._floorElevation+self._blockSize-30, y*self._blockSize, self._mainMapLayer)
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._woodenFloors[1], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					table.insert(self._decorationTable, map[x][y].wall)	
			elseif map[x][y].value == 79 then
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					local boxType = math.random(1, 2)
					local heightTable = {}
					heightTable[1] = 30
					heightTable[2] = 30
					--map[x][y].wall = image:new3DImage(self._woodenBox[boxType], x*self._blockSize, self._floorElevation+self._blockSize-heightTable[boxType], y*self._blockSize, self._mainMapLayer) --math.random(1, #self._mapWalls)
					--image:set3DIndex(map[x][y].wall, math.random(1,5))
					boxType = math.random(1, 2)
					--map[x][y].wall2 = image:new3DImage(self._woodenBox[boxType], x*self._blockSize, self._floorElevation+self._blockSize+heightTable[boxType]/4, y*self._blockSize, self._mainMapLayer) --math.random(1, #self._mapWalls)	
					entity:createBoxEntity(x, y, 2)					
					--image:setRot3D(map[x][y].wall, 0, math.random(1, 4)*90, 0 )
					map[x][y].hasWall = false
					map[x][y].floor = image:new3DImage(self._woodenFloors[1], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					image:set3DIndex(map[x][y].floor, math.random(1,2))	
			elseif map[x][y].value == 80 then
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._hatDecor[1], x*self._blockSize, self._floorElevation+self._blockSize+10, y*self._blockSize, self._scenaryLayer)
					map[x][y].wall2 = image:new3DImage(self._floorLamp[2], x*self._blockSize, self._floorElevation+self._blockSize-30, y*self._blockSize, self._mainMapLayer)
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._woodenFloors[1], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					table.insert(self._decorationTable, map[x][y].wall)		
			elseif map[x][y].value == 88 then
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._decor[math.random(1, #self._decor)], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._scenaryLayer) --math.random(1, #self._mapWalls)
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._mapFloors[1], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
			elseif map[x][y].value == 89 then
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._bookCases[1], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._mainMapLayer) --math.random(1, #self._mapWalls)
					image:setRot3D(map[x][y].wall, 0, 90, 0)					
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._mapFloors[1], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
			elseif map[x][y].value == 90 then
					map[x][y].hasWall = true
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = false
					map[x][y].wall = image:new3DImage(self._bookCases[2], x*self._blockSize, self._floorElevation+self._blockSize, y*self._blockSize, self._mainMapLayer) --math.random(1, #self._mapWalls)
					map[x][y].hasWall = true
					map[x][y].floor = image:new3DImage(self._mapFloors[1], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
			elseif map[x][y].value == 91 then
					map[x][y].hasWall = false
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = true
					entity:createBoxEntity(x, y, 3)
					--map[x][y].wall = image:new3DImage(self._drawer[1], x*self._blockSize, self._floorElevation+self._blockSize-35, y*self._blockSize, self._mainMapLayer) --math.random(1, #self._mapWalls)
					map[x][y].hasWall = false
					map[x][y].floor = image:new3DImage(self._mapFloors[1], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
			elseif map[x][y].value == 92 then
					map[x][y].floor = image:new3DImage(self._mapFloors[1], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer) -- set floors to be random
					--environment:createDoor(x, y, 1)	
           			map[x][y].wasVisited = false
           			map[x][y].hasFloor = true	
           			map[x][y].hasWall = false
					self:addDarknessAt(x, y, false)						
			else
				map[x][y].hasWall = true
			end
			
		end
	end
	
  	--self:addBoundaries()



	-- BOUNDARIES HACK END


	
	--local _px, _py = self:returnEmptyLocations( )
	
	self._doneGenerating = true
end
function math.distance(x1,y1, x2,y2) return ((x2-x1)^2+(y2-y1)^2)^0.5 end

function rngMap:updateDecorations( )
	for i,v in ipairs(self._decorationTable) do
		if type(v) ~= "table" then
			local rx, ry, rz = camera:getRot( )
			image:setRot3D(v, 0, ry, 0)
		else
			local rx, ry, rz = camera:getRot( )
			image:setRot3D(v.gfx, 0, ry, 0)
		end
	end
end

function rngMap:createSignPost(_x, _y)
	local x = _x
	local y = _y
	self._map[x][y].hasWall = true
	self._map[x][y].hasFloor = true
	
end

function rngMap:addFenceAt(_x, _y)
	if self._map[_x] ~= nil and self._map[_x][_y] ~= nil then
		self._map[_x][_y].wall = image:new3DImage(self._fence[math.random(1, 2)], _x*self._blockSize, self._floorElevation+self._blockSize, _y*self._blockSize, self._mainMapLayer)
		self._map[_x][_y].hasWall = true
	end
end

function rngMap:updateLights( )
	local px, py = player:returnPosition( )
	local map = self._map
	local _lightFactor = 0
	for x = 1, #map do
		for y = 1, #map[x] do
			local dist = math.distance(x, y, px, py)			
			if dist > 1 then
				local lightFactor = dist/(7-Game.lightFactor)
				_lightFactor = lightFactor
				if map[x][y].wall ~= nil then
					image:setColor(map[x][y].wall, 1-lightFactor, 1-lightFactor, 1-lightFactor, 1)
				end
				if map[x][y].wall2 ~= nil then
					image:setColor(map[x][y].wall2, 1-lightFactor, 1-lightFactor, 1-lightFactor, 1)
				end
				if map[x][y].floor ~= nil then
					image:setColor(map[x][y].floor, 1-lightFactor, 1-lightFactor, 1-lightFactor, 1)
				end
			end	
		end
	end
	
	for i,v in ipairs(self._decorationTable) do
		if type(v) == "table" then
			local dist = math.distance(v.x, v.y, px, py)			
			if dist > 1 then
				local lightFactor = dist/(7-Game.lightFactor)
				_lightFactor = lightFactor
				image:setColor(v.gfx, 1-lightFactor, 1-lightFactor, 1-lightFactor, 1)
			end
		end
	end

	if self._stairsGFX ~= nil then
		if self._stairsX ~= nil and self._stairsY ~= nil then
			local dist = math.distance(self._stairsX, self._stairsY, px, py)			
			if dist > 1 then
				local lightFactor = dist/(7-Game.lightFactor)
				_lightFactor = lightFactor
				image:setColor(self._stairsGFX, 1-lightFactor, 1-lightFactor, 1-lightFactor, 1)
			end
		end
	end

end

function rngMap:updateLights2(_x, _y)
	local px, py = _x, _y
	local map = self._map
	local _lightFactor = 0
	for x = 1, #map do
		for y = 1, #map[x] do
			local dist = math.distance(x, y, px, py)			
			if dist > 1 then
				local lightFactor = dist/(7-Game.lightFactor)
				_lightFactor = lightFactor
				if map[x][y].wall ~= nil then
					image:setColor(map[x][y].wall, 1-lightFactor, 1-lightFactor, 1-lightFactor, 1)
				end
				if map[x][y].wall2 ~= nil then
					image:setColor(map[x][y].wall2, 1-lightFactor, 1-lightFactor, 1-lightFactor, 1)
				end
				if map[x][y].floor ~= nil then
					image:setColor(map[x][y].floor, 1-lightFactor, 1-lightFactor, 1-lightFactor, 1)
				end
			else
				local lightFactor = 0
				_lightFactor = lightFactor
				if map[x][y].wall ~= nil then
					image:setColor(map[x][y].wall, 1-lightFactor, 1-lightFactor, 1-lightFactor, 1)
				end
				if map[x][y].wall2 ~= nil then
					image:setColor(map[x][y].wall2, 1-lightFactor, 1-lightFactor, 1-lightFactor, 1)
				end
				if map[x][y].floor ~= nil then
					image:setColor(map[x][y].floor, 1-lightFactor, 1-lightFactor, 1-lightFactor, 1)
				end			
			end	
		end
	end
	
	for i,v in ipairs(self._decorationTable) do
		if type(v) == "table" then
			local dist = math.distance(v.x, v.y, px, py)			
			if dist > 1 then
				local lightFactor = dist/(7-Game.lightFactor)
				_lightFactor = lightFactor
				image:setColor(v.gfx, 1-lightFactor, 1-lightFactor, 1-lightFactor, 1)
			end
		end
	end

	if self._stairsGFX ~= nil then
		if self._stairsX ~= nil and self._stairsY ~= nil then
			local dist = math.distance(self._stairsX, self._stairsY, px, py)			
			if dist > 1 then
				local lightFactor = dist/(7-Game.lightFactor)
				_lightFactor = lightFactor
				image:setColor(self._stairsGFX, 1-lightFactor, 1-lightFactor, 1-lightFactor, 1)
			end
		end
	end

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
                	--print("X: "..x.." | Y "..y.."")
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
				map[x][y].floor = image:new3DImage(self._specialFloor[4], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer)
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
				map[x][y].floor = image:new3DImage(self._specialFloor[3], x*self._blockSize, self._floorElevation, y*self._blockSize, self._mainMapLayer)
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

	local generator = astray:new( math.floor(self._mapWidth/2)-1,  math.floor(self._mapHeight/2)-1, 30, 70, 80, astray.RoomGenerator:new(8, 3, 6, 3, 6) )

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
	    --print(line)
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
	if self._darknessTable ~= nil then
		for i = 1, #self._darknessTable do
			if self._darknessTable[i].x == _x and self._darknessTable[i].y == _y then
				if self._darknessTable[i].isVisible == true then
					if self._darknessTable[i].isStatic ~= nil then
						local rndChance = math.random(1, 300)
						if _noCheckPlox == false then
							log:newMessage("It is <c:ffd1a6>pitch black</c>. You are likely to be <c:ffd1a6>eaten by a grue.</c>")
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
	----print("PX :"..px.." PY: "..py.."")
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
	--[[for x = 2, self._mapWidth do
		for y = 2, self._mapHeight do
			self._map[x][y].ceiling = image:new3DImage(self._mapCeilings[math.random(1, #self._mapCeilings )], x*self._blockSize, self._floorElevation+self._blockSize+self._blockSize, y*self._blockSize, self._mainMapLayer)
			self._map[x][y].hasCeiling = true
		end
	end--]]
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

function rngMap:returnEmptyLocations(_boolInfiniteMode)
	local resTable = self._emptyCellTable[math.random(1, #self._emptyCellTable)]
	if _boolInfiniteMode == 999 then
		local occupiedLocations = {}
		local px, py = player:returnPosition( )
		for i = 1, #self._emptyCellTable do

			local rndX = self._emptyCellTable[math.random(1, #self._emptyCellTable)]._x
			local rndY = self._emptyCellTable[math.random(1, #self._emptyCellTable)]._y
			local distance = math.distance(px, py, rndX, rndY)
			local boolOccupied = false
			for j, k in ipairs(occupiedLocations) do
				if k._x == self._emptyCellTable[i]._x and k._y == self._emptyCellTable[i]._y then
					boolOccupied = true
				end
			end
			if distance > 30 and boolOccupied == false then
				resTable._x = rndX
				resTable._y = rndY
				table.insert(occupiedLocations, self._emptyCellTable[i])
			end
		end

	end
	return resTable._x, resTable._y
end

function rngMap:_getRandomLocationFromTable(_table)
	local rnd = math.random(1, #_table)
	local x = _table[rnd].x
	local y = _table[rnd].y

	if _table[rnd].score > 10 then
		return x, y
	else
		self:_getRandomLocationFromTable(_table)
	end
end

function rngMap:_spawnAtDistance( )
	local locationTable = { }
	local px, py = player:returnPosition( )
	for i,v in ipairs(self._emptyCellTable) do
		local dist = math.distance(px, py, v._x, v._y)
		local temp = {
			score = dist,
			x = v._x,
			y = v._y,
		}
		table.insert(locationTable, temp)
	end

	return self:_getRandomLocationFromTable(locationTable)
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
				if self._map[x][y] ~= nil then
					if self._map[x][y].hasFloor ~= nil then
						if self._map[x][y].hasFloor == true then
							image:removeProp(self._map[x][y].floor, self._mainMapLayer)
							self._cells = self._cells + 1
							self._map[x][y].floor = nil
						end
					end

					if self._map[x][y].hasWall ~= nil then
						if self._map[x][y].hasWall == true then
							self._map[x][y].hasWall = true
							image:removeProp(self._map[x][y].wall, self._mainMapLayer) 
							if self._scenaryLayer ~= nil then
								image:removeProp(self._map[x][y].wall, self._scenaryLayer) 
							end
							self._map[x][y].wall = nil
						end
					end
					if self._map[x][y].hasCeiling  ~= nil then
						if self._map[x][y].hasCeiling == true then
							image:removeProp(self._map[x][y].ceiling, self._mainMapLayer) 
							self._map[x][y].ceiling = nil
						end	
					end
				end
			end
			self:isDarknessAt(x, y, true)		
		end


	end

	core:clearLayer(self._mainMapLayer)
	core:clearLayer(self._scenaryLayer)
	
	for i,v in ipairs(self._environmentTable) do
		image:removeProp(v.gfx, self._mainMapLayer) 
		image:removeProp(v.gfx, self._scenaryLayer) 
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

function rngMap:placeStairsAt(_x, _y)
	self._stairsX = _x
	self._stairsY = _y
	self._stairsGFX = image:new3DImage(self._stairsMesh, self._stairsX*100, 100, self._stairsY*100, 2 )
	table.insert(self._decorationTable, self._stairsGFX)
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

