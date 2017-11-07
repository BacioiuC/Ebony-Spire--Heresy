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

sound = {}

function sound:init( )
	self._soundTable = { }

	self._mainMenuSFX = {}
	self._buttonSFX = {}
	self._actionMusic = {}
	self._unitSounds = {}
	self._gunSounds = {}
	self._worldMapSFX = {}
	self._walkingSFX = {}
	self._commanderVFX = { }

	self._soundTable[1] = self._mainMenuSFX
	self._soundTable[2] = self._buttonSFX
	self._soundTable[3] = self._actionMusic
	self._soundTable[4] = self._unitSounds
	self._soundTable[5] = self._gunSounds
	self._soundTable[6] = self._worldMapSFX
	self._soundTable[7] = self._walkingSFX
	self._soundTable[8] = self._commanderVFX

	MOAIUntzSystem.initialize (44100, 1000)
	SOUND_MAIN_MENU = 1
	SOUND_BUTTONS = 2
	SOUND_BGMUSIC = 3
	SOUND_UNIT = 4
	SOUND_GUNS = 5
	SOUND_WORLDMAP = 6
	SOUND_WALKING = 7
	SOUND_COMMANDERS = 8
end

function sound:new(_category, _string, _volume, _loopFlag, _streamFlag)
	local temp = {
		sound = MOAIUntzSound.new(),
		id = #self._soundTable+1,
		cat = _category,
	}
	temp.sound:load(_string, _streamFlag)
	temp.sound:setVolume(_volume)
	temp.sound:setLooping(_loopFlag)

	table.insert(self._soundTable[_category], temp)
	return temp, temp.id
end

function sound:playFromCategory(_id)
local cat = _id
	local tab = self._soundTable[cat]
	if #tab > 0 then
		local snd = tab[math.random(1, #tab)]
		self:play(snd)
	end
end

function sound:setVolumeCategory(_id, _value)
	local cat = _id
	local tab = self._soundTable[cat]
	for i, v in ipairs(tab) do
		print("I IS: "..i.." | CATEGORY IS: ".._id.." VALUE IS: ".._value.."")
		v.sound:setVolume(_value)
	end
end

function sound:setGeneralVolume(_value, noBgMusic)


	for i,v in ipairs(self._soundTable) do
		if i ~= 3 then
			for k, j in ipairs(v) do
				j.sound:setVolume(_value)
			end
		elseif i == 3 then
			--print("YES IS 3")
			for k, j in ipairs(v) do
				if _value - 0.4 > 0 then
					j.sound:setVolume(_value-0.4)
				end
			end		
		end
	end

	--local tab = self._soundTable[cat]
	--local bool = false
	--for i, v in ipairs(tab) do
	--	if v.sound:isPlaying( ) == true then
	--		bool = true
	--	end
	--end

	--return bool
end

function sound:getCategoryPlaying(_id)
	local cat = _id
	local tab = self._soundTable[cat]
	local bool = false
	for i, v in ipairs(tab) do
		if v.sound:isPlaying( ) == true then
			bool = true
		end
	end

	return bool
end

function sound:stopAllFromCategory(_id)
	local cat = _id
	local tab = self._soundTable[cat]
	for i, v in ipairs(tab) do
		if v.sound:isPlaying() == true then
			v.sound:stop( )
		end
	end

end

function sound:isPlaying(_sndFile)
	local bool = _sndFile.sound:isPlaying()
	return bool
end

function sound:stopAll( )
	--local cat = _id
	for j = 1, #self._soundTable do
		local tab = self._soundTable[j]
		for i, v in ipairs(tab) do
			if v.sound:isPlaying() == true then
				v.sound:stop( )
			end
		end
	end

end

function sound:play(_soundFile)
	--self:stopAll( )
	local snd = _soundFile.sound
	snd:play( )
end

function sound:stop(_soundFile)
	local snd = _soundFile.sound
	snd:stop( )
end

function sound:pause(_soundFile)
	local snd = _soundFile.sound
	snd:pause( )
end

function sound:resume(_soundFile)
	local snd = _soundFile.sound
	snd:play( )
end

function sound:seekVolume(_soundFile, _value, _delta)
	local snd = _soundFile.sound
	snd:seekVolume(_value, _delta)
end

function sound:setLoop(_soundFile, _loopFlag)
	local snd = _soundFile.sound
	snd:setLooping(_loopFlag)
end

function sound:deleteSound(_soundFile)
	local snd = _soundFile
	local id = snd.id
	self:stop(snd)
	table.remove(self._soundTable[snd.cat], id)
	for i,v in ipairs(self._soundTable[snd.cat]) do 
		v.id = i
	end
end