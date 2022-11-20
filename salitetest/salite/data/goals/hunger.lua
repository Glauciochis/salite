function _goal.satisfied(self, env) -- env being the blackboard (?)
	return (self.primal.hunger <= 0)
end
function _goal.priority(agent, env) 
	return (agent.primal.hunger * 5)
end

-- list of actions that can quench the need
_goal.actions = {'eat'}