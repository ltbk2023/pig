extends Node2D
class_name Game

enum GameState {NOT_STARTED, IN_PROGRESS, FINISHED}

@export var turns_per_sprint : int = 5

@export var max_sprints : int = 2

@export_category("Views Swichting")
@export var speed_trigger = 40
@export var angle_precision  = PI/3
@export var office_to_backlog = Vector2(-1,0)
@export var backlog_to_office = Vector2(1,0)
@export var office_to_testing = Vector2(1,0)
@export var testing_to_office = Vector2(-1,0)
var is_view_just_switched = false

var __current_turn : int
var __current_sprint : int
var __state : GameState

# Total victory points
var victory_points

# Called when the node enters the scene tree for the first time.
func _ready():
	__state = GameState.NOT_STARTED
	__current_sprint = 0
	__current_turn = 0
	victory_points = 0
	randomize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# function execute turn and update current turn
# on end of sprint call execute_end_of_sprint
func execute_turn():
	var employees = $Office.get_employees()
	for employee in employees:
		employee.execute_turn()
	
	__current_turn += 1
	if __current_turn % turns_per_sprint == 0:
		execute_end_of_sprint()


# function execute end of sprint and update current sprint
func execute_end_of_sprint():
	# get necessary resources
	var issues = $Backlog.get_issues()
	var completed_features : int = 0
	var active_bug_issues : int = 0
	for issue in issues:
		if issue.type == Issue.IssueType.BUG_ISSUE and issue.state != Issue.IssueState.COMPLETED:
			active_bug_issues += 1
		elif issue.type == Issue.IssueType.FEATURE and issue.state == Issue.IssueState.COMPLETED:
			completed_features += 1
	
	# draw cards
	# TODO: this should be transferred to e.g. SprintEnd
	var cards = $Testing/QualityDeck.check_cards(completed_features)
	var bugs_found = cards[QualityDeck.QualityType.BUG]
	
	# calculate current sprint
	$SprintEnd.execute_sprint_end(bugs_found, active_bug_issues)
	
	# update view of SprintEnd
	$SprintEnd.update_view(bugs_found, active_bug_issues)
	
	# change view
	$CanvasLayer.visible = false
	$Office.visible = false
	$Testing.visible = false
	$SprintEnd.visible = true
	$Backlog.visible = false
	__current_sprint += 1

# function that listens for the end button release and calls execute_turn()
func _on_end_turn_button_button_up():
	execute_turn()

# check if movement is in the given direction with set precision 
func is_in_direction(movement:Vector2,direction:Vector2) -> bool:
	return abs(movement.angle_to(direction)) < angle_precision

func _input(event):
	if event is InputEventMouseMotion:
		#distance travelled in one frame
		var movement = event.relative
		#if left button is pressed and mouse has travelled more than trigger check for views change
		if not is_view_just_switched and event.button_mask == MOUSE_BUTTON_LEFT and movement.length() > speed_trigger:
			
			if $Office.visible:
				if is_in_direction(movement,office_to_backlog):
					# set view to Backlog
					$Office.visible = false
					$Backlog.visible = true
					#prevent switching multiple views in one go
					is_view_just_switched = true
				elif is_in_direction(movement, office_to_testing):
					# set view to Testing
					$Office.visible = false
					$Testing.visible = true
					#prevent switching multiple views in one go
					is_view_just_switched = true

			elif $Backlog.visible:
				if is_in_direction(movement,backlog_to_office):
					# set view to Office
					$Office.visible = true
					$Backlog.visible = false
					#prevent switching multiple views in one go
					is_view_just_switched = true
					
			elif $Testing.visible:
				if is_in_direction(movement, testing_to_office):
					# set view to Office
					$Office.visible = true
					$Testing.visible = false
					#prevent switching multiple views in one go
					is_view_just_switched = true
					
	if event is InputEventMouseButton:
		is_view_just_switched = event.button_mask != MOUSE_BUTTON_LEFT
			
# Listen to assign request from backlog
# Call save_task_to_assign
func _on_backlog_assign(owner):
	$CanvasLayer/AssigningStatusView.visible = true
	save_task_to_assign(owner)

# Listen to assign request from testing
# Call save_task_to_assign
func _on_testing_assign(owner):
	$CanvasLayer/AssigningStatusView.visible = true
	save_task_to_assign(owner)
	
# Listen to assign request from office
# Create hook to owner and place it in Hooks/EmployeeToAssign
# After that call assign function
# If owner can't be assign, do nothing
# If Hooks/EmployeeToAssign contain hook, replace it with created
func _on_office_assign(owner):
	if not owner.check_task_can_be_assigned_to_employee():
		return
	if $Hooks/EmployeeToAssign.get_child_count() > 0:
		$Hooks/EmployeeToAssign.get_child(0).queue_free()
	var hook = Hook.new()
	hook.set_origin(owner)
	$Hooks/EmployeeToAssign.add_child(hook)
	$CanvasLayer/AssigningStatusView.visible = true
	assign()

# Create hook to task and place it in Hooks/TaskToAssign
# After that call assign function
# If task can't be assigned, do nothing
# If Hooks/TaskToAssign contain hook, replace it with created
func save_task_to_assign(task):
	if not task.check_employee_can_be_assigned():
		return
	if $Hooks/TaskToAssign.get_child_count() > 0:
		$Hooks/TaskToAssign.get_child(0).queue_free()
	var hook = Hook.new()
	hook.set_origin(task)
	$Hooks/TaskToAssign.add_child(hook)
	assign()

# Checks if hooks needed to assign exist
func check_hooks_to_assign_existence():
	return $Hooks/EmployeeToAssign.get_child_count() > 0 \
		and $Hooks/TaskToAssign.get_child_count() > 0
	

# Check if hooks needed to assign are valid
func check_hooks_to_assign_validity():
	return $Hooks/TaskToAssign.get_child(0).get_origin().check_employee_can_be_assigned() \
		and $Hooks/EmployeeToAssign.get_child(0).get_origin().check_task_can_be_assigned_to_employee()
	
# Returns true upon succesful assignment of issue/testing to employee.
# Removes data remembered in TaskToAssign and EmployeeToAssign
# If hooks exist but aren't valid destroy them
func assign():
	if check_hooks_to_assign_existence():
		if check_hooks_to_assign_validity():
			var employee_hook = $Hooks/EmployeeToAssign.get_child(0)
			$Hooks/EmployeeToAssign.remove_child(employee_hook)
			# Assign task
			if $Hooks/TaskToAssign.get_child_count() > 0:
				var task_hook = $Hooks/TaskToAssign.get_child(0)
				$Hooks/TaskToAssign.remove_child(task_hook)
				employee_hook.get_origin().assign_issue(task_hook)
				task_hook.get_origin().assign_employee(employee_hook)
			$CanvasLayer/AssigningStatusView.visible = false
			return true
		else:
			$Hooks/EmployeeToAssign.get_child(0).queue_free()
			$Hooks/TaskToAssign.get_child(0).queue_free()

	return false
		
# Listen to "completed" signal emitted by Office. Add 2 quality cards to the
# deck.
func _on_office_completed(owner, issue, quality):
	$Testing/QualityDeck.add_from_preset(quality, 2)
	$SprintEnd.add_issue_importance(issue)
  
func _on_bug_found():
	var bug_issue = preload("res://issue/issue.tscn").instantiate()
	bug_issue.type = Issue.IssueType.BUG_ISSUE
	# THIS SHOULD BE DONE SOMEWHERE ELSE AUTOMATICALLY, MOST LIKELY IN ISSUE'S
	# ready() METHOD! TODO: DISCUSS
	bug_issue.state = Issue.IssueState.IN_BACKLOG
	# The following limits should be constants/vars in the Issue script!
	bug_issue.difficulty = randi_range(1, 4)
	bug_issue.time = randi_range(1, 3)
	$Backlog.add_issue(bug_issue)

# Start modifiers. They will affect employees.
func launch_modifiers():
	for modifier in $Modifiers.get_children():
		if modifier.is_active():
			modifier.modify()
		else:
			modifier.delete_all_hooks()
			modifier.queue_free()

# TODO: save this points somewhere or i don't know
# I create this only to not forget about this signal 
func _on_sprint_end_victory_points(owner, amount):
	pass # Replace with function body.

# Other view may want to return to main view of game
# Owner can be useful in the future
func _on_sprint_end_return_to_office_view(owner):
	$CanvasLayer.visible = true
	$Office.visible = true
	$Testing.visible = false
	$SprintEnd.visible = false
	$Backlog.visible = false

# Deletes the hook from TaskToAssign if it exists.
func cancel_task_to_assign():
	if $Hooks/TaskToAssign.get_child_count() > 0:
		$Hooks/TaskToAssign.get_child(0).queue_free()
		
# Deletes the from EmployeeToAssign if it exists.
func cancel_employee_to_assign():
	if $Hooks/EmployeeToAssign.get_child_count() > 0:
		$Hooks/EmployeeToAssign.get_child(0).queue_free()

func _on_cancel_assigning_button_up():
	cancel_task_to_assign()
	cancel_employee_to_assign()
	$CanvasLayer/AssigningStatusView.visible = false

# Return a JSON dictionary representing this object in its current state
func to_json():
	var dictionary = {
		"class": "Game",
		"name": name,
		"turns per sprint": turns_per_sprint,
		"max sprints": max_sprints,
		"current turn": __current_turn,
		"current sprint": __current_sprint,
		"victory points": victory_points
	}
	return dictionary

# save state of whole game to JSON file
func save_to_file(file_name):
	var dictionary = {}
	var issues = []
	var employees = []
	dictionary["Game"] = self.to_json()
	dictionary["QualityDeck"] = $Testing/QualityDeck.to_json()
	dictionary["Testing"] = $Testing.to_json()
	dictionary["SprintEnd"] = $SprintEnd.to_json()
	for issue in $Backlog.get_issues():
		issues.append(issue.to_json())
	dictionary["Issues"] = issues
	for employee in $Office.get_employees():
		employees.append(employee.to_json())
	dictionary["Employees"] = employees
	
	var data = JSON.stringify(dictionary, "\t")
	
	var file = FileAccess.open(file_name, FileAccess.WRITE)
	file.store_string(data)
	file.close()

# load JSON state of whole game from file
func load_from_file(file_name: String) -> Dictionary:
	var file = FileAccess.open(file_name, FileAccess.READ)
	var content = file.get_as_text()
	var json = JSON.new()
	var error = json.parse(content)
	if error == OK:
		var data_received = json.data
		data_received["error"] = null
		return data_received
	else:
		print("JSON Parse Error: ", json.get_error_message(), " in ", content, \
		" at line ", json.get_error_line())
		return {"error": "JSON Parse Error"}
