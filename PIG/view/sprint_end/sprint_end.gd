extends Node2D
class_name SprintEnd

# The total client importance points accumulated from issues.
var __total_client_importance : int

# Called when the node enters the scene tree for the first time.
func _ready():
	__total_client_importance = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
# Adds an issue's importance points to the total
func add_issue_importance(issue: Issue):
	__total_client_importance += issue.importance_to_client
