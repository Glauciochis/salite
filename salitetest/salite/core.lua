

function table.val_to_str ( v )
	if "string" == type( v ) then
		v = string.gsub( v, "\n", "\\n" )
		-- may be a tad broken
		if string.match( string.gsub(v,"[^'\"]",""), '^"+$' ) then
			return "[[" .. v .. "]]"
		end
		return '"' .. string.gsub(v,'"', '\\"' ) .. '"'
	else
		return "table" == type( v ) and table.tostring( v ) or
		tostring( v )
	end
end
function table.key_to_str ( k )
	if "string" == type( k ) and string.match( k, "^[_%a][_%a%d]*$" ) then
		return k
	else
		return "[" .. table.val_to_str( k ) .. "]"
	end
end
function table.tostring( tbl )
	if type(tbl) == "table" then
		local result, done = {}, {}
		for k, v in ipairs( tbl ) do
			table.insert( result, table.val_to_str( v ) )
			done[ k ] = true
		end
		for k, v in pairs( tbl ) do
			if not done[ k ] then
				table.insert( result,
				table.key_to_str( k ) .. "=" .. table.val_to_str( v ) )
			end
		end
		return "{" .. table.concat( result, "," ) .. "}"
	end
	return "nil"
end

function table.findindex(t, v) for i, k in ipairs(t) do if k == v then return i end end end
function table.contains(table, check) -- (ipairs) returns the position it was found; if not found will return false
	for i, entry in ipairs(table) do
		if entry == check then return i end
	end
	return false
end
function table.has(tbl, requirements) -- table, table -- returns true if the table includes each and every one of the requirements
	for _, req in ipairs(requirements) do
		if tbl[req] == nil and not table.contains(tbl, req) then return false end
	end
	return true
end
function table.hasAny(tbl, requirements) -- table, table -- returns true if the table includes any of the requirements
	for _, req in ipairs(requirements) do
		if tbl[req] ~= nil then return true end
	end
	return false
end
function table.hasOne(tbl, requirements) -- table, table -- returns true if the table include only one of the requirements
	local c = 0
	for _, req in ipairs(requirements) do
		if tbl[req] ~= nil then c = c + 1 end
	end
	return (c == 1)
end


