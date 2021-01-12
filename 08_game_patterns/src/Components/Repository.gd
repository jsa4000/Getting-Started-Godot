tool
extends Component
class_name Repository

const COMPONENT_NAME : String = "repository"
const COMPONENT_GROUP : String = "repositories"

func _init().():
	_component_name = COMPONENT_NAME
	_component_group = COMPONENT_GROUP
	add_to_group(_component_group)
	
func save_data() -> Dictionary:	
	logger.error("Error. Method not implemented", self)
	return Dictionary()
	
func load_data(data : Dictionary):
	logger.error("Error. Method not implemented", self)
