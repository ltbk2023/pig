extends Node2D
class_name Game

enum GameState {NOT_STARTED, IN_PROGRESS, FINISHED}

@export var turns_per_sprint : int = 5

@export var max_sprints : int = 2

signal show_menu()

@export_group("Views Switching")
@export var movement_trigger = 40


@export_group("Visualization")
@export var show_days_left = true

@export_group("Transition")
@export var target_view_scale = 0.9
@export var second_view_scale = 0.8

var is_view_just_switched = false

var movement =Vector2.ZERO
var movement_direction = 1
var transition_from:Node2D
var transition_to:Node2D

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
	display_date()
	randomize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# function execute turn and update current turn
# on end of sprint call execute_end_of_sprint
func execute_turn():
	var modifiers = $Modifiers.get_children()
	for modifier in modifiers:
		modifier.decrease_counter()
		if not modifier.is_active():
			modifier.detach_modification()
			modifier.queue_free()
	var employees = $Office.get_employees()
	for employee in employees:
		$Modifiers.morale_modify_stats(employee)
	for employee in employees:
		employee.execute_turn()
	
	__current_turn += 1
	if __current_turn % turns_per_sprint == 0:
		execute_end_of_sprint()
	draw_story_card()
	display_date()

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
	if $Hooks/EmployeeToAssign.get_child_count() == 0 and \
		$Hooks/TaskToAssign.get_child_count() == 0:
			## TODO
			execute_turn()
	else:
		cancel_task_to_assign()
		cancel_employee_to_assign()
		display_date()

# check if game is in transition
func is_in_transition():
	return not transition_to == null
	
func is_in_scroll():
	return $Backlog.is_in_scroll()

# check if view should be changed after transition
func is_transition_triggering_switch():
	return abs(movement.x) >= get_viewport_rect().size.x/2

# update transition effect to match movement
func transition_update():
	var size = get_viewport_rect().size.x
	# ensure that movement doesn't go beyond it's limit
	# if movement is to the right range is <0,size/2>
	# if movement is to the left range is <-size/2,0>
	var m = min(movement.x,(1+movement_direction)/2*size)
	m = max(m,(movement_direction-1)/2*size)
	# show what view would be selected after given movement
	# view that would be selected is bigger
	if is_transition_triggering_switch():
		transition_to.scale = target_view_scale*Vector2(1,1)
		transition_from.scale = second_view_scale*Vector2(1,1)
	else:
		transition_to.scale = second_view_scale*Vector2(1,1)
		transition_from.scale = target_view_scale*Vector2(1,1)
	# move views to follow movement
	transition_from.position.x = m
	# move view in set distance to from view
	transition_to.position.x = m-sign(movement_direction)*size
	
	# ensure that unnessesary views are hidden
	# additionally switching visibility off/on prevent button's activation for this frame 
	$Office.visible = false
	$Backlog.visible = false
	$Testing.visible = false
	
	# ensure that both view are visible
	transition_to.visible = true
	transition_from.visible = true

# end transition and return to default state
# this function doesn't reset movement
func resolve_transition():
	if is_transition_triggering_switch():
		transition_to.scale = Vector2(1,1)
		transition_to.position = Vector2.ZERO
		transition_from.visible = false
	else:
		transition_from.scale = Vector2(1,1)
		transition_from.position = Vector2.ZERO
		transition_to.visible = false
	transition_to = null
# check what movement should be played 
func movement_intepretation():
	# cache for transition flag
	var tran =  is_in_transition() 
	if tran or abs(movement.x)>abs(movement.y):
		# from Office it is possible to go both ways 
		# so it is necessary to check
		# if the player didn't change direction of movement during transition
		if (tran and transition_from == $Office) or (not tran and $Office.visible):
			transition_from = $Office
			if movement.x < 0:
				transition_to = $Backlog
			else:
				transition_to = $Testing
			movement_direction = sign(movement.x)
		# Backlog and $Testing can be visible during transition
		# so to prevent errors we must check if we aren't in transition
		elif not tran and $Backlog.visible:
			transition_from = $Backlog
			if movement.x > 0:
				transition_to = $Office
				movement_direction = 1
		
		elif not tran and $Testing.visible:
			transition_from = $Testing
			if movement.x < 0:
				transition_to = $Office
				movement_direction = -1
	# transition status may change so is in transition must be called again
		if is_in_transition():
			transition_update()
	else:
		if $Backlog.visible:
			$Backlog.add_scroll(movement.y)
		
		
func _input(event):
	if event is InputEventMouseMotion:
		# if left button is pressed current move add to movement variable
		# check if move triggers change
		if event.button_mask == MOUSE_BUTTON_LEFT:
			movement += event.relative
			if is_in_transition() or is_in_scroll() or movement.length() > movement_trigger:
				movement_intepretation()
		else:
			movement = Vector2.ZERO

	if event is InputEventMouseButton:
		# if letf button is relised end movement
		if event.button_mask != MOUSE_BUTTON_LEFT:
			if is_in_transition():
				resolve_transition()
			if $Backlog.is_in_scroll():
				$Backlog.end_scroll()
			movement = Vector2.ZERO
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
	display_assign(false)
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
	display_assign(true)
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
				display_date()
			return true
		else:
			$Hooks/EmployeeToAssign.get_child(0).queue_free()
			$Hooks/TaskToAssign.get_child(0).queue_free()

	return false
		
# Listen to "completed" signal emitted by Office. Add 2 quality cards to the
# deck.
func _on_office_completed(owner, issue, quality):
	if issue.type == Issue.IssueType.BUG_ISSUE:
		$Testing/QualityDeck.add_from_preset(quality, 1)
	elif issue.type == Issue.IssueType.FEATURE:
		$Testing/QualityDeck.add_from_preset(quality, 2)
	else:
		print("Warning: Unknown type of issue")
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
	print("Warning: _on_sprint_end_victory_points not complete")

# Other view may want to return to main view of game
# Owner can be useful in the future
func _on_sprint_end_return_to_office_view(owner):
	$CanvasLayer.visible = true
	$Office.visible = true
	$Office.position = Vector2(0,0)
	$Office.scale = Vector2(1,1)
	$Testing.visible = false
	$SprintEnd.visible = false
	$Backlog.visible = false
	display_date()

# Deletes the hook from TaskToAssign if it exists.
func cancel_task_to_assign():
	if $Hooks/TaskToAssign.get_child_count() > 0:
		$Hooks/TaskToAssign.get_child(0).queue_free()
# Deletes the from EmployeeToAssign if it exists.
func cancel_employee_to_assign():
	if $Hooks/EmployeeToAssign.get_child_count() > 0:
		$Hooks/EmployeeToAssign.get_child(0).queue_free()
		

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

# Basic configuration of Game, use to load scenario
func configure_game(dict: Dictionary) -> bool:
	if dict["class"] == "Game":
		turns_per_sprint = dict["turns per sprint"]
		max_sprints = dict["max sprints"]
		__current_turn = dict["current turn"]
		__current_sprint = dict["current sprint"]
		victory_points = dict["victory points"]
		return true
	return false

# set status bar to day of the week and sprint number
# set button to "End Day"
func display_date():
	var day_of_the_week=["Monday","Tuesday","Wednesday","Thursday","Friday"]
	
	var days_left = turns_per_sprint-__current_turn%turns_per_sprint
	
	var text =day_of_the_week[ __current_turn%5]
	if show_days_left:
		if days_left == 1:
			text += "[b] last day[/b]"
		else:
			text += " [b]"+str(days_left)+"[/b] days left"
	text +="\nSprint: [b]"+\
		str(__current_sprint+1)+"[/b] out of [b]"+\
		str(max_sprints)+'[/b]'
	$CanvasLayer/Status.text = text
	$CanvasLayer/Button.text = "End Day"
	$CanvasLayer/Button.visible = not $DeckMaster.has_card()
	
# set status bar to Assigning and name of task or employee
# set button to "Cancel"
func display_assign(task):
	var text = "Assigning:\n"
	if task:
		text += $Hooks/TaskToAssign.get_child(0).get_origin().name
	else:
		text += $Hooks/EmployeeToAssign.get_child(0).get_origin().name
	$CanvasLayer/Status.text = text
	$CanvasLayer/Button.text = "Cancel"
	$CanvasLayer/Button.visible = true
	

# emit show menu request
func _on_menu_button_button_up():
	show_menu.emit()

# hide message
func _on_exit_button_button_up():
	$CanvasLayer/Message.visible = false

# TODO
# implement reaction to show message request 
func _on_message_button_up():
	$DeckMaster/StoryCard.visible = true
	$Office.visible = false
	$Testing.visible = false
	$SprintEnd.visible = false
	$Backlog.visible = false

# Called at the beginning of each day. Fetch a story card from the Deck Master
func draw_story_card():
	if __current_turn == 1:
		$DeckMaster.employees = $Office.get_employees()
	var card = $DeckMaster.get_card()
	$CanvasLayer/Message.visible = true

func _on_deck_master_done(owner):
	_on_sprint_end_return_to_office_view(owner)
	$CanvasLayer/Message.visible = false
	$CanvasLayer/Button.visible = true
