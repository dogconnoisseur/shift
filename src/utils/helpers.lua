local helpers = {}

function helpers.hexToRGB(hex, defaultAlpha)
	hex = hex:gsub("#", "")
	return tonumber("0x" .. hex:sub(1, 2)) / 255,
		tonumber("0x" .. hex:sub(3, 4)) / 255,
		tonumber("0x" .. hex:sub(5, 6)) / 255,
		hex:len() == 8 and tonumber("0x" .. hex:sub(7, 8)) / 255 or (defaultAlpha or 1)
end

function helpers.print1dArray(flatGrid, width, height)
	for row = 1, height do
		local startIdx = (row - 1) * width + 1
		local endIdx = row * width
		print(table.concat(flatGrid, " ", startIdx, endIdx))
	end
end

function helpers.print2dArray(array, width, height)
	for y = 1, height do
		for x = 1, width do
			if type(array[y][x]) == "table" then
				for key, value in pairs(array[y][x]) do
					print(key, tostring(value))
				end
			else
				print(array[y][x])
			end
		end
		print("\n")
	end
end

function helpers.printTableOfTables(tbl, indent)
	indent = indent or 0
	local pad = string.rep("  ", indent)
	for k, v in pairs(tbl) do
		if type(v) == "table" then
			print(pad .. tostring(k) .. " = {")
			helpers.printTableOfTables(v, indent + 1)
			print(pad .. "}")
		else
			print(pad .. tostring(k) .. " = " .. tostring(v))
		end
	end
end

local printTableCount = 0
function helpers.printTable(tbl, count)
	if count then
		if printTableCount < count then
			for i, v in pairs(tbl) do
				print(i, v)
			end
		end
		printTableCount = printTableCount + 1
	else
		for i, v in pairs(tbl) do
			print(i, v)
		end
	end
end

function helpers.shallowCopy(orig)
	local copy = {}
	for k, v in pairs(orig) do
		copy[k] = v
	end
	return copy
end

function helpers.invertDictionary(t)
	local inverted = {}
	for k, v in pairs(t) do
		inverted[v] = k
	end
	return inverted
end

return helpers
