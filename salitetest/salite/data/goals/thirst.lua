function _goal.satisfied(agent, env) -- env being the blackboard (?)
	return (agent.primal.thirst <= 0)
end
function _goal.priority(agent, env) 
	return (agent.primal.thirst * 10)
end

-- list of actions that can quench the need
_goal.actions = {'drink'}