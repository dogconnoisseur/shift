local helpers = {}

function helpers.hexToRGB(hex)
	hex = hex:gsub("#", "")
	return tonumber("0x" .. hex:sub(1, 2)) / 255,
		tonumber("0x" .. hex:sub(3, 4)) / 255,
		tonumber("0x" .. hex:sub(5, 6)) / 255,
		hex:len() == 8 and tonumber("0x" .. hex:sub(7, 8)) / 255 or 1
end

return helpers
