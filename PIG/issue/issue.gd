@tool
extends Node2D
class_name Issue
signal assign(owner)

enum IssueType {FEATURE, BUG_ISSUE}
# tags used in Summary that depend on type
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

@export var type:IssueType:
	set(t):
		type =t
		$Sprite/Importance.visible = t == IssueType.FEATURE
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
# subgroup represent high/low levels of importance
@export_subgroup("importance")
@export var low_importance = 2:
	set(i):
		low_importance = i
		update_importance()
@export var high_importance = 4:
	set(i):
		high_importance = i
		update_importance()
# subgroup represent colors of feature's background
@export_subgroup("feature")
@export var feature_1=Color8(240,255,255):
	set(c):
		feature_1 = c
		update_colors()
@export var feature_2=Color8(220,255,255):
	set(c):
		feature_2 = c
		update_colors()
@export var feature_3=Color8(180,255,255):
	set(c):
		feature_3 = c
		update_colors()
# subgroup represent colors of bug's background
@export_subgroup("bug")
@export var bug_1=Color8(255,245,245):
	set(c):
		bug_1 = c
		update_colors()
@export var bug_2=Color8(255,235,235):
	set(c):
		bug_2 = c
		update_colors()
@export var bug_3=Color8(255,215,215):
	set(c):
		bug_3 = c
		update_colors()


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
	update_colors()
	

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
# summary include type, name, state
func update_summary():
	$Summary.text =  type_start[type]+name+type_end[type]
	$Sprite/State.frame = state
	update_importance()
	update_colors()
# update extended text
# update assigned to text and assign button
func update_extended():
	$Extended/Sprite2D2/Unlocks.visible = false
	if state == IssueState.COMPLETED:
		$Extended/Sprite2D2/AssignButton.visible = false
		$Extended/Sprite2D2/Assignment.text = "[color=BLACK]Done"
	elif state == IssueState.UNAVAILABLE:
		$Extended/Sprite2D2/AssignButton.visible = false
		$Extended/Sprite2D2/Assignment.text = "[color=BLACK]Unavailable"
	elif $EmployeeHook.get_child_count(0)  and not \
	$EmployeeHook.get_child(0).is_queued_for_deletion():
		$Extended/Sprite2D2/AssignButton.text = "Cancel"
		$Extended/Sprite2D2/AssignButton.visible = true
		$Extended/Sprite2D2/Assignment.text = "[color=BLACK]Assigned to " + $EmployeeHook.get_child(0).get_origin().name
	else:
		$Extended/Sprite2D2/AssignButton.text = "Assign"
		$Extended/Sprite2D2/AssignButton.visible = true
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
	var child_issues_names = []
	for child_issue in child_issues:
		child_issues_names.append(child_issue.name)
	var dictionary = {
		"class": "Issue",
		"name": name,
		"remaining parents": remaining_parents,
		"child_issues": child_issues_names,
		"description": $Extended/Sprite2D2/Description.text,
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
		$Extended/Sprite2D2/Description.text = dict["description"]
		difficulty = dict["difficulty"]
		name = dict["name"]
		time = dict["time"]
		state = dict["state"]
		importance_to_client = dict["importance to client"]
		__progress = dict["progress"]
		type = dict["type"]
		return true
	return false
	
func add_child_issue(issue: Issue):
	if not child_issues.has(issue):
		child_issues.append(issue)

# set sprite to represent correct importance level
func update_importance():
	if importance_to_client <= low_importance:
		$Sprite/Importance.frame = 0
	elif importance_to_client <high_importance:
		$Sprite/Importance.frame = 1
	else:
		$Sprite/Importance.frame = 2
		
# update colors of the background
func update_colors():
	if type == IssueType.FEATURE:
		$Sprite/ShortBackground/Back1.modulate = feature_1
		$Sprite/ShortBackground/Back2.modulate = feature_2
		$Sprite/ShortBackground/Back3.modulate = feature_3
	elif type == IssueType.BUG_ISSUE:
		$Sprite/ShortBackground/Back1.modulate = bug_1
		$Sprite/ShortBackground/Back2.modulate = bug_2
		$Sprite/ShortBackground/Back3.modulate = bug_3
