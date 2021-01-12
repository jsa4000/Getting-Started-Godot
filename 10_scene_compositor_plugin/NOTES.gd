"""
********************************************
* NOTES
********************************************

SLOTS:
	
	Nodes are composed by slots plus properties or constants. Slots are the basic abstraction for nodes
	to represent input or outputs that can be connected to the node. Those inputs and outputs can be connected
	to another node depending no some constraints (optional, mandatory, etc..)
	
	Slots act as a place holders for the nodes to control de flow data, variables, events, connections, etc..
	The Node creates the slots based on the definition and set the connections depending on the user interaction.
	
	Properties:
		
		- Id: unique identifier for the current slot, this is the absolute slot based on the node hierarchy:
		  inputs, outputs, extra, etc..
		- ConnectionType: INPUT, OUTPUT, EXTRA, etc.. This is an integer, since the Node has the control over the typers.
		- SlotNumber: The number of the slot relative to the connection type.
		- Connection: The connection between the current node/slot and the other node/slot. The direction will depend on 
		  the ConnectionType, if this is an input or output slot the data flows in diferent directions.
		- Control: The slot can hold a control to get the value from if no connection is specified
		
	Events:
		- ValueChanged. The slot will trigger an event if the value or data changes. it is connected to the channel (connection) and the 
		  control to receive event if the values is modified. 
		
	Methdos:
		- getvalue(): receiveds the data from the slot. If the slot is connected to another node, then this will send
		a reequest to the node to get the information. If there is no connection the slot will get the value from the 
		control if exists. Null if there is no control no connection.
		- setValue(): Set the value for this Slot. This will modify the value of the  slot, change the value of the
		control if exist and triggers the event ValueChanged. This event must not be taken into account if the node 
		changes the parameter so there is no loop betwen them.

	The User Inteface for this class has differnt vales to customize the Control itself. For example, the text for the
	label, the alignment, etc...

CONTROLS:

TODO

- Add Controls behaviour. 
	- Create a BaseControl Scene so control can inherits from it: get_value, set_value, value_changed 
	  signal, etc.. [DONE]
	- Think about adding set and get dinamically to export variables [DONE]
	- Connect to value_changed signal and Trigger signal within the main control. [DONE]
	- Fix Promoting Properties from childs (via export).
		https://godotengine.org/qa/23644/is-there-a-way-to-add-exported-variables-to-a-group
		https://www.reddit.com/r/GodotArchitecture/comments/cyu1t1/interesting_use_oftricks_to_export_var/
- Create BoolNode [DONE]
- Multiple remote input and outputs to be plugged into slots.
- Create a Preview into the nodes to visualize the outputs.
- Add debug mode and warnnings into the nodes so it can be seen there is any error.
- Fix creating Controls from Editor (as SCenes), so it support slots and save/load behaviour.
- Add Nodes bahaviour when some change has been done or the Run command has been pressed.
	- Currently, pageEditor throws an event with the whole graph editor. It must be only 
	  take care of the nodes nor the connections in the used interface. MVC (Model-Controller-View)
	- It must take the nodes without outputs or the "Final" nodes to be able to generate data. However
	  between nodes they could generate intermediate outputs so it can be previewed.
	- This will trigger an "exectute()" method in the outputs so they start with the chain and 
	  processing the rest of the nodes.
	- There are some steps (4) to consider when the manager start generating the outputs.
	  0. Check if it has been generated within the same "run" or "transaction". (Initialize?)
	  1. Initialize: Loop over the inputs/slots to start populating the variables. It the input is not
		 connected to any node, take the result directly from the control or whatever properties are used.
	  2. Validate: Check all the variables are correctly loaded so it can finally process the logic.	
	  4. Execute: Process the output/s. The idea is the first node requires the data, the current node
		 stores a cache with the outputs, so the node is not processed again ("run").
	  5- Finalize: If there is something more to do in post-processing.
- Create Managers to perform logic so the user interface and the domain specific logic are decoupled.
- Increase performance in algorithms used to manipulate 3d objects, arrays, etc
- Create Parallel class to peform for loops in parallel. Check godot object are safethreads
- Add spreadsheet to visualize the data inside the nodes: geometry, vertex data, variables, etc..
- Add ui elements such as toogle normals, zoom, etc..
- Interact with nodes and vieweport to manipulate objects such as lines, ligths, positions, etc..
- Refactor the aplications to allow ui elements be subscribed to nodes updates independently.


BACKLOG:

- Add Singletone variables so controls and nodes are instanciated only once. There are some issues
  with cyclic dependencies and loading scenes in Godot, so it must be tested firstly.
- Add some kind to group to the nodes (IMAGE, VECTOR3, VECTOR2, etc..)
- Execute the node graph in parallel, however this can be a problem since it is needed to lock a node
  so a thread wait until the other ends so it can acces to it (in this case to the cache data)
- Refactorize the code to mimic the Object Oriented Programing and some patterns to separate components,
  visual interface from logic, etc.. For example, there is no need to have nodes and slots separately, since
  aa node can have other nodes for inputs and outputs. However GraphNodes are made to store the slots separately
  so it needed to maintain multiple structures at a time. Due to this I have relied in the slot abstraction to
  store inputs and outputs.
- Think on unifyin get_data() within the slotControl, so it will check to get the data from the control or
  for the input, instead of having all the logic in the BaseNode.
- Unify the Control abstraction so all controls inherit from the same base with parameters such as get_data. The idea
  is to avoid as much as possible the duck typing so the errors will prompt in coding time.
- Create a Builder to create properties, slots, etc.. The idea is to remove that logic from the current
  class and create a Manager or Build so it can be easily modified.


"""


