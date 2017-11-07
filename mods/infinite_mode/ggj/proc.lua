
gen = { }
math.randomseed(os.time())
function math.distance(x1,y1, x2,y2) return ((x2-x1)^2+(y2-y1)^2)^0.5 end

function gen:init(_seed)
    self._levelSeed = _seed
    if _seed == nil then

        self._levelSeed = os.time()
    end
    self._genTable = { }
    self._wall = 0
    self._floor = 1

    self._mapWidth = 30
    self._mapHeight = 30
    self._map = {}
    self._collisionMap = {}

    for x = 1, self._mapWidth do
        self._map[x] = { }
        self._collisionMap[x] = {}
        for y = 1, self._mapHeight do
            self._map[x][y] = "#"
            self._collisionMap[x][y] = self._wall
        end
    end

    self._roomTypes = {}
    self._roomTypes[1] = "vault"
    self._roomTypes[2] = "library"
    self._roomTypes[3] = "shop"
    self._roomTypes[4] = "portal"


    self._roomSymbol = { }
    self._roomSymbol["vault"] = " "
    self._roomSymbol["library"] = "b"
    self._roomSymbol["shop"] = "s"
    self._roomSymbol["portal"] = " "
    
    math.randomseed(self._levelSeed)
    self._roomTable = { }
    self:dungeon( )
   -- self:output( )
    return self._levelSeed
end

function gen:newRoom(_x, _y, _width, _height, _quadrant)
    if _x ~= nil and _y ~= nil then
        local id = #self._roomTable + 1
        local rw = _width
        local rh = _height
        local posX = _x
        local posY = _y

        local temp = { 
            rId = #self._roomTable+1,
            width = _width,
            height = _height,
            x = _x,
            y = _y,
            centerX = math.floor( (_x + _width)/2 ),
            centerY = math.floor( (_y + _height)/2 ),
            id = 1,
        }
        temp._type = self._roomTypes[math.random(1, #self._roomTypes)]
        temp.door = { posX = 0+_x-1, posY = 0+_y }
        -- give the room a door position on one of the extremeties
        local randomWallForDoor = math.random(1, 4) -- N,E,S,W
        if randomWallForDoor == 1 then -- left wall
            temp.door.posX = _x 
            temp.door.posY = math.random(_y, _y+_height)
        elseif randomWallForDoor == 2 then -- top wall
            temp.door.posX = math.random(_x, _x+_width) 
            temp.door.posY = _y      
        elseif randomWallForDoor == 3 then -- right wall
            temp.door.posX = _x+_width
            temp.door.posY = math.random(_y, _y+_height)
        else -- bottom wall
            temp.door.posX = math.random(_x, _x+_width) 
            temp.door.posY = _y+_height
        end

        

        table.insert(self._roomTable, temp)
        return id
    end
end

function gen:getRandomStartPosition( )
    local startX = math.random(3, 24)
    local startY = math.random(3, 24)
    local width = math.random(2, 4)
    local height = math.random(2, 4)

    if self:doesRoomExistAt(startX, startY) == true then
        self:getRandomStartPosition( )
    else
        return startX, startY, width, height
    end
end

function gen:doesRoomExistAt(_x, _y)
    -- split the map area in X amount of quadrands!
    -- 30 / 5 = 6

    return bool
end

function gen:dungeon( )
    for i = 1, 15 do -- 7 rooms test
        self:newRoom(self:getRandomStartPosition( ))
    end

    for i, v in ipairs(self._roomTable) do
        if v.x ~= nil and v.y ~= nil then
            for _x = v.x, v.x+v.width do
                for _y = v.y, v.y+v.height do
                    self._map[_x][_y] =  self._roomSymbol[v._type]
                end
            end
        end
    end

    for i,v in ipairs(self._roomTable) do
        self._map[v.door.posX][v.door.posY] = "d"
    end
    -- Library setup
    -- Calls the grid class
    local pGrid = require ("mods.infinite_mode.ggj.jumper.grid")
    -- Calls the pathfinder class
    local pPathfinder = require ("mods.infinite_mode.ggj.jumper.pathfinder")
    
    pgrid = pGrid(self._collisionMap)
    pwalkable = self._wall
    local pmyFinder = pPathfinder(pgrid, 'ASTAR', pwalkable)
    pmyFinder:setMode('ORTHOGONAL')
    -- connect all the foorms
    --local path = astar.path ( graph [ 2 ], graph [ 3 ], graph, true, valid_node_func )
    local roomsWithNoPaths = {}
    for i = 1, #self._roomTable do
        if self._roomTable[i-1] ~= nil then 
            local start = {
                x = self._roomTable[i-1].door.posX,
                y = self._roomTable[i-1].door.posY,    
            }

            local goal = {
                x = self._roomTable[i].door.posX,
                y = self._roomTable[i].door.posY,
            }
            local path = pmyFinder:getPath(start.x, start.y, goal.x, goal.y)
            --if path ~= nil then
            if path ~= nil then
                for node, count in path:nodes() do
                    self._map[node:getX()][node:getY()] = "."
                    --self._collisionMap[node:getX()][node:getY()] = "."
                end
            else
                local temp = {
                    id = i,
                }
                table.insert(roomsWithNoPaths, temp)
            end
        end
    end

    for i,v in ipairs(roomsWithNoPaths) do
        local room = self._roomTable[v.id]
        for x = room.x, room.x + room.width do
            for y = room.y, room.y + room.height do
                self._map[x][y] = "#"
            end
        end
    end

    --[[for i = 1, #self._roomTable do
        if i > 1 then 
            local start = {
                x = self._roomTable[i-1].x,
                y = self._roomTable[i-1].y    
            }

            local goal = {
                x = self._roomTable[i].x,
                y = self._roomTable[i].y    
            }
            local path = pmyFinder:getPath(start.x, start.y, goal.x, goal.y)
            --if path ~= nil then
            for node, count in path:nodes() do
                self._map[node:getX()][node:getY()] = "."
            end
        end
    end--]]

    --for i,v in ipairs(self._roomTable) do
     --   self._map[v.door.posX][v.door.posY] = "D"
    --end
    local wallCounter = 0
    for x = 1, self._mapWidth do
        for y = 1, self._mapHeight do
            if self._map[x][y] == " " or self._map[x][y] == "." then
                -- check if wall left or right
                for _offsetX = x-1, x+1 do
                    if self._map[_offsetX] ~= nil and _offsetX ~= x then
                        if self._map[_offsetX][y] == "#" then
                            wallCounter = wallCounter + 1
                        end
                    end
                end
                if wallCounter == 2 then
                    if self:_isDoorNearby(x, y) == false then
                        self._map[x][y] = "|"
                         wallCounter = 0
                    else
                        wallCounter = 0
                    end
                else
                    wallCounter = 0
                end
            end
        end
    end

    local wallCounter = 0
    for x = 1, self._mapWidth do
        for y = 1, self._mapHeight do
            if self._map[x][y] == "." then
                -- check if wall left or right
                for _offsetY = y-1, y+1 do
                    if self._map[x][_offsetY] ~= nil and _offsetY ~= Y then
                        if self._map[x][_offsetY] == "#" then
                            wallCounter = wallCounter + 1
                        end
                    end
                end
                if wallCounter == 2 then
                    if self:_isDoorNearby(x, y) == false then
                        self._map[x][y] = "_"
                         wallCounter = 0
                    else
                        wallCounter = 0
                    end
                else
                    wallCounter = 0
                end
            end
        end
    end
end

function gen:_isDoorNearby(_x, _y)
    local doorBool = false
    for x = 1, self._mapWidth do
        for y = 1, self._mapHeight do
            if self._map[x][y] == "_" or self._map[x][y] == "|" then
                if math.distance(_x, _y, x, y) < 6 then
                    doorBool = true
                end
            end
        end
    end

    return doorBool
end

function gen:_returnGeneratedMap( )
    return self._map
end

function gen:output( )
    local lineString = ""
    local newLineCounter = 0
    for x = 1, self._mapWidth do
        for y = 1, self._mapHeight do
            lineString = lineString..""..self._map[x][y]..""
            if y == self._mapHeight then
                print(""..lineString.."")
                lineString = ""
            end
        end
    end
end


gen:init( )
