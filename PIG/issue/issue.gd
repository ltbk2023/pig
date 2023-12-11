@tool
extends Node2D
class_name Issue
signal assign(owner)

enum IssueType {FEATURE, BUG_ISSUE}
# name of type used in visualisation
var type_name = {
	IssueType.FEATURE:"FEATURE",
	IssueType.BUG_ISSUE:"BUG ISSUE"
}
# tags used in name that depend on type
var type_start = {
	IssueType.FEATURE:"[color=BLACK]",
	IssueType.BUG_ISSUE:"[color=DARK_RED][b]"
}
var type_end = {
	IssueType.FEATURE:"[/color]",
	IssueType.BUG_ISSUE:"[/b][/color]"
}


# represents state of issue
# number represents corresponding frame in state sprite
enum IssueState {UNAVAILABLE=0, IN_BACKLOG=1, IN_PROGRESS=2, COMPLETED=3}
# name of state used in visualisation
var state_name={
	IssueState.UNAVAILABLE:"Blocked",
	IssueState.IN_BACKLOG:"In Backlog",
	IssueState.IN_PROGRESS:"In Progres",
	IssueState.COMPLETED:"Completed"
}
# message in assignment that depends on state
var state_assigned_message={
	IssueState.UNAVAILABLE:"Unlock task before assigning",
	IssueState.IN_BACKLOG:"Not assigned",
	IssueState.COMPLETED:"Already completed"
}

@export var type:IssueType:
	set(t):
		type =t
		if is_inside_tree():
			update_summary()
			update_colors()
@export var state:IssueState
@export_range(1,4) var difficulty = 1
@export_range(1,3) var time = 1
# This variable represents the importance of the issue to the client. It is
# used to calculate the client's happiness after a sprint
@export var importance_to_client: int = 0:
	set(i):
		importance_to_client = i 
		update_importance()

@export_group("Visualization")
# subgroup represents high/low levels of importance
@export_subgroup("importance")
@export var low_importance = 2:
	set(i):
		low_importance = i
		update_importance()
@export var high_importance = 4:
	set(i):
		high_importance = i
		update_importance()
# subgroup represents colors of feature's background
@export_subgroup("feature")
@export var feature_1=Color8(225,235,255):
	set(c):
		feature_1 = c
		update_colors()
@export var feature_2=Color8(205,215,255):
	set(c):
		feature_2 = c
		update_colors()
@export var feature_3=Color8(165,175,255):
	set(c):
		feature_3 = c
		update_colors()
# subgroup represents colors of bug's background
@export_subgroup("bug")
@export var bug_1=Color8(255,235,235):
	set(c):
		bug_1 = c
		update_colors()
@export var bug_2=Color8(255,215,215):
	set(c):
		bug_2 = c
		update_colors()
@export var bug_3=Color8(255,175,175):
	set(c):
		bug_3 = c
		update_colors()
@export_subgroup("Extended")
#set visible tab and move according button
@export_range(0,2) var tab = 0:
	set(t):
		# move buttons
		$Extended/Bottom/Tabs/Buttons.get_child(tab).position.y = 10
		$Extended/Bottom/Tabs/Buttons.get_child(t).position.y = 20
		# switch visible tab
		$Extended/Bottom/Tabs/Content.get_child(tab).visible=false
		$Extended/Bottom/Tabs/Content.get_child(t).visible=true
		
		tab = t
		# set visible background
		$Extended/Bottom/Back1.frame_coords.y = t
		$Extended/Bottom/Back2.frame_coords.y = t
		$Extended/Bottom/Back3.frame_coords.y = t
		

var __progress = 0

# Specifies how many of this node's parents in the issue tree have not been
# finished yet
var remaining_parents: int
# An array containing this issue's children in the issue tree
var child_issues: Array[Issue] = []
# An array containing this issue's parents in the issue tree. 
# Used only in Extended View
var parent_issues: Array[Issue] = []

# If the player assigned the issue to an employee and decides to cancel the
# assignment before the new assignee has made any progress,
# no progress will be subtracted
var was_assigned_this_round: bool

# If the issue is currently being configured from a save file and
# it is assigned to someone, ready() should not update extended, because
# the hooks do not exist yet
var should_lock_extending: bool

# Signal that will be emitted when the Extended node is being either shown or 
# hidden.
# extending - set to true if the Extended node is BEING set to visible
signal extending(owner, extending)

# Called when the node enters the scene tree for the first time.
func _ready():
	update_summary()
	if not should_lock_extending:
		update_extended()
	should_lock_extending = false
	update_colors()
	# it prevents changing state to IN_BACKLOG when Scene is loaded to editor
	if not Engine.is_editor_hint():
		check_unlock()
	was_assigned_this_round = false
	randomize()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func get_progress():
	return self.__progress

# set visibility of extended description to v
func set_visibility_on_exteded_description(v):
	$Extended.visible = v
	$Sprite.visible = not v
	$Summary.visible = not v
	emit_signal("extending", self, v)

# update summary text
# summary includes type, name, state
func update_summary():
	$Summary.text =  type_start[type]+name+type_end[type]
	$Sprite/State.frame = state
	$Sprite/Importance.visible = type == IssueType.FEATURE
	update_importance()
	update_colors()
# update extended
# update name,difficulty,importance
# update 
func update_extended():
	# update that depends on name
	$Extended/Name.text = type_start[type]+name+type_end[type]
	# update that depends on difficulty
	$Extended/Difficulty.text = "Difficulty: [b]"+str(difficulty)+"[/b]"
	# update that depends on importance
	if type == IssueType.FEATURE:
		$Extended/Importance.text = "Importance: [b]"+str(importance_to_client)+"[/b]"
	else:
		$Extended/Importance.text = "Importance:"+type_start[type]+"BUG"+type_end[type]
	
	# update that depends on type
	$Extended/Type.text = "Type: "+type_name[type]
	# hide bottom in bug isssue
	$Extended/Bottom.visible = type == IssueType.FEATURE
	if type == IssueType.FEATURE:
		$Extended/HideButton2.position = Vector2(0,490)
	else:
		$Extended/HideButton2.position = Vector2(0,250)
	
	#update that depends on state
	$Extended/State.text = "State: "+state_name[state]
	$Extended/Assignment.disabled = not state == IssueState.IN_PROGRESS
	
	if state == IssueState.IN_PROGRESS:
		$Extended/Assignment.text = "Assigned to " + $EmployeeHook.get_child(0).get_origin().name
		$Extended/AssignButton.text = "Cancel"
	else:
		$Extended/Assignment.text = state_assigned_message[state]
		$Extended/AssignButton.text = "Assign"
		
	$Extended/Progres.text="Progress: "
	if state == IssueState.UNAVAILABLE:
		# only singular number in english is 1. 0 is plural
		if remaining_parents == 1:
			$Extended/Progres.text += "[b]"+str(remaining_parents)+"[/b] task blocks this task"
		else:
			$Extended/Progres.text += "[b]"+str(remaining_parents)+"[/b] tasks block this task"
	else:
		$Extended/Progres.text += "[b]"+str(__progress)+"[/b] out of [b]"+str(time)+"[/b]"
		# only singular number in english is 1. 0 is plural
		if time == 1:
			$Extended/Progres.text += " subtask finished"
		else:
			$Extended/Progres.text += " subtasks finished"
	# assined button visible only in IN_BACKLOG and IN_BACKLOG state
	$Extended/AssignButton.visible = IssueState.IN_BACKLOG == state or IssueState.IN_PROGRESS == state
	# update blocks tab 
	$Extended/Bottom/Tabs/Content/Tab3.clear()
	for child in child_issues:
		$Extended/Bottom/Tabs/Content/Tab3.add_item(child.name)
	# update is blocked by tab
	$Extended/Bottom/Tabs/Content/Tab2.clear()
	for issue in parent_issues:
		$Extended/Bottom/Tabs/Content/Tab2.add_item(issue.name)
		
# Called when progress is to be increased. If the progress exceeds the time,
# complete() is called
func add_progress(progress):
	was_assigned_this_round = false
	self.__progress += progress
	if self.__progress >= self.time:
		self.__progress = self.time
		complete()
	update_extended()
	update_summary()
		
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
	check_unlock()
# check and unlock task
func check_unlock():
	if remaining_parents == 0:
		self.state = IssueState.IN_BACKLOG
		update_summary()
		update_extended()
# when button is realised toggle extended description visibility
func _on_button_button_up():
	set_visibility_on_exteded_description(true)

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
		was_assigned_this_round = true
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
	subtract_progress_for_unassigning()
	unassign_employee()

func to_json():
	var child_issues_names = []
	for child_issue in child_issues:
		child_issues_names.append(child_issue.name)
	var dictionary = {
		"class": "Issue",
		"name": name,
		"remaining parents": remaining_parents,
		"child_issues": child_issues_names,
		"description": $Extended/Bottom/Tabs/Content/Tab1.text,
		"difficulty": difficulty,
		"time": time,
		"state": state,
		"importance to client": importance_to_client,
		"progress": __progress,
		"type": type
	}
	return dictionary

func configure_issue(dict: Dictionary) -> bool:
	if dict["class"] == "Issue":
		remaining_parents = dict["remaining parents"]
		$Extended/Bottom/Tabs/Content/Tab1.text = dict["description"]
		difficulty = dict["difficulty"]
		name = dict["name"]
		time = dict["time"]
		state = dict["state"]
		importance_to_client = dict["importance to client"]
		__progress = dict["progress"]
		type = dict["type"]
		if state == IssueState.IN_PROGRESS:
			should_lock_extending = true
		return true
	return false
	
func add_child_issue(issue: Issue):
	if not child_issues.has(issue):
		child_issues.append(issue)
		issue.__add_parent_issue(self)
		update_extended()

func __add_parent_issue(issue:Issue):
	if not parent_issues.has(issue):
		parent_issues.append(issue)
		update_extended()

# set sprite to represent correct importance level
func update_importance():
	if importance_to_client <= low_importance:
		$Sprite/Importance.frame = 0
	elif importance_to_client < high_importance:
		$Sprite/Importance.frame = 1
	else:
		$Sprite/Importance.frame = 2
	
		
# update colors of the background
func update_colors():
	var color_1 = bug_1
	var color_2 = bug_2
	var color_3 = bug_3
	if type == IssueType.FEATURE:
		color_1 = feature_1
		color_2 = feature_2
		color_3 = feature_3
	$Sprite/ShortBackground/Back1.modulate = color_1
	$Extended/Bottom/Back1.modulate = color_1
	$Extended/Top/Back1.modulate = color_1
	
	$Sprite/ShortBackground/Back2.modulate = color_2
	$Extended/Bottom/Back2.modulate = color_2
	$Extended/Top/Back2.modulate = color_2
	
	$Sprite/ShortBackground/Back3.modulate = color_3
	$Extended/Bottom/Back3.modulate = color_3
	$Extended/Top/Back3.modulate = color_3
	
# group of functions that receive switch tab requests
func _on_tab_1_button_up():
	tab = 0

func _on_tab_2_button_up():
	tab = 1

func _on_tab_3_button_up():
	tab = 2

func _on_hide_button_button_up():
	set_visibility_on_exteded_description(false)

# Lose some progress for unassigning the issue from the current employee. Will 
# never go below half of the current progress
func subtract_progress_for_unassigning():
	if was_assigned_this_round:
		return
	var employee_quality = $EmployeeHook.get_child(0).get_origin().quality
	var random_value = randi_range(1, 4)
	var subtracted_value = random_value + difficulty - employee_quality
	if subtracted_value < 0:
		return
	if __progress - subtracted_value >= 0.5 * __progress:
		__progress -= subtracted_value
	else:
		__progress = floori(0.5 * __progress)
		
