-- when writing code for actions, use '_action'
-- self is the ai component, agent is the entity itself
-- return whether the action is complete/should be removed from queue

-- TODO: maybe separate work on a station and work on an item

_action.reqcomp = {'work'}
_action.reqcont = {'close'}
function _action.update(agent, targetid, _dt)
	local target = poi.ecs.getEntity(targetid)
	--local station = poi.pin.station[target.station.id]
	
	local skill = target.skill and (agent.skill[target.skill] or 10) or 10
	target.work = target.work + (skill/10) * _dt
	
	-- set up animation
	agent.tileagent.anim = 'work'
	
	if target.work >= 2 then
		-- do thing based on work type
		if target.worktype == 'station' then
			poi.pin.world.newObject(agent.tileagent.room, agent.transform.x, 'metal-ball')
		elseif target.worktype == 'craft' then
			-- needtool='hammer', craft='nut-fruit', isdestroyed=true
			poi.pin.world.newObject(target.tileobject.holder, agent.transform.x, target.craft)
			if target.isdestroyed then
				target:destroy()
			end
		end
		
		target.work = 0
		agent.tileagent.anim = 'idle'
		return true
	end
	
	-- temp
	agent.primal.exhaustion = agent.primal.exhaustion + _dt
	agent.primal.hunger = agent.primal.hunger + _dt
	agent.primal.thirst = agent.primal.thirst + _dt
	agent.primal.occupation = agent.primal.occupation + _dt
end
function _action.dynreqcont(agent, target, env)
	local addedreqs = {}
	
	if target.needtool then
		
		table.insert(addedreqs, 'tool:'..target.needtool)
		
	end
	
	return addedreqs
end