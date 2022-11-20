local _bb = {}
local last = 0
local _blackboards = {}


function _bb.new()
	
	_last=_last+1
	local id = string.format("%x", _last)
	_blackboard[_last] = {}
	
	return id
	
end


return _bb