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
func modify():
	var employees : Array[Employee] = get_employees()
	for employee in employees:
		match self.__stat_type:
			STAT.QUALITY:
				employee.quality += __stat_value
			STAT.SPEED:
				employee.speed += __stat_value
			STAT.TESTING:
				employee.testing += __stat_value
			STAT.MORALE:
				employee.morale += __stat_value
		employee.update_summary()

# Override detach_modification method from Modifier class
func detach_modification():
	var employees : Array[Employee] = get_employees()
	for employee in employees:
		match self.__stat_type:
			STAT.QUALITY:
				employee.quality -= __stat_value
			STAT.SPEED:
				employee.speed -= __stat_value
			STAT.TESTING:
				employee.testing -= __stat_value
			STAT.MORALE:
				employee.morale -= __stat_value
		employee.update_summary()
		remove_employee(employee)
