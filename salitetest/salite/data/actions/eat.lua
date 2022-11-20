_action.reqcomp={'food'} -- components
_action.reqcont={'holding'} -- context
function _action.canact(obj)
	local o = obj[1] == 'object' and _obj[ obj[2] ] or obj
	-- if 
end
function _action.start(agent, target)
	agent.progress = 0
end
function _action.update(agent, target, _dt) -- item must be in inventory
	agent.progress = agent.progress + _dt
	
	-- animate
	-- agent.tileagent.anim = 'eat'
	
	if agent.progress >= 1 then
		-- local slot = table.contains(agent.inv, target)
		-- print('hunger now at '..agent.primal.hunger)
		local slot = 0
		for i, item in ipairs(agent.inv) do
			if item._id == target then slot = i break end
		end
		if slot > 0 then
			local food = _objdata[ agent.inv[slot].id ]
			agent.primal.hunger = agent.primal.hunger - food.food
			table.remove(agent.inv, slot)
			-- food:destroy()
		end
		
		-- print('hunger now at '..agent.primal.hunger)
		
		-- reset animation
		-- agent.tileagent.anim = 'idle'
		return true
	end
end