cavity = {}
function cavity.gen(_map,wseed,x,y)
	local blub = ""
	--print("cavity.generating noise...")
	for i = 1, y, 1 do
		_map[i] = {}
		for j = 1, x, 1 do
			local num = math.random(100)
			if num > wseed then
				blub = cavity.space
				cavity.spacecounter = cavity.spacecounter + 1
			else
				blub = cavity.wall
			end
			_map[i][j] = blub
		end
	end
end

function cavity.wallit(table_,x,y)
for i = 1, y, 1 do
		for j = 1, x, 1 do
			if j == 1 then
				if table_[i][j] == cavity.space then cavity.spacecounter = cavity.spacecounter - 1 end
				table_[i][j] = cavity.wall
			end
			if j == x then
				if table_[i][j] == cavity.space then cavity.spacecounter = cavity.spacecounter - 1 end
				table_[i][j] = cavity.wall
			end
			if i == 1 then
				if table_[i][j] == cavity.space then cavity.spacecounter = cavity.spacecounter - 1 end
				table_[i][j] = cavity.wall
			end
			if i == y then
				if table_[i][j] == cavity.space then cavity.spacecounter = cavity.spacecounter - 1 end
				table_[i][j] = cavity.wall
			end
		end
	end
end
--detect neighbours
function cavity.detect1(table_,x,y)
	local x2 = x-1
	local y2 = y-1
	local unvtiles = {} --unvisited tiles
	for i=2,y-1 do
		for j=2,x-1 do
		table.insert(unvtiles, {i,j})
		end
	end
	for k,l in pairs(unvtiles) do
	local inde = math.random(#unvtiles)
			queue = 0
			queue2 = 0
			xc = unvtiles[inde][2]
			yc = unvtiles[inde][1]
			--start upper left
			for a = yc-1, yc+1, 1 do
				for b = xc-1, xc+1, 1 do
					if table_[a][b] == cavity.wall then
						queue = queue + 1
					end
				end
			end
			if yc-2 > 0 and xc-2 > 0 and yc+2 < y and xc+2 < x then
				for a2 = yc-2, yc+2, 1 do
					for b2 = xc-2, xc+2, 1 do
						if table_[a2][b2] == cavity.wall then
						queue2 = queue2 + 1
						end
					end
				end
			end
		if (queue >= 5) or (queue2 <= 1) then
			--if (queue >= 5)then
			if table_[yc][xc] == cavity.space then cavity.spacecounter = cavity.spacecounter - 1 end
			table_[yc][xc] = cavity.wall

		else
		if table_[yc][xc] ~= cavity.space then cavity.spacecounter = cavity.spacecounter + 1 end
		table_[yc][xc] = cavity.space
		table.remove(unvtiles, inde)
		end
	end
end


function cavity.detect2(table_,x,y)
	local x2 = x-1
	local y2 = y-1
	for i = 2, y2, 1 do
		for j = 2, x2, 1 do
			local queue = 0
			local xc = j
			local yc = i
			--start upper left
			for a = yc-1, yc+1, 1 do
				for b = xc-1, xc+1, 1 do
					if table_[a][b] == cavity.wall then
						queue = queue + 1
					end
				end
			end
		if (queue >= 5) then
			if table_[yc][xc] == cavity.space then cavity.spacecounter = cavity.spacecounter - 1 end
			table_[yc][xc] = cavity.wall
		else
		if table_[yc][xc] ~= cavity.space then cavity.spacecounter = cavity.spacecounter + 1 end
		table_[yc][xc] = cavity.space
		end
		end
	end
end

function cavity.clean(table_,threshold,x,y)
	local xpos = 1
	local ypos = 1
	local x2 = x-1
	local y2 = y-1
	while table_[ypos][xpos] == cavity.wall do --find first seed
		if ypos < y then
			ypos = ypos+1
		else
			ypos = 1
			xpos = xpos + 1
		end
	end
	startx,starty = xpos,ypos
	table_[ypos][xpos] = cavity.cellseed -- set seed
	local seedlist = {{ypos, xpos}}
	local seednum = 1
	cavity.roomcount = 0

	while seednum > 0 do --grow
	for a,b in pairs(seedlist) do
	local i,j = seedlist[a][1], seedlist[a][2]
	if table_[i][j] == cavity.cellseed then
					cavity.roomcount = cavity.roomcount + 1
					seednum = seednum - 1
					table.remove(seedlist, a)
					if table_[i-1][j] == cavity.space then
						table_[i-1][j] = cavity.cellseed
						seednum = seednum + 1
						table.insert(seedlist, {i-1,j})

					end
					if table_[i+1][j] == cavity.space then
						table_[i+1][j] = cavity.cellseed
						seednum = seednum + 1
						table.insert(seedlist, {i+1,j})
					end
					--links
					if table_[i][j-1] == cavity.space then
						table_[i][j-1] = cavity.cellseed
						seednum = seednum + 1
						table.insert(seedlist, {i,j-1})
					end
					--rechts
					if table_[i][j+1] == cavity.space then
						table_[i][j+1] = cavity.cellseed
						seednum = seednum + 1
						table.insert(seedlist, {i,j+1})
					end
				table_[starty][startx] = "O"
				table_[i][j] = cavity.dead


	end
	end
	end
	--discard?
	if cavity.roomcount > (threshold/100)*((y-2)*(x-2)) then
		--approved
		for i = 2, y2, 1 do
			for j = 2, x2, 1 do
				if table_[i][j] == cavity.dead then
					table_[i][j] = cavity.space
				else table_[i][j] = cavity.wall
				cavity.spacecounter = cavity.spacecounter - 1
				end
			end
		end
		return true
	else
		--discard
		for i = 2, y2, 1 do
			for j = 2, x2, 1 do
				if table_[i][j] == cavity.dead then
				table_[i][j] = cavity.wall
				cavity.spacecounter = cavity.spacecounter - 1
				end
			end
		end
	end
	for i = 2, y2, 1 do
			for j = 2, x2, 1 do
				if table_[i][j] == cavity.dead then
					table_[i][j] = cavity.space
				end
			end
		end

end


function cavity.printt(input,x,y)
local height = 0
	for i, j in pairs(input) do
		out = ""
		for k, l in pairs(input[i]) do
			out = out .. l
		end
		local line = ""
		for i = 1,x,1 do
		line = line .. "_"
		end
		print(out)
		height = height + 1
		if height == y then
		print(line)
		height = 0
		end
	end
end

function cavity.standard(_map,wseed,x,y,it1,it2)
cavity.spacecounter = 0
seedlist = {}
cavity.gen(_map, wseed,x,y)
cavity.wallit(_map,x,y)
for i=1,it1 do
cavity.detect1(_map,x,y)
end
for i=1,it2 do
cavity.detect2(_map,x,y)
end
cavity.detect2(_map,x,y)
end

function cavity.sprinkle(_map,ttype,ttype2,x,y,abso)
	local count = 0
	while abso > 0 do
		i = math.random(y)
		k = math.random(x)
		if _map[i][k] == ttype then
			_map[i][k] = ttype2
			abso = abso - 1
			count = count + 1
		end
	end
	return count
end


function cavity.makemap(a,b,c,d, seed, it1,it2)
local map = {}
cavity.seed = seed or os.time()
math.randomseed(cavity.seed)


local x = a or 30
local y = b or 30
cavity.room = x*y
local threshold = c or 30
local wseed = d or 44
local it1 = it1 or 2
local it2 = it2 or 2

cavity.space = " "
cavity.wall = "#"
cavity.cellseed = "@"
cavity.dead = "+"


while true do
cavity.standard(map,wseed,x,y, it1, it2)
if cavity.spacecounter > 0 then
if cavity.clean(map,threshold,x,y)then
	break
end
end
while cavity.spacecounter > 0 do
cavity.clean(map,threshold,x,y)
end
end
return map
end
