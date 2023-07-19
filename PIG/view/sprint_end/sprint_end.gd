extends Node2D
class_name SprintEnd

# Signals emitted to get the number of bugs found and bug issues from Game.
signal request_quality_cards(owner, amount)
signal request_bug_issues(owner)

# Send the number of victory points obtained this sprint to Game
signal victory_points(owner, amount)

# Synchronising flags
var __got_bugs_found: bool
var __got_bug_issues: bool

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

# The number of bugs found when presenting the product to the client
var __bugs_found : int
# The number of unresolved bug issues in the backlog
var __bug_issues: int
# The total client importance points accumulated from issues.
var __total_client_importance : int
# The number of issues completed this sprint
var __issues_done_this_sprint: int

var __current_sprint : int

# Called when the node enters the scene tree for the first time.
func _ready():
	__bugs_found = 0
	__bug_issues = 0
	__total_client_importance = 0
	__issues_done_this_sprint = 0
	__current_sprint = 0
	__got_bug_issues = false
	__got_bugs_found = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
# Execute the end of sprint. Query Game for bugs found and bug issues and wait
# for the results before continuing. 
func execute_sprint_end():
	__got_bugs_found = false
	__got_bug_issues = false
	emit_signal("request_bug_issues")
	emit_signal("request_quality_cards", __issues_done_this_sprint)
	__issues_done_this_sprint = 0
	var client_score = __total_client_importance
	__current_sprint += 1
	var expected_client_score = expected_score_multiplier * __current_sprint
	# wait until the values are fetched from Game
	while not __got_bug_issues or not __got_bugs_found:
		pass
		
	client_score -= bug_issue_multiplier * __bug_issues + \
	bugs_found_multiplier * __bugs_found
	
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
func on_issue_complete(issue: Issue):
	__total_client_importance += issue.importance_to_client
	__issues_done_this_sprint += 1
	
# Set bugs_found and got_bugs_found flag
func set_bugs_found(amount: int):
	__bugs_found = amount
	__got_bugs_found = true

# Set bug_issues and got_bug_issues flag
func set_bug_issues(amount: int):
	__bug_issues = amount
	__got_bug_issues = true
