extends Node2D
class_name Office

## This script handes operations on the Office scene, such as viewing details
## about the employees, scrolling the background, etc.

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
# Add an employee to the scene. Should be called from the Game script.
func add_employee(employee: Employee):
	$Background/Employees.add_child(employee)
	
# Get a list of all Employees attached to the scene.
func get_employees() -> Array[Node]:
	return $Background/Employees.get_children()
