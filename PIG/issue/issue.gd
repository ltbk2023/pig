extends Node2D
class_name Issue

enum IssueType {FEATURE, BUG_ISSUE}
# decription is used in Summary
var type_decription = {
	IssueType.FEATURE:"[color=BLACK]FEATURE[/color]",
	IssueType.BUG_ISSUE:"[color=DARK_RED]BUG ISSUE[/color]"
}

enum IssueState {IN_BACKLOG, IN_PROGRESS, COMPLETED}
# decription is used in Summary
var  state_desriptions = {
	IssueState.IN_BACKLOG:"[color=DARK_BLUE]in backlog[/color]",
	IssueState.IN_PROGRESS: "[color=GOLD]in progres[/color]",
	IssueState.COMPLETED: "[color=DARK_GREEN]completed[/color]",
}

@export var type:IssueType
@export var state:IssueState
@export_range(1,4) var difficulty = 1
@export_range(1,3) var time = 1

var __progress = 0
	
# Called when the node enters the scene tree for the first time.
func _ready():
	update_summary()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func get_progress():
	return self.__progress

# set visibility of extended description to v
func set_visibility_od_exteded_desription(v):
	$Extended.visible = v

# update summary text
#sumary include type, name, difficulty, time, state
func update_summary():
	$Summary.text =  type_decription[type]+" [color=BLACK]"+name+"  D "+str(difficulty)+" / T "+str(time)+"[/color] " + \
	state_desriptions[state] 


# when button is realised toggle extended description visibility
func _on_button_button_up():
	set_visibility_od_exteded_desription(not $Extended.visible)
