extends Node2D
class_name Modifier

var __turn_counter : int = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Inform if the modifier is still active
func is_active() -> bool:	
	return not __turn_counter == 0
	
func decrease_counter():
	__turn_counter -= 1

# Main function of modification. Will be overridden in derived class
# Should call out right employees.
func modify():
	print("Warning: It's Base Modifier.")

# Called when the modifier is detached from the employee. Should call the right
# employees
func detach_modification():
	print("Warning: It's Base Modifier.")

# Contain information if employee can be attached to specific modifier.
# Should check if employee doesn't have excluding modifiers.
# Can be overridden in derived class.
func _can_be_attached(employee_hook: Hook) -> bool:
	return true

# Attach employee to modifier. Return false if action fail.
func attach_employee(employee: Employee) -> bool:
	var employee_hook = Hook.new()
	employee_hook.set_origin(employee)
	if self._can_be_attached(employee_hook):
		var hook = Hook.new()
		hook.set_origin(self)
		$EmployeesHooks.add_child(employee_hook)
		employee_hook.get_origin().add_modifier(hook)
		modify()
		return true
	else:
		return false

# Delete employee hook in modifier
# Return false if operation was unsuccessful
func remove_employee(employee: Employee) -> bool:
	for employee_hook in $EmployeesHooks.get_children():
		if employee_hook.get_origin() == employee:
			employee.remove_modifier(self)
			employee_hook.queue_free()
			return true
	return false

# Delete all employee hooks in modifier
# Call remove_modifier form employee
func delete_all_hooks():
	for employee in $EmployeesHooks.get_children():
		employee.get_origin().remove_modifier(self)
		$EmployeesHooks.remove_child(employee)
		employee.queue_free()

# Return list of employees
func get_employees():
	var employees = []
	for employee_hook in $EmployeesHooks.get_children():
		employees.append(employee_hook.get_origin())
	return employees	
