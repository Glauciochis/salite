_action.reqcomp = {'id'}
_action.reqcont = {'close'}
_action.effects = {'holding'}
function _action.start(agent, target)
	agent.progress = 0
end
function _action.update(agent, target, _dt)
	agent.progress = agent.progress + _dt
	if agent.progress >= 1 then
		local tarent = salite.getobject(target)
		table.insert(agent.inv, {_id=target, id=tarent.id, amount=1})
		destroyEntity(tarent._id)
		-- poi.pin.world.moveObject(target, agent.__id, 0)
		return true
	end
end