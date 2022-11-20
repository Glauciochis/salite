_action.reqcomp={'drink'}
_action.reqcont={'close'}
function _action.start(agent, target)
	agent.progress = 0
end
function _action.update(agent, target, _dt)
	agent.progress = agent.progress + _dt
	
	-- animate
	agent.tileagent.anim='drink'
	
	if agent.progress >= .5 then
		local slot = table.contains(agent.inv, target)
		if slot then
			local drink = poi.ecs.getEntity(target)
			agent.primal.thirst = agent.primal.thirst - drink.drink
			table.remove(agent.inv, slot)
			drink:destroy()
		else
			local drink = poi.ecs.getEntity(target)
			agent.primal.thirst = agent.primal.thirst - drink.drink
		end
		
		-- print('thirst now at '..agent.primal.thirst)
		agent.tileagent.anim='idle'
		return true
	end
end