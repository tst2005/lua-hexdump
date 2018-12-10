return
function(data)
	local X = "[0-9a-fA-F]"
	local anyNotX = "[^0-9a-fA-F]+"
	return (
		("\n"..data)
		:gsub("\n" .. (X):rep(5).."+", "\n")
		:gsub("|[^|]+|", "")
		:gsub(anyNotX, "")
		:gsub("(..?)", function(xx)
			return string.char( tonumber( xx, 16) )
		end)
	)
end
