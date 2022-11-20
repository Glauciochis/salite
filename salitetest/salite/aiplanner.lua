local salite = {}
require'salite.core'
salite.datapath = 'salite/data'
salite.goals = {}
salite.actcontext = {}
salite.actions = {}

-- no idea if this works yet, make system work before using
local importxfrompath = function(path, codeadd, t)
	local files = love.filesystem.getDirectoryItems(path)
	for i, file in ipairs(files) do
		if file:find(".lua") then
			-- add declaration and return
			local code = love.filesystem.read(path..'/'..file)
			code = [[local ]]..codeadd..[[ = {} ]] .. code .. [[ return ]]..codeadd
			
			-- import with protected call
			local success, ret = pcall(loadstring(code))
			if success then 
				-- add to table if successful
				t[string.gsub(file, '.lua', '')] = ret
			else
				-- handle error printing
				print("error importing code for '" .. file .. "' " .. ret)
			end 
		end
	end
end
function salite.load()
	-- import goals
	local files = love.filesystem.getDirectoryItems(salite.datapath..'/goals')
	for i, file in ipairs(files) do
		if file:find(".lua") then
			-- add _action declaration and return
			local code = love.filesystem.read(salite.datapath..'/goals/'..file)
			code = [[local _goal = {} ]] .. code .. [[ return _goal]]
			
			-- import with protected call
			local success, ret = pcall(loadstring(code))
			if success then 
				-- add to action table if successful
				salite.goals[string.gsub(file, '.lua', '')] = ret
			else
				-- handle error printing
				print("error importing goal code for '" .. file .. "' " .. ret)
			end 
		end
	end
	
	-- import action contexts
	local files = love.filesystem.getDirectoryItems(salite.datapath..'/actioncontext')
	for i, file in ipairs(files) do
		if file:find(".lua") then
			-- add _action declaration and return
			local code = love.filesystem.read(salite.datapath..'/actioncontext/'..file)
			code = [[local _context = {} ]] .. code .. [[ return _context]]
			
			-- import with protected call
			local success, ret = pcall(loadstring(code))
			if success then 
				-- add to action table if successful
				salite.actcontext[string.gsub(file, '.lua', '')] = ret
			else
				-- handle error printing
				print("error importing action context code for '" .. file .. "' " .. ret)
			end 
		end
	end
	
	-- import actions
	local files = love.filesystem.getDirectoryItems(salite.datapath..'/actions')
	for i, file in ipairs(files) do
		if file:find(".lua") then
			-- add _action declaration and return
			local code = love.filesystem.read(salite.datapath..'/actions/'..file)
			code = [[local _action = {} ]] .. code .. [[ return _action]]
			
			-- import with protected call
			local success, ret = pcall(loadstring(code))
			if success then 
				-- add to action table if successful
				salite.actions[string.gsub(file, '.lua', '')] = ret
			else
				-- handle error printing
				print("error importing action code for '" .. file .. "' " .. ret)
			end
		end
	end
end

function salite.actionPlanCompleted(agent, id)
	
	local goals = salite.getgoallist(agent)
	
	--[[ I don't know what this was going to be for or why there's a breadth search but whatever
	local frontier = {}
	for i, k in table.pairsByPriority(goals, 2) do
		-- print(i, table.tostring(k))
	end
	--]]
	
	local goalplanned, currentgoal = false, 1
	while not goalplanned do
		local goal = goals[currentgoal]
		if not salite.goals[ goal[1] ].satisfied(agent) then
			
			-- acquire actions that can satisfy this goal
			local goalacts = salite.goals[ goal[1] ].actions
			
			-- acquire potential objects
			local potential = salite.getpotential(agent, goalacts)
			
			for i, pote in ipairs(potential) do
				local obj = salite.getobject(pote[1])
				-- go over the object and figure out if the action is posssible (with contexts)
				
				-- gather up all contexts
				local neededcont = {}
				for j, act in ipairs(goalacts) do
					if salite.actions[act].reqcont then
						for k, req in ipairs(salite.actions[act].reqcont) do
							if not table.contains(neededcont, req) then
								table.insert(neededcont, req)
							end
						end
					end
				end
				
				-- make sure all contexts are satisfied
				local satisfiedcont = 0
				local notsatisfied = {} -- contexts not satisfied
				-- print(neededcont)
				-- print(table.tostring(neededcont))
				for j, cont in ipairs(neededcont) do
					if salite.actcontext[cont] then
						if salite.actcontext[cont].check and salite.actcontext[cont].check(agent, obj) then
							satisfiedcont = satisfiedcont + 1
						elseif salite.actcontext[cont].check == nil then
							satisfiedcont = satisfiedcont + 1
						else
							table.insert(notsatisfied, cont)
						end
					end
				end
				
				-- add plan to plan and awaken ai
				if satisfiedcont == #neededcont then
					agent.plan = { {pote[2], pote[1]} }
					-- agent.aiagent.awake = true
					return
				end
				
				-- figure out a way of getting the neccesary action plan
				if #notsatisfied > 0 then
					--[[
					local needssat = 0
					
					local potentialactions = {}
					for j, needed in ipairs(notsatisfied) do
						for k, action in pairs(poi.pin.actions) do
							if action.effects and table.contains(action.effects, needed) then
								needssat = needssat + 1
								table.insert(potentialactions, k)
							end
						end
					end
					
					if needssat == #notsatisfied then
						print('found neccesary action: '..potentialactions[1])
					end
					--]]
					local newplan = salite.findPotentialActionPlan(notsatisfied, agent, obj, 0)
					table.insert(newplan, {pote[2], pote[1]})
					
					agent.plan = newplan
					-- agent.aiagent.awake = true
					return
				end
				
			end
			
			
		end
		
		currentgoal = currentgoal + 1
		if currentgoal > #goals then goalplanned = true end
	end
end

function salite.actionPossible(agent, target, action)
	local obj = salite.getobject(target)
	
	-- for i, k in pairs(poi.pin.actions) do
	-- local count = 0
	-- print(action, target, table.tostring(obj))
	if poi.pin.actions[action].reqcomp and table.has(obj, poi.pin.actions[action].reqcomp) then
		
		-- get all conts
		local reqconts = {}
		-- get normal contexts
		if poi.pin.actions[action].reqcont then 
			for i, c in ipairs(salite.actions[action].reqcont) do table.insert(reqconts, c) end
		end
		-- get dynamic contexts
		if poi.pin.actions[action].dynreqcont then
			for i, k in ipairs(salite.actions[action].dynreqcont(agent, obj, env)) do
				table.insert(reqconts, k)
			end
		end
		
		-- get current conts with dynamic contexts
		local satconts = {}
		for i, cont in ipairs(reqconts) do
			-- for dynamic
			local ind = string.find(cont, ':')
			if ind then
				local cc = string.sub(cont, 1, ind-1)
				
				if salite.actcontext[cc].dyncheck then
					local dd = salite.actcontext[cc].dyncheck(agent, obj, env)
					for j, d in ipairs(dd) do
						table.insert(satconts, d)
					end
				end
			end
			
			-- for normal
			if salite.actcontext[cont] and salite.actcontext[cont].check and salite.actcontext[cont].check(agent, obj) then
				table.insert(satconts, cont)
			end
		end
		
		-- check requirements against contexts
		local needed = {}
		local amountsat = 0
		for k, req in ipairs(reqconts) do
			if table.contains(satconts, req) then
				-- this condition is satisfied!
				amountsat = amountsat + 1
			else
				table.insert(needed, req)
			end
		end
		return (amountsat == #reqconts), needed
		
	end
	-- end
	--[=[
	for i, k in pairs(poi.pin.actions) do
		if poi.pin.actions[i].reqcomp and table.has(rawent, poi.pin.actions[i].reqcomp) then
			
			
			if count == ent.actselect then
				-- get all conts
				local reqconts = {}
				-- get normal contexts
				if poi.pin.actions[i].reqcont then 
					for i, c in ipairs(poi.pin.actions[i].reqcont) do table.insert(reqconts, c) end
				end
				-- get dynamic contexts
				if poi.pin.actions[i].dynreqcont then
					for i, k in ipairs(poi.pin.actions[i].dynreqcont(ent, e, env)) do
						table.insert(reqconts, k)
					end
				end
				
				-- get current conts with dynamic contexts
				local dyns = {}
				for i, cont in ipairs(reqconts) do
					local ind = string.find(cont, ':')
					if ind then
						local cc = string.sub(cont, 1, ind-1)
						
						if poi.pin.actcontext[cc].dyncheck then
							local dd = poi.pin.actcontext[cc].dyncheck(ent, e, env)
							for i, d in ipairs(dd) do
								table.insert(dyns, d)
							end
						end
					end
				end
				
				-- get reqs
				for k, req in ipairs(reqconts) do
					
					print(req, table.tostring(dyns))
					if table.contains(dyns, req) then
						print('has '..req)
					end
					--[[
					if not table.contains(reqconts, req) then
						table.insert(neededcont, req)
					end
					--]]
				end
				
				-- start action
				ent.aiagent.action = i
				ent.aiagent.target = target
				ent.aiagent.awake = true
				poi.pin.callAction('start', ent)
			end
			
			count = count + 1
			
		end
	end
	--]=]
	
end
function salite.findPotentialActionPlan(contexts, ent, obj)
	local needssat = 0
	
	local potentialactions = {}
	for j, needed in ipairs(contexts) do
		for k, action in pairs(salite.actions) do
			if
				(action.effects and table.contains(action.effects, needed)) or
				(action.dyneffects and table.contains(action.dyneffects(obj), needed))
			then
				needssat = needssat + 1
				table.insert(potentialactions, k)
			end
		end
	end
	
	if needssat == #contexts then
		-- check if action is possible
		
		-- gather contexts
		local act = potentialactions[1]
		local neededcont = {}
		if salite.actions[act].reqcont then
			for k, req in ipairs(salite.actions[act].reqcont) do
				if not table.contains(neededcont, req) then
					table.insert(neededcont, req)
				end
			end
		end
		
		-- check all contexts
		local satisfiedcont = 0
		local notsatisfied = {} -- contexts not satisfied
		for j, cont in ipairs(neededcont) do
			if salite.actcontext[cont] then
				print('checking contexts', ent, obj)
				if salite.actcontext[cont].check(ent, obj) then
					satisfiedcont = satisfiedcont + 1
				else
					table.insert(notsatisfied, cont)
				end
			end
		end
		
		-- this is a good action
		if satisfiedcont == #neededcont then
			return { {act, obj._id} }
		end
		
		-- figure out a way of getting the neccesary action plan
		if #notsatisfied > 0 then
			-- print('not satisfied '..table.tostring(notsatisfied))
			local r = salite.findPotentialActionPlan(notsatisfied, ent, obj)
			table.insert(r, {act, obj._id})
			return r
		end
	end
end
function salite.checkPotentialObject(objectid, actions)
	local object = salite.getobject(objectid)--poi.ecs.getRawCopyEnity(objectid)
	-- iterate over action's required components
	local satisfiedacts = 0
	for j, act in ipairs(actions) do
		-- okay, so, like, I'm trying to make this system indipendant
		-- but I can't seem to find an easy answer... so fuck it, I'm
		-- hardcoding this into a object/objectdef system: if it's got
		-- an id then check if the object's data has the component;
		-- otherwise just use the entity object components. it's
		-- rubbish but maybe I'll change it later \_( -v-)_/
		--     P.S. this means that if an agent has an id for it's
		-- species and the species definition include a 'food'
		-- component: other agents could eat that agent...
		if object.id then 
			local obj = _objdata[object.id]
			for cid, comp in pairs(obj) do
				local has = true
				for i, r in ipairs(salite.actions[act].reqcomp) do
					if cid ~= r then has = false break end
				end
				if has then
					satisfiedacts = satisfiedacts + 1
					return act -- w-what? why is it doing this
				end
			end
		end
		
		-- if this need is satisfied, mark so
		if table.has(object, salite.actions[act].reqcomp) then
			satisfiedacts = satisfiedacts + 1
			return act -- so it's returning without considering 'satisfiedacts'? why?
		end
	end
	
	-- if the amount satisfied is the same as the amount of actions overall, return potential object
	if satisfiedacts == #actions then
		return true
	end
	return false
end
function salite.callAction(funct, ent, ...) -- not valid atm
	-- local ai = ent.aiagent
	if #ent.plan > 0 then --ai.awake then
		local act = ent.plan[1]
		local action = act[1]
		local target = act[2]
		
		local done = false
		if action and salite.actions[action] and salite.actions[action][funct] then
			done = salite.actions[action][funct](ent, target, ...)
		end
		
		-- current action is completed
		if action == nil or target == nil then done = true end
		if done then
			if #ent.plan > 0 then
				table.remove(ent.plan, 1)
				salite.callAction('start', ent)
			else
				--ent:call('actionPlanCompleted') -- old ecs specific
			end
		end
		
	else
		salite.actionPlanCompleted(ent, ent._id)
	end
end


return salite