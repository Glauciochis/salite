function _goal.satisfied(agent, env) -- env being the blackboard (?)
	return (agent.primal.exhaustion <= 0)
end
function _goal.priority(agent, env) 
	return (agent.primal.exhaustion * 2)
end

-- list of actions that can quench the need
_goal.actions = {'sleep'}