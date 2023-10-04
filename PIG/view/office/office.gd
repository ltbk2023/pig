extends Node2D
class_name Office
# signal containing owner, which should be employee, who is being assigned to the issue
signal assign(owner)

## This script handes operations on the Office scene, such as viewing details
## about the employees, scrolling the background, etc.

# Signal sent up the tree then an employee (owner) has completed an issue.
# Should be caught by Game.
signal completed(owner, issue, quality)

@export var employee_visual_separation: Vector2 = Vector2(0, 100)

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
	employee.extending.connect(_on_extending)
	employee.completed.connect(_on_completed)
	set_employee_position(employee, $Background/Employees.get_child_count() - 1)
	
# Set the position of the Employee with respect to the Employees node.
# position - position of the employee {0, 1, 2, ...}
func set_employee_position(employee: Employee, position_number: int):
	employee.position = position_number * employee_visual_separation
	
# Update the employees' position so that there are no free spaces between them
func update_employee_positons():
	var i = 0
	for employee in $Background/Employees.get_children():
		set_employee_position(employee, i)
		i += 1
		
# Remove an Employee from the Employees node. If delete_node is true, the Employee node will
# also be deleted.
func remove_employee(employee: Employee, delete_node: bool):
	if delete_node:
		employee.queue_free()
	else:
		$Background/Employees.remove_child(employee)
	update_employee_positons()
		
		
	
# Get a list of all Employees attached to the scene.
func get_employees() -> Array[Node]:
	return $Background/Employees.get_children()

# sends signal with employee-owner to higher part of tree which should be Game
func _on_assign(owner):
	emit_signal("assign", owner)
	
# Called when the node has received an extending signal from one of the employees.
# Hides the other employees
# On extending equal true owner is moved to (0,0)
# Otherwise update_employee_positons is called to restore normal positions
func _on_extending(owner, extending):
	for employee in $Background/Employees.get_children():
			employee.visible = employee == owner or not extending 
	if extending:
		owner.position = Vector2(0,0)
	else:
		update_employee_positons()

	
# sends "completed" signal to the higher part of the tree without modifying
# the parameters. Should be caught Game.
func _on_completed(owner, issue, quality):
	emit_signal("completed", owner, issue, quality)
