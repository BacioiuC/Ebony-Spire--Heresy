mAnim = { }

function mAnim:init( )
	self._animTable = { }

end

function mAnim:new(_mesh, _texName, _frames, _speed, _prop, _playAnim )
	if Game.worldTimer == nil then
		Game.worldTimer = 0.01
	end

	local temp = { 
		id = #self._animTable + 1,
		nrFrames = _frames,
		speed = _speed,
		timer = Game.worldTimer,
		frameList =  { },
		mesh = _mesh,
		prop = _prop,
		index = 1,
		_optionalPlay = true,
	}

	if _playAnim ~= nil then
		temp._optionalPlay = _playAnim
	end

	for i = 1, _frames do
		temp.frameList[i] = MOAITexture:new( )
		--print("AHEM: ".._texName..""..i..".png")
		temp.frameList[i]:load("".._texName..""..i..".png")
	end

	table.insert(self._animTable, temp)
	return temp
end

function mAnim:cancelAnim(_id)
	local v = self._animTable[_id]
	--v.mesh:setTexture( v.frameList[1] )
	v._optionalPlay = false
end

function mAnim:playAnim(_id)
	local v = self._animTable[_id]
	--v.mesh:setTexture( v.frameList[1] )
	v._optionalPlay = true
end

function mAnim:updateAnim(_id)
	local v = self._animTable[_id]
	if v._optionalPlay ~= false then
		if Game.worldTimer > v.timer + v.speed then
		--	print("CHANGE IT! ")
		--	print("CHANGE IT! ")

			if v.index > #v.frameList then
				v.index = 1


			end
		--	print("FRAMELIST: "..#v.frameList.."")
			v.mesh:setTexture( v.frameList[v.index] )
			--image:set3DDeck(v.prop, v.mesh)
			--image:setTexture(v.mesh, v.frameList[v.index])
			v.index = v.index + 1
			v.timer = Game.worldTimer
		end
	end
--	print("Loop")
end

function mAnim:update( )

	for i,v in ipairs(self._animTable) do
		self:updateAnim(i)
	end
end

function mAnim:dropAnim(_anim)
	if _anim.frameList ~= nil then
		for i = 1, #_anim.frameList do
			_anim.frameList[i]:release( )
			_anim.frameList[i] = nil
		end
	end
end