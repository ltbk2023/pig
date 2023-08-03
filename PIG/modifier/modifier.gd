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

# Contain information if employee can be attached to specific modifier.
# Should check if employee doesn't have excluding modifiers.
# Can be overridden in derived class.
func _can_be_attached(employee_hook: Hook) -> bool:
	return true

# Attach employee to modifier. Return false if action fail.
func attach_employee(employee_hook: Hook) -> bool:
	if self._can_be_attached(employee_hook):
		var hook = Hook.new()
		hook.set_origin(owner)
		$EmployeesHooks.add_child(employee_hook)
		employee_hook.get_origin().add_modifier(hook)
		return true
	else:
		return false

# Delete employee hook in modifier
# Return false if operation was unsuccessful
func remove_employee(employee: Employee) -> bool:
	for employee_hook in $EmployeesHooks.get_children():
		if employee_hook.get_origin() == employee:
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
