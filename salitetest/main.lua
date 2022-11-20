

function love.load()
	_ent = {}
	_objdata = {
		bread = {
			food = 5
		},
		carrotplant = {
			plant = 'carrot'
		},
		carrot = {
			food = 10
		}
	}
	
	salite = require'salite.aiplanner'
	require'salite.init'
	salite.load()
	
	local iid = newentity({
		x=100, y=100,
		agent={
			goals={'hunger'}
		},
		primal={
			thirst=0,
			hunger=30,
			occupation=0,
			exhaustion=0
		},
		inv={}
	})
	newentity({
		x=100, y=150,
		id='bread'
	})
	newentity({
		x=150, y=200,
		id='bread'
	})
	--[[newentity({
		x=150, y=200,
		id='carrot'
	})]]
	
	salite.actionPlanCompleted(_ent[iid], iid)
end
function love.update(_dt)
	
	for id, ent in pairs(_ent) do
		if ent.plan then
			salite.callAction('update', ent, _dt)
		end
	end
	
end
function love.draw()
	
	for id, ent in pairs(_ent) do
		
		local s, hs = 20, 10 -- size, halfsize
		if ent.agent then
			s, hs = 30, 15
			
			love.graphics.setColor(.5,.5,.5)
			love.graphics.rectangle('fill', ent.x-hs, ent.y-hs+2, s, 4)
			love.graphics.setColor(1,.5,0)
			love.graphics.rectangle('fill', ent.x-hs, ent.y-hs+2, s*(ent.primal.hunger/40), 4)
			
			love.graphics.setColor(1,1,1)
		elseif ent.id then
			s, hs = 20, 10
			love.graphics.setColor(1,0,1)
		end
		love.graphics.rectangle('line', ent.x-hs, ent.y-hs, s, s)
		
	end
	
end

function newentity(data)
	_totalent = (_totalent or 0) + 1
	local id = string.format("%x", _totalent)
	data._id = id
	_ent[id] = data
	return id
end
function destroyEntity(id)
	print(id)
	_ent[id] = nil
end

