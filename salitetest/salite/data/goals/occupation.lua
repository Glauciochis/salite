function _goal.satisfied(agent, env) -- env being the blackboard (?)
	return (agent.primal.occupation >= 100)
end
function _goal.priority(agent, env) 
	return math.min(agent.primal.occupation/10, 10)
end

-- list of actions that can quench the need
_goal.actions = {'work'}