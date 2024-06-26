extends Object
class_name Utility

const __stat_dictionary: Dictionary = \
{
	"morale": EmployeeStatModifier.STAT.MORALE,
	"quality": EmployeeStatModifier.STAT.QUALITY,
	"speed": EmployeeStatModifier.STAT.SPEED,
	"testing": EmployeeStatModifier.STAT.TESTING
}

const __stat_to_string_dictionary: Dictionary = \
{
	EmployeeStatModifier.STAT.MORALE: "morale",
	EmployeeStatModifier.STAT.QUALITY: "quality",
	EmployeeStatModifier.STAT.SPEED: "speed",
	EmployeeStatModifier.STAT.TESTING: "testing"
}

static func delete_children(node: Node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()

# load JSON state of whole game from file in host file system
static func load_from_file(file_name: String):
	var file = FileAccess.open(file_name, FileAccess.READ)
	var content = file.get_as_text()
	var json = JSON.new()
	var error = json.parse(content)
	if error == OK:
		var data_received = json.data
		if data_received is Dictionary:
			data_received["error"] = null
		return data_received
	else:
		print("JSON Parse Error: ", json.get_error_message(), " in ", content, \
		" at line ", json.get_error_line())
		return {"error": "JSON Parse Error"}

# load JSON state of whole game from resource in internal file system
static func load_from_resource(name:String):
	return load(name).data
		
# Returns an employee stat value corresponding to stat_string (case insensitive)
static func str_to_stat(stat_string: String) -> EmployeeStatModifier.STAT:
	return __stat_dictionary[stat_string.to_lower()]

static func stat_to_str(stat: EmployeeStatModifier.STAT) -> String:
	return __stat_to_string_dictionary[stat]
