extends Node2D
class_name Game

enum GameState {NOT_STARTED, IN_PROGRESS, FINISHED}

@export var turns_per_sprint : int = 5

@export var max_sprints : int = 2

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
