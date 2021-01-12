extends NodeResource
class_name NodeResourceInteractive

export(Array, Resource) var actions = [Action.new()]

var node : Node

func interact(actor: Actor):
	for action in actions:
		if action is ActionItem:
			action.node = node
			#action.resource = self
		if actor.is_in_group(action.target_group):
			actor.interact(self, action)
