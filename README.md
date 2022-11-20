# Salite
GOAP style modular action planner written in lua.


OBJECTs are world objects that store information of some sort and are used to accomplish goals and are used in actions.
AGENTs are world objects (or not, but if they are then they can interact with one another) which are used by the planner to determine needs and action plans.

All objects (and by proxy agents) need an identifier that can be used to find it as well as stored in action plans and the like.
