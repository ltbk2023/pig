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

# Signal that will be emitted when the Extended node is being either shown or 
# hidden.
# extending - set to true if the Extended node is BEING set to visible
signal extending(owner, extending)

# Signal emitted when the employee has completed an issue. Quality param
# indicates from which quality preset the quality cards should be added.
# The signal should be caught by Office.
signal completed(owner, issue, quality)

# Called when the node enters the scene tree for the first time.
func _ready():
	__base_quality = quality
	__base_speed = speed
	__base_testing = testing
	
	__base_morale = morale
	randomize()
	update_summary()
	update_extended()
	
	update_task_display()

# update summary text
# summary include name, stats, task's name employee is assigned to 
func update_summary():
	var text = name + \
	"\nQ "+ str(quality) + " / S " + str(speed) + " / T " + str(testing)  + \
	"\nM "+str(morale) 
	if $TaskHook.get_child_count() > 0 and not \
	$TaskHook.get_child(0).is_queued_for_deletion():
		text += "\nA "+$TaskHook.get_child(0).get_origin().name
	$Summary.text = text 


# update extended text
# update assigned to text and assign button
func update_extended():
	# Check if there exists a hook that will not be deleted at the end of the
	# current frame
	if $TaskHook.get_child_count() > 0 and not \
	$TaskHook.get_child(0).is_queued_for_deletion():
		$Extended/AssignButton.text = "Cancel"
		$Extended/Assignment.text = "[color=BLACK]Assigned to "+$TaskHook.get_child(0).get_origin().name
	else:
		$Extended/AssignButton.text = "Assign"
		$Extended/Assignment.text = "[color=BLACK]Not assigned"
	
# Called by the game scene when the turn ends.
func execute_turn():
	if $TaskHook.get_child_count() == 0:
		return
	var task = $TaskHook.get_child(0).get_origin()
	
	# Generate a random speed modifier for this turn
	var speed_modifier = randi() % (max_speed_modifier + 1) 
	+ min_speed_modifier 
	
	if task is Issue:
		task.add_progress(speed + speed_modifier)
		if task.state == Issue.IssueState.COMPLETED:
			unassign_issue()
			emit_signal("completed", self, task, check_quality_preset(task))
	elif task is Testing:
		task.test(testing)
		
# Set the visibility of Extended node to v.
func set_visibility_of_extended_description(v):
	$Extended.visible = v
	emit_signal("extending", self, v)

# Called when the button over the employee sprite is clicked. Toggles the
# Extended node visibility on/off.
func _on_button_button_up():
	set_visibility_of_extended_description(not $Extended.visible)


func _on_assign_button_button_up():
	if $TaskHook.get_child_count() == 0:
		emit_signal("assign", self)
	else:
		# When the button is actually a cancel button
		var task = $TaskHook.get_child(0).get_origin()
		if task is Issue:
			task.cancel()
		elif task is Testing:
			task.unassign_employee(self)
		unassign_issue()

# Assigns issue to an employee and returns true if successful
# update visual if needed
func assign_issue(hook: Hook):
	if check_task_can_be_assigned_to_employee():
		$TaskHook.add_child(hook)
		update_summary()
		update_extended()
		update_task_display()
		return true
	else:
		return false
	
# Counts how many tasks an employee already has, and returns true if none
func check_task_can_be_assigned_to_employee():
	return $TaskHook.get_child_count() == 0
	
# Unassigns issue from the employee. Return bool indicating whether it was
# successful
func unassign_issue() -> bool:
	if not check_task_can_be_assigned_to_employee():
		$TaskHook.get_child(0).queue_free()
		update_summary()
		update_extended()
		update_task_display()
		return true
	return false

# Checks which quality preset should be used after an issue is completed by the
# Employee. Returns the quality preset type
func check_quality_preset(issue: Issue):
	if quality >= issue.difficulty:
		return QualityDeck.QualityPreset.HIGH
	return QualityDeck.QualityPreset.LOW

# check type of task given to employee and call appropriate $Sprite function
func update_task_display():
	if$TaskHook.get_child_count() > 0 and not \
	$TaskHook.get_child(0).is_queued_for_deletion():
		var task = $TaskHook.get_child(0).get_origin()
		if task is Issue:
			$Sprite.display_issue_coding(speed,quality<task.difficulty)
			return
		elif task is Testing:
			$Sprite.display_testing(testing)
			return
	$Sprite.display_idle()
