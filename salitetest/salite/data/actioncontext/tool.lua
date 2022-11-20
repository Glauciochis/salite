-- function _context.check(agent, object)
	-- return math.abs(agent.transform.x - object.transform.x) < 2
-- end
function _context.dyncheck(agent, object)
	local conts = {}
	
	for i, k in ipairs(agent.inv) do
		local ent = poi.ecs.getEntity(k)
		if ent.tool then
			table.insert(conts, 'tool:'..ent.tool)
		end
	end
	
	return conts
end