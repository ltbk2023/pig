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

# Remove an Employee from the Employees node. If delete_node is true, the Employee node will
# also be deleted.
func remove_employee(employee: Employee, delete_node: bool):
		if delete_node:
			employee.queue_free()
		else:
			$Background/Employees.remove_child(employee)
		
	
