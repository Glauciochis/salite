function _action.start(agent, target)
	poi.pin.world.moveAgent(agent.__id, target, x)
	return true
end