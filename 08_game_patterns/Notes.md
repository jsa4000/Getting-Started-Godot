# Godot - Patterns

## Entity/Component Pattern in Godot

Actor (Entity)
	[Components]
	StateMachine
		[States]
	Invoker
		[Actions]
	Persister
	...
	Behaviour?
	Characteristics?
	

Components:
- Components must extends from `component`. 
- Base class Component sets automatically the instance in the "components" group.
- Each component must specify its own name, so it will be used by the actors, manager or other components.
