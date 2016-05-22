evTurn = {}

function evTurn:init( )
	self._turnQue = { }
	self._evTurnTable = { }
	self._evTempQue = { }
	self._turnCounter = 0

	self._isPlayerTurn = false
	self._canPlayerMove = false
	self._playerIDForQue = 1337133
	self._entCountIdx = 1

	self._playerEntity = {
		id = self._playerIDForQue,
		x = 1,
		y = 1,
		speed = 15,
		name = "Player",

	}
end	

function evTurn:canPlayerMove( )
	return self._canPlayerMove
end

function evTurn:addEntityToQue(_entity)
	local temp =  {
		id = _entity.id,
		_x = _entity.x,
		_y = _entity.y,
		_speed = _entity.speed,
		_name = _entity.name,
	}


	table.insert(self._evTempQue, temp)

end

function evTurn:prepareList( )
	for i,v in ipairs(entity:getList( )) do
		if v.isCreature == true then
			v.energy = v.initialEnergy
			self:addEntityToQue(v)
		end
	end
	self:sortQue( )

end

function handlePCTurn( )
	evTurn:_checkPlayerNextToPortal( )
	evTurn:_checkPlayerOnStairs( )
	evTurn:prepareList( )
	evTurn:loopThroughListAndPerform( )
	evTurn:resetQue( )




end

function evTurn:handlePCTurn()
	
	player:incTurn( )
	player:regenLife( )
	evTurn:_checkPlayerNextToPortal( )
	self:_checkPlayerOnStairs( )
	self:prepareList( )
	self:loopThroughListAndPerform( )
	self:resetQue( )
	local px, py = player:returnPosition( )
	local bool, chance = rngMap:isPatchAt(px, py, false)
	--------- CHECK IF PLAYER IS ON A PATCH OF DARKNESS and GET CHANCE TO DIE!
	if bool == true and chance == 7 then
		log:newMessage("You were eaten by a grue!")
		player:setKilledBy("a grue from within a patch of Darkness!")
		player:receiveDamage(1000*10000)
	end
	--------- END CHECK
end

function evTurn:update( )

end

function evTurn:loopThroughListAndPerform( )
	for i,v in ipairs(self._evTurnTable) do
		if v.id ~= self._playerIDForQue then
			entity:performAction(v.id)
		end
	end
	-- loop through the list in order, starting with 1.
	-- check current IDX. Is that entity DONE with it's action?
	---- YES: increment IDX and try that entity
	---- NO: do nothing and wait for it to do it's stuff
end

function evTurn:sortQue( )
	for i,v in spairs(self._evTempQue, function(t,a,b) return t[b]._speed < t[a]._speed end) do
		table.insert(self._evTurnTable, v)
		--print("Name: "..v._name.." | Speed: "..v._speed.."")
	end

end


function evTurn:resetQue( )
	self._evTurnTable = { }
	self._evTempQue = { }
end

function evTurn:_checkPlayerOnStairs( )
	local px, py = player:returnPosition( )
	local sx, sy = rngMap:returnStairsPosition( )

	if px == sx and py == sy then
		log:newMessage("Do you want to go <c:EAFF00> up the stairs? Press > to climb</c>")
	end
end

function evTurn:_checkPlayerNextToPortal( )
	local px, py = player:returnPosition( )
	local sx, sy = environment:returnPortalPosition( )

	if math.dist(px, py, sx, sy) < 2 then
		log:newMessage("Do you want to enter <c:EAFF00> the portal?</c> Press O to acess it!")
	end
end

function evTurn:_isPlayerOnStairs( )
	local px, py = player:returnPosition( )
	local sx, sy = rngMap:returnStairsPosition( )

	if px == sx and py == sy then
		--log:newMessage("Do you want to go <c:EAFF00> up the stairs? Press > to climb</c>")
		return true
	end
end
------------------ local sorting function
local function spairs(t, order)
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

--[[

for k,v in spairs(HighScore, function(t,a,b) return t[b] < t[a] end) do
    print(k,v)
end
]]