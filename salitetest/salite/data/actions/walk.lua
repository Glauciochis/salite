--_action.reqcomp = {'transform'} -- components
_action.effects = {'close'} -- context
function _action.update(agent, target, _dt)
	local tarent = salite.getobject(target)--poi.ecs.getEntity(target)
	local r = math.atan2(tarent.y-agent.y, tarent.x-agent.x)
	local x, y = math.cos(r), math.sin(r)
	agent.x = agent.x + (40 * _dt * x)--+ (25 * _dt * ((agent.x < target) and 1 or -1))
	agent.y = agent.y + (40 * _dt * y) --+ (25 * _dt * ((agent.x < target) and 1 or -1))
	
	if math.abs(agent.x - tarent.x) < 1 and math.abs(agent.y - tarent.y) < 1 then
		agent.x = tarent.x
		agent.y = tarent.y
		
		return true
	end
end