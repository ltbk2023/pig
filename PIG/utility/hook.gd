extends Node
class_name Hook

# if true hook will set origin to parent on ready
@export var auto_connect = false

# origin that can be access via hook
# null represent unset hook
var __origin = null

func _ready():
	if auto_connect:
		set_origin(get_parent())

#set origin and change name to HookTo<<origin.name>>
#if origin has been set before will print warning before setting
func set_origin(origin:Node):
	# if origin is set print warning and proced
	if __origin != null:
		print("Warning: You shouldn't change origin")
	__origin = origin
	#godot hadle identical name in one parent by adding number at end 
	name = "HookTo"+origin.name


#return orgin
#if orging is not set will return null and print warning
func get_origin():
	#if orgin is not set print warning and return null
	if __origin == null:
		print("Warning: Origin is not set")
	return __origin
