extends Node2D
class_name Office
# signal containing owner, which should be employee, who is being assigned to the issue
signal assign(owner)

## This script handes operations on the Office scene, such as viewing details
## about the employees, scrolling the background, etc.

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
# Add an employee to the scene. Should be called from the Game script.
# connect assign signal to _on_assign for added employee
func add_employee(employee: Employee):
	$Background/Employees.add_child(employee)
	employee.assign.connect(_on_assign)

# Remove an Employee from the Employees node. If delete_node is true, the Employee node will
# also be deleted.
func remove_employee(employee: Employee, delete_node: bool):
	if delete_node:
		employee.queue_free()
	else:
		$Background/Employees.remove_child(employee)
		
	
# Get a list of all Employees attached to the scene.
func get_employees() -> Array[Node]:
	return $Background/Employees.get_children()

# sends signal with employee-owner to higher part of tree which should be Game
func _on_assign(owner):
	emit_signal("assign", owner)
