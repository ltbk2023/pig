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

# Called when the node enters the scene tree for the first time.
func _ready():
	__state = GameState.NOT_STARTED
	__current_sprint = 0
	__current_turn = 0
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
	#TODO implement end of sprint
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
	save_task_to_assign(owner)

# Listen to assign request from testing
# Call save_task_to_assign
func _on_testing_assign(owner):
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
# Removes data remembered in IssueToAssign/Testing and EmployeeToAssign
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
			return true
		else:
			$Hooks/EmployeeToAssign.get_child(0).queue_free()
			$Hooks/IssueToAssign.get_child(0).queue_free()

	return false
		
# Listen to "completed" signal emitted by Office. Add 2 quality cards to the
# deck.
func _on_office_completed(owner, issue, quality):
	$Testing/QualityDeck.add_from_preset(quality, 2)
  
func _on_bug_found():
	var bug_issue = Issue.new()
	bug_issue.type = Issue.IssueType.BUG_ISSUE
	# THIS SHOULD BE DONE SOMEWHERE ELSE AUTOMATICALLY, MOST LIKELY IN ISSUE'S
	# ready() METHOD! TODO: DISCUSS
	bug_issue.state = Issue.IssueState.IN_BACKLOG
	# The following limits should be constants/vars in the Issue script!
	bug_issue.difficulty = randi_range(1, 4)
	bug_issue.time = randi_range(1, 3)
	$Backlog.add_issue(bug_issue)
