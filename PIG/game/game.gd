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
var is_view_just_switched = false


var __current_turn : int
var __current_sprint : int
var __state : GameState

# Called when the node enters the scene tree for the first time.
func _ready():
	__state = GameState.NOT_STARTED
	__current_sprint = 0
	__current_turn = 0


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
	if __current_sprint % turns_per_sprint == 0:
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

			elif $Backlog.visible:
				if is_in_direction(movement,backlog_to_office):
					# set view to Office
					$Office.visible = true
					$Backlog.visible = false
					#prevent switching multiple views in one go
					is_view_just_switched = true
					
	if event is InputEventMouseButton:
		is_view_just_switched = event.button_mask != MOUSE_BUTTON_LEFT
			
