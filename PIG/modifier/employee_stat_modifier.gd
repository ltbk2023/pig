extends Modifier
class_name EmployeeStatModifier

enum STAT {QUALITY, SPEED, TESTING, MORALE}

var __stat_value: int
var __stat_type: STAT

# Initialize an EmployeeStatModifier object
# Type defines what statistic is changed by modifier
# Value is the amount of points which modifier changes the statistic
# Turn counter decides how many turns the modifier will live
func _init(type: STAT, value: int, turn_counter: int):
	self.__stat_type = type
	self.__stat_value = value
	self.__turn_counter = turn_counter

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Override modify from Modifier class
# TODO: call method, that causes modification of stat in Employee
func modify():
	match self.__stat_type:
		STAT.QUALITY:
			pass
		STAT.SPEED:
			pass
		STAT.TESTING:
			pass
		STAT.MORALE:
			pass
