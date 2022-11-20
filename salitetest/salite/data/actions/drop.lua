_action.reqcomp = {'tileobject'}
_action.reqcont = {'holding'}
-- _action.effects = {'close'}
function _action.start(agent, target)
	agent.progress = 0
end
function _action.update(agent, target, _dt)
	agent.progress = agent.progress + _dt
	agent.tileagent.anim = 'pickup'
	if agent.progress >= 1 then
		poi.pin.world.moveObject(target, agent.tileagent.room, agent.transform.x)
		agent.tileagent.anim = 'idle'
		return true
	end
end