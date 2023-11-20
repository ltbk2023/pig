extends Node
class_name ModifierHandler

# min and max stat multipliers related to morale
@export_group("Modifier ranges")
# (stat += morale * multiplier)
@export var stat_multiplier_min = 0.25
@export var stat_multipier_max = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func handle(modifier: Modifier):
	add_child(modifier)
	
func morale_modify_stats(employee):
	if employee.morale != 0:
		# Get random stat excluding MORALE
		var stat = \
		randi_range(0, EmployeeStatModifier.STAT.size() - 2)
		var value_f = \
		randf_range(stat_multiplier_min, stat_multipier_max) * employee.morale
		# Round value_f towards positive or negative infinity
		var value = \
		sign(value_f) * ceil(abs(value_f))
		modify_employee_stat(employee, stat, value, 1)
			
func modify_employee_stat(employee: Employee,
	stat: EmployeeStatModifier.STAT, value: int, duration: int):
	var modifier =\
	preload("res://modifier/employee_stat_modifier.tscn").instantiate()
	handle(modifier)
	modifier.initialize(stat, value, duration)
	modifier.attach_employee(employee)
