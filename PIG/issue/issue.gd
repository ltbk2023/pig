extends Node2D
class_name Issue

enum IssueType {FEATURE, BUG_ISSUE}

enum IssueState {IN_BACKLOG, IN_PROGRESS, COMPLETED}

@export var type:IssueType
@export var difficulty = 0
@export var time = 0
var __progress = 0
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func get_progress():
	return self.__progress
	
