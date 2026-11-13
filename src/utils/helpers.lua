local helpers = {}

function helpers.hexToRGB(hex, defaultAlpha)
	hex = hex:gsub("#", "")
	return tonumber("0x" .. hex:sub(1, 2)) / 255,
		tonumber("0x" .. hex:sub(3, 4)) / 255,
		tonumber("0x" .. hex:sub(5, 6)) / 255,
		hex:len() == 8 and tonumber("0x" .. hex:sub(7, 8)) / 255 or (defaultAlpha or 1)
end

function helpers.print2dArray(flatGrid, width, height)
	for row = 1, height do
		local startIdx = (row - 1) * width + 1
		local endIdx = row * width
		print(table.concat(flatGrid, " ", startIdx, endIdx))
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
