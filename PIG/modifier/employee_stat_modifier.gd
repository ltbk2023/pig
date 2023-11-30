extends Modifier
class_name EmployeeStatModifier

enum STAT {QUALITY, SPEED, TESTING, MORALE}

var __stat_value: int
var __stat_type: STAT

# Initialize an EmployeeStatModifier object
# Type defines what statistic is changed by modifier
# Value is the amount of points which modifier changes the statistic
# Turn counter decides how many turns the modifier will live
func initialize(type: STAT, value: int, turn_counter: int):
	self.__stat_type = type
	self.__stat_value = value
	self.__turn_counter = turn_counter

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Override modify from Modifier class
# IMPORTANT: This is called by the attach_employee function. You must make sure
# to add the modifier to the tree before calling attach_employee.
# Use ModifierHanlder.handle
func modify():
	var employees = get_employees()
	for employee in employees:
		employee.modify_stat(__stat_type, __stat_value, false)
		# If morale is modified, then its consequence should take place
		# immediately instead of watiting for the next turn
		if __stat_type == STAT.MORALE:
			get_tree().call_group("ModifierHandlers", "morale_modify_stats", employee)

# Override detach_modification method from Modifier class
func detach_modification():
	var employees = get_employees()
	for employee in employees:
		employee.modify_stat(__stat_type, -__stat_value, false)
		remove_employee(employee)
