extends Node2D
class_name SprintEnd

# Send the number of victory points obtained this sprint to Game
signal victory_points(owner, amount)

@export var expected_score_multiplier = 10

@export_category("Score thresholds")
@export var score_low_boundary = -5
@export var score_high_boundary = 5

@export_category("Score multipliers")
@export var bug_issue_multiplier = 1
@export var bugs_found_multiplier = 2

@export_category("Victory points")
@export var points_below_boundaries = -1
@export var points_between_boundaries = 1
@export var points_above_boundaries = 2

# The total client importance points accumulated from issues.
var __total_client_importance : int
# The number of issues completed this sprint
var __issues_done_this_sprint: int
# The number of present sprint
var __current_sprint : int

# Called when the node enters the scene tree for the first time.
func _ready():
	__total_client_importance = 0
	__issues_done_this_sprint = 0
	__current_sprint = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
# Execute the end of sprint.
func execute_sprint_end(bugs_found: int, active_bug_issues: int):
	__issues_done_this_sprint = 0
	__current_sprint += 1
	var client_score = __total_client_importance
	var expected_client_score = expected_score_multiplier * __current_sprint
		
	client_score -= bug_issue_multiplier * active_bug_issues + \
	bugs_found_multiplier * bugs_found
	
	var sprint_victory_points : int
	if client_score - expected_client_score < score_low_boundary:
		sprint_victory_points = points_below_boundaries
	elif client_score - expected_client_score <= score_high_boundary:
		sprint_victory_points = points_between_boundaries
	else:
		sprint_victory_points = points_above_boundaries
	emit_signal("victory_points", sprint_victory_points)
	
		
# Adds an issue's importance points to the total and increases the number of
# issues done
func add_issue_importance(issue: Issue):
	__total_client_importance += issue.importance_to_client
	__issues_done_this_sprint += 1
