extends Node2D
class_name Issue
signal assign(owner)

enum IssueType {FEATURE, BUG_ISSUE}
# decription is used in Summary
var type_description = {
	IssueType.FEATURE:"[color=BLACK]FEATURE[/color]",
	IssueType.BUG_ISSUE:"[color=DARK_RED]BUG ISSUE[/color]"
}

enum IssueState {UNAVAILABLE, IN_BACKLOG, IN_PROGRESS, COMPLETED}
# decription is used in Summary
var  state_descriptions = {
	IssueState.UNAVAILABLE: "[color=DARK_RED]N/A[/color]",
	IssueState.IN_BACKLOG:"[color=DARK_BLUE]in backlog[/color]",
	IssueState.IN_PROGRESS: "[color=GOLD]in progres[/color]",
	IssueState.COMPLETED: "[color=DARK_GREEN]completed[/color]",
}

@export var type:IssueType
@export var state:IssueState
@export_range(1,4) var difficulty = 1
@export_range(1,3) var time = 1
# This variable represents the importance of the issue to the client. It is
# used to calculate the client's happiness after a sprint
@export var importance_to_client: int = 0
var __progress = 0

# Specifies how many of this node's parents in the issue tree have not been
# finished yet
var remaining_parents: int
# An array containing this issue's children in the issue tree
var child_issues: Array[Issue]

# Signal that will be emitted when the Extended node is being either shown or 
# hidden.
# extending - set to true if the Extended node is BEING set to visible
signal extending(owner, extending)

# Called when the node enters the scene tree for the first time.
func _ready():
	update_summary()
	update_extended()
	remaining_parents = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func get_progress():
	return self.__progress

# set visibility of extended description to v
func set_visibility_on_exteded_desription(v):
	$Extended.visible = v
	emit_signal("extending", self, v)

# update summary text
# summary include type, name, difficulty, time, state
func update_summary():
	$Summary.text =  type_description[type]+" [color=BLACK]"+name+"  D "\
	+str(difficulty)+" / T "+str(time) + "[/color] " + \
	state_descriptions[state] 

# update extended text
# update assigned to text and assign button
func update_extended():
	$Extended/Sprite2D2/Unlocks.visible = false
	if state == IssueState.COMPLETED:
		$Extended/Sprite2D2/AssignButton.visible = false
		$Extended/Sprite2D2/AssignButton.disabled = true
		$Extended/Sprite2D2/Assignment.text = "[color=BLACK]Done"
	elif state == IssueState.UNAVAILABLE:
		$Extended/Sprite2D2/AssignButton.visible = false
		$Extended/Sprite2D2/AssignButton.disabled = true
		$Extended/Sprite2D2/Assignment.text = "[color=BLACK]Unavailable"
	elif $EmployeeHook.get_child_count(0)  and not \
	$EmployeeHook.get_child(0).is_queued_for_deletion():
		$Extended/Sprite2D2/AssignButton.text = "Cancel"
		$Extended/Sprite2D2/Assignment.text = "[color=BLACK]Assigned to " + $EmployeeHook.get_child(0).get_origin().name
	else:
		$Extended/Sprite2D2/AssignButton.text = "Assign"
		$Extended/Sprite2D2/Assignment.text = "[color=BLACK]Not assigned"
	if child_issues:
		$Extended/Sprite2D2/Unlocks.visible = true
		$Extended/Sprite2D2/Unlocks.text = "[color=BLACK]Unlocks: "
		for i in range(len(child_issues) -1):
			$Extended/Sprite2D2/Unlocks.text += str(child_issues[i].name) + ", "
		$Extended/Sprite2D2/Unlocks.text += str(child_issues[-1].name)
		
# Called when progress is to be increased. If the progress exceeds the time,
# complete() is called
func add_progress(progress):
	self.__progress += progress
	if self.__progress >= self.time:
		complete()
		
# This function handles the issue's completion
func complete():
	self.state = IssueState.COMPLETED
	unassign_employee()
	if type == IssueType.FEATURE:
		for child in child_issues:
			child.on_parent_completed()
		
# Called by the issue's tree parent when the parent is completed.
func on_parent_completed():
	remaining_parents -= 1
	if remaining_parents == 0:
		self.state = IssueState.IN_BACKLOG
		update_summary()
		update_extended()
		
# when button is realised toggle extended description visibility
func _on_button_button_up():
	set_visibility_on_exteded_desription(not $Extended.visible)

# sends issue assign signal to the higher part of the tree
# final destination should be backlog
func _on_assign_button_button_up():
	if $EmployeeHook.get_child_count() == 0:
		emit_signal("assign", self)
	else:
		# When the button is actually a cancel button
		var employee = $EmployeeHook.get_child(0).get_origin()
		if not employee.unassign_issue():
			print("Warning: Cannot unassign issue")
		cancel()

# Assigns employee to issue and returns true
# returns false if not possible
# update visual if needed
func assign_employee(hook: Hook):
	if check_employee_can_be_assigned():
		$EmployeeHook.add_child(hook)
		state = IssueState.IN_PROGRESS
		update_summary()
		update_extended()
		return true
	else:
		return false
	
# checks number of tasks assigned already to the employee and returns false if there are any
func check_employee_can_be_assigned():
	return $EmployeeHook.get_child_count() == 0
	
# Unassign employee from this issue. Return bool indicating whether successful
func unassign_employee() -> bool:
	if not check_employee_can_be_assigned():
		$EmployeeHook.get_child(0).queue_free()
		update_summary()
		update_extended()
		return true
	return false
	
# Unassign issue from employee without completing it
func cancel():
	state = IssueState.IN_BACKLOG
	unassign_employee()

func to_json():
	var dictionary = {
		"class": "Issue",
		"name": name,
		"remaining parents": remaining_parents,
		"child_issues": child_issues,
		"description": $Extended/Sprite2D2/Description.text,
		"difficulty": difficulty,
		"time": time,
		"state": state,
		"importance to client": importance_to_client,
		"progress": __progress,
		"type": type
	}
	var json_string = JSON.stringify(dictionary, "\t")
	return json_string
