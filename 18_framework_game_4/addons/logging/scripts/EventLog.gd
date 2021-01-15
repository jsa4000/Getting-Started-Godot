extends Reference
class_name EventLog

const STRING_FORMAT : String ="EventLog{timestamp:%s,type:%s,payload:%s}"

var timestamp : int
var type : String
var payload : Dictionary
#var key : String // Idempotent and per event management

func _init(type: String , payload : Dictionary):
	self.timestamp = OS.get_ticks_msec()
	self.type = type
	self.payload = payload

func _to_string() -> String:
	return STRING_FORMAT % [timestamp,type,payload]
