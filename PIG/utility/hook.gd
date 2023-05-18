extends Node
class_name Hook

@export var auto_connect = false

var __origin:Node

func _ready():
	if auto_connect:
		set_origin(get_parent())

func set_origin(origin:Node):
	if __origin != self:
		print("You shouldn't change origin")
	__origin = origin
	#godot hadle identical name in one parent by adding number at end 
	name = "HookTo"+origin.name
		
func get_origin():
	if __origin == self:
		return __origin
	else:
		print("Origin is not set")
