

function salite.getobject(id)
	return _ent[id]
end
function salite.getgoallist(agent)
	local goals = {}
	--[[
	for goalname, goal in pairs(salite.goals) do
		local n = goal.priority(agent, env)
		table.insert(goals, {goalname, n})
	end
	--]]
	for i, goalname in ipairs(agent.agent.goals) do
		local goal = salite.goals[goalname]
		local n = goal.priority(agent, env) -- TODO: env doesn't exist? fix that...
		table.insert(goals, {goalname, n})
	end
	return goals
end
function salite.getpotential(agent, goalacts)
	local potential = {}
	
	-- first and foremost check own inventory
	-- (don't work probably)
	for i, id in ipairs(agent.inv) do
		local act = salite.checkPotentialObject(id, goalacts)
		if act then
			print(id, act)
			table.insert(potential, {id, act}) -- TODO: fix, it currently will try to act on itself instead of specifically the item
			-- print('found potential solution')
		end
	end
	
	-- iterate over objects in room
	for objectid, object in salite.getobjects() do
		-- local object = salite.getobject(objectid)
		
		local act = salite.checkPotentialObject(objectid, goalacts)
		if act then
			print(objectid, act)
			table.insert(potential, {objectid, act})
			-- print('found potential solution')
		end
		
		-- TODO: work on this, it doesn't work because inventory has items instead of entities
		-- check the object's inventory as well
		if object.inv then
			for j, id in ipairs(object.inv) do
				local act = salite.checkPotentialObject(id, goalacts)
				if act then
					table.insert(potential, {id, act})
					print(id, act)
					-- print('found potential solution')
				end
			end
		end
	end
	
	return potential
end
function salite.getobjects()
	return pairs(_ent)
end
function salite.getinventorylist()
	
end

