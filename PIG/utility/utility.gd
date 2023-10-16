extends Object
class_name Utility

static func delete_children(node: Node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()

# load JSON state of whole game from file in host file system
static func load_from_file(file_name: String) -> Dictionary:
	var file = FileAccess.open(file_name, FileAccess.READ)
	var content = file.get_as_text()
	var json = JSON.new()
	var error = json.parse(content)
	if error == OK:
		var data_received = json.data
		data_received["error"] = null
		return data_received
	else:
		print("JSON Parse Error: ", json.get_error_message(), " in ", content, \
		" at line ", json.get_error_line())
		return {"error": "JSON Parse Error"}

# load JSON state of whole game from resource in internal file system
static func load_from_resource(name:String) -> Dictionary:
	return load(name).data
