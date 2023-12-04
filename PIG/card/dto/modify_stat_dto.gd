extends Resource
# stores information to create ModifyStat
class_name ModifyStatDTO

var employee
var stat
var stat_value
var duration

func load(list):
	employee = list[0]
	stat = list[1]
	stat_value = list[2]
	duration = list[3]

func to_json():
	return [employee,stat,stat_value,duration]

func create_and_fill_copy(reference)->ModifyStatDTO:
	var dto = ModifyStatDTO.new()
	dto.employee = reference[employee]
	dto.stat = stat
	dto.stat_value =stat_value
	dto.duration =duration
	return dto

func create_modifier():
	var s = Utility.str_to_stat(stat)
	var modifier = preload("res://modifier/employee_stat_modifier.tscn").instantiate()
	modifier.initialize(s, stat_value, duration)
	return modifier
