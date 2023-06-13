extends Node2D
class_name Employee

@export_category("Skills")
@export_range(1,3) var quality = 2 
@export_range(1,3) var speed = 2 
@export_range(1,3) var testing = 2 

@export_category("Morale")
@export var morale = 0

# The vars below define the min and max values of random modifiers.
@export_category("Random modifiers")
@export var min_speed_modifier = -1
@export var max_speed_modifier = 4

var __base_quality
var __base_speed
var __base_testing
var __base_morale

# Declares the intention to assign an issue to this employee
signal assign(owner)

# Called when the node enters the scene tree for the first time.
func _ready():
	__base_quality = quality
	__base_speed = speed
	__base_testing = testing
	
	__base_morale = morale
	
	update_summary()
	randomize()

func update_summary():
	$Summary.text = name + "\nQ "+ str(quality) + " / S " + str(speed) + " / T " + str(testing) + "\nM "+str(morale)
	
# Called by the game scene when the turn ends.
# TODO: differentiate between testing and developing
func execute_turn():
	if $TaskHook.get_child_count() == 0:
		return
	var task = $TaskHook.get_child(0).get_origin()
	
	# Generate a random speed modifier for this turn
	var speed_modifier = randi() % (max_speed_modifier + 1) 
	+ min_speed_modifier 
	
	if task is Issue:
		task.add_progress(speed + speed_modifier)
		
# Set the visibility of Extended node to v.
func set_visibility_of_extended_description(v):
	$Extended.visible = v

# Called when the button over the employee sprite is clicked. Toggles the
# Extended node visibility on/off.
func _on_button_button_up():
	set_visibility_of_extended_description(not $Extended.visible)


func _on_assign_button_button_up():
	emit_signal("assign", self)
