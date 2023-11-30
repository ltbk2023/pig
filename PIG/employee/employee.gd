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

# Modified stats are directly acted upon by modificators. If a stat has a low
# limit of 0, then the actual stat will never go below that value, even if
# the following variables are negative.
var __modified_quality
var __modified_speed
var __modified_testing

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
	__modified_quality = quality
	__modified_speed = speed
	__modified_testing = testing
	randomize()
	update_summary()
	update_extended()
	
	update_task_display()

# update summary text
func update_summary():
	$Summary.text = name

func _get_additional_text(stat: String, diff: int) -> String:
	if diff == 0:
		return ""
	var color_substring = "[color=DARK_GREEN] + " if diff > 0 else "[color=RED] - "
	diff = abs(diff)
	var base_stat_str = ""
	match stat:
		"quality":
			base_stat_str = str(__base_quality)
		"speed":
			base_stat_str = str(__base_speed)
		"testing":
			base_stat_str = str(__base_testing)
		"morale":
			base_stat_str = str(__base_morale)
	return " [color=BLACK](" + base_stat_str + \
		"[/color]" + color_substring + str(diff) + "[/color][color=BLACK])[/color]"

# update extended text
# update stats visualization
# update assigned to text and assign button
func update_extended():
	$Extended/Name.text = "[font_size=24][color=BLACK][b]"+name+"[/b][/color][/font_size]"
	
	var quality_diff = quality - __base_quality
	var speed_diff = speed - __base_speed
	var testing_diff = testing - __base_testing
	var morale_diff = morale - __base_morale
	
	var additional_text = _get_additional_text("quality", quality_diff)
	$Extended/Quality.text = "[color=BLACK]Quality: [b]"+str(quality)+"[/b][/color]" \
	+ additional_text
	
	additional_text = _get_additional_text("speed", speed_diff)
	$Extended/Speed.text = "[color=BLACK]Speed: [b]"+str(speed)+"[/b][/color]" \
	+ additional_text
	
	additional_text = _get_additional_text("testing", testing_diff)
	$Extended/Testing.text = "[color=BLACK]Testing: [b]"+str(testing)+"[/b][/color]" \
	+ additional_text
	
	additional_text = _get_additional_text("morale", morale_diff)
	if morale > 0:
		$Extended/Morale.text = "[color=BLACK]Morale: [b]+"+str(morale)+"[/b][/color]"
	else:
		$Extended/Morale.text = "[color=BLACK]Morale: [b]"+str(morale)+"[/b][/color]"
	$Extended/Morale.text += additional_text
	
	# Check if there exists a hook that will not be deleted at the end of the
	# current frame
	if $TaskHook.get_child_count() > 0 and not \
	$TaskHook.get_child(0).is_queued_for_deletion():
		$Extended/AssignButton.text = "Cancel"
		$Extended/Assignment.text = "Task: "+$TaskHook.get_child(0).get_origin().name
		$Extended/Assignment.disabled = false
	else:
		$Extended/AssignButton.text = "Assign"
		$Extended/Assignment.text = "Task: Not assigned"
		$Extended/Assignment.disabled = true
		
# Called by the game scene when the turn ends.
func execute_turn():
	if $TaskHook.get_child_count() == 0:
		return
	var task = $TaskHook.get_child(0).get_origin()
	
	# Generate a random speed modifier for this turn
	var speed_modifier = randi() % (max_speed_modifier + 1) \
	+ min_speed_modifier 
	
	if task is Issue:
		task.add_progress(speed + speed_modifier)
		if task.state == Issue.IssueState.COMPLETED:
			unassign_issue()
			emit_signal("completed", self, task, check_quality_preset(task))
	elif task is Testing:
		task.test(testing)
		
# Set the visibility of Extended node to v.
# set sprite scale
# disable/enable button
# calls update_task_display to adapt animation
func set_visibility_of_extended_description(v):
	$Extended.visible = v
	$Button.disabled = v
	$Summary.visible = not v
	if v:
		$Sprite.scale = Vector2(10,10)
	else:
		$Sprite.scale = Vector2(4,4)
	update_task_display()
	emit_signal("extending", self, v)

# Called when the button over the employee sprite is clicked. Toggles the
# Extended node visibility on/off.
func _on_button_button_up():
	set_visibility_of_extended_description(true)
	


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
	
# Add new modifier to employee
func add_modifier(hook: Hook):
	$ModifiersHooks.add_child(hook)

# Remove modifier from employee
# Return false if operation was unsuccessful
func remove_modifier(modifier: Modifier) -> bool:
	for modifier_hook in $ModifiersHooks.get_children():
		if modifier_hook.get_origin() == modifier:
			modifier_hook.queue_free()
			return true
	return false

# Return a JSON dictionary representing this object in its current state
func to_json():
	var assigned_task_name = "" if $TaskHook.get_child_count() == 0 else \
	$TaskHook.get_child(0).get_origin().name
	
	var dictionary = {
		"class": "Employee",
		"name": name,
		"base speed": __base_speed,
		"base quality": __base_quality,
		"base testing": __base_testing,
		"base morale": __base_morale,
		"assigned to": assigned_task_name,
		"description": $Extended/Description.text,
		"visuals": $Sprite.to_json()
	}
	return dictionary
	
func configure_employee(dict: Dictionary) -> bool:
	if dict["class"] == "Employee":
		__base_speed = dict["base speed"]
		__base_quality = dict["base quality"]
		__base_testing = dict["base testing"]
		__base_morale = dict["base morale"]
		name = dict["name"]
		$Extended/Description.text = dict["description"]
		
		speed = __base_speed
		quality = __base_quality
		testing = __base_testing
		morale = __base_morale
		__modified_speed = __base_speed
		__modified_quality = __base_quality
		__modified_testing == __base_testing
		
		# every value from visuals will overwrite it's counterpart from presets
		if dict.has("presets"):
			$Sprite.configure_from_presets(dict["presets"])
		if dict.has("visuals"):
			$Sprite.configure_visuals(dict["visuals"])
		update_summary()
		update_extended()
		return true
	return false

# check type of task given to employee and call appropriate $Sprite function
# if extended is visible task is ignored and display_extended_view is colled
func update_task_display():
	if $Extended.visible:
		$Sprite.display_extended_view()
		return
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

func _on_hide_button_up():
	set_visibility_of_extended_description(false)

func modify_stat(stat: EmployeeStatModifier.STAT, value: int, change_base: bool):
	match stat:
		EmployeeStatModifier.STAT.QUALITY:
			if change_base:
				__base_quality += value if __base_quality + value >= 0  else 0
				quality += value if quality + value >= 0 else 0
			else:
				__modified_quality += value
				quality = __modified_quality if __modified_quality >= 0 else 0
		EmployeeStatModifier.STAT.SPEED:
			if change_base:
				__base_speed += value if __base_speed + value >= 0  else 0
				speed += value if speed + value >= 0 else 0
			else:
				__modified_speed += value
				speed = __modified_speed if __modified_speed >= 0 else 0
		EmployeeStatModifier.STAT.TESTING:
			if change_base:
				__base_testing += value if __base_testing + value >= 0  else 0
				testing += value if testing + value >= 0 else 0
			else:
				__modified_testing += value
				testing = __modified_testing if __modified_testing >= 0 else 0
		EmployeeStatModifier.STAT.MORALE:
			if change_base:
				__base_morale += value
			morale += value
	update_summary()
	update_extended()
	update_morale_visuals()
	
# Smile when happy, frown when unhappy
func update_morale_visuals():
	$Sprite.angry = morale < -1
	$Sprite.smile = morale > 1		
