extends Node2D
class_name Issue
signal assign(owner)

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

# Signal that will be emitted when the Extended node is being either shown or 
# hidden.
# extending - set to true if the Extended node is BEING set to visible
signal extending(owner, extending)

# Called when the node enters the scene tree for the first time.
func _ready():
	update_summary()

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
#sumary include type, name, difficulty, time, state
func update_summary():
	$Summary.text =  type_decription[type]+" [color=BLACK]"+name+"  D "+str(difficulty)+" / T "+str(time)+"[/color] " + \
	state_desriptions[state] 

# Called when progress is to be increased. If the progress exceeds the time,
# IssueState is set to completed.
func add_progress(progress):
	self.__progress += progress
	if self.__progress >= self.time:
		self.state = IssueState.COMPLETED
		
# when button is realised toggle extended description visibility
func _on_button_button_up():
	set_visibility_on_exteded_desription(not $Extended.visible)

# sends issue assign signal to the higher part of the tree
# final destination should be backlog
func _on_assign_button_button_up():
	emit_signal("assign", self) 
