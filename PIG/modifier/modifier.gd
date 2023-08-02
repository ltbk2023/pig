extends Node2D
class_name Modifier

var __turn_counter : int = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Inform if the modifier is still active
func is_active() -> bool:
	if __turn_counter == 0:
		return false
	else:
		__turn_counter -= 1
		return true

# Main function of modification. Will be overridden in derived class
# Should call out right employees.
func modify():
	print("Warning: It's Base Modifier.")
