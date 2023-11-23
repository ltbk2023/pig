extends Node2D
class_name SprintEnd

# Send the number of victory points obtained this sprint to Game
signal victory_points(owner, amount)
signal return_to_office_view(owner)

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
# Last gotten points
var __last_victory_points: int = 0
# last score
var __last_score: int = 0
# influence of bugs issues on last score
var __last_bug_issues:int = 0
# influence of presentations on last score
var __last_presentation_bugs:int = 0
# max client imporatance to get from issues
var __max_client_importance:int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	__total_client_importance = 0
	__issues_done_this_sprint = 0
	__current_sprint = 0
	__last_score = 0
	
	$Background/Sprite.sitting = false
	$Background/Info/ProgressBar.update_boundry(score_low_boundary, score_high_boundary)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func __expected_score():
	return expected_score_multiplier * __current_sprint
# Execute the end of sprint.
func execute_sprint_end(bugs_found: int, active_bug_issues: int):
	__issues_done_this_sprint = 0
	__last_victory_points = 0
	__current_sprint += 1
	__last_score = 0
	__last_bug_issues = active_bug_issues*bug_issue_multiplier
	__last_presentation_bugs = bugs_found*bugs_found_multiplier
	var client_score = __total_client_importance
	var expected_client_score = __expected_score()
		
	client_score -= __last_bug_issues + __last_presentation_bugs
	
	var sprint_victory_points : int
	if client_score - expected_client_score < score_low_boundary:
		sprint_victory_points = points_below_boundaries
	elif client_score - expected_client_score <= score_high_boundary:
		sprint_victory_points = points_between_boundaries
	else:
		sprint_victory_points = points_above_boundaries
	emit_signal("victory_points", self, sprint_victory_points)
	__last_victory_points = sprint_victory_points
	__last_score = client_score
	
# Adds an issue's importance points to the total and increases the number of
# issues done
func add_issue_importance(issue: Issue):
	__total_client_importance += issue.importance_to_client
	__issues_done_this_sprint += 1

# update view and text on SprintEnd scene
func update_view(bugs_found: int, bug_issues: int):
	$Background/NameOfScene/NumberOfSprint.text = str(__current_sprint)
	
	$Background/Info/Points.text = "Earned points: [b]" + str(__last_victory_points)+"[/b]"
	
	$Background/Info/BugIssues.text = "Bug Issues in Backlog: [b]" + str(bug_issues)+"[/b]"
	$Background/Info/BugsFound.text = "Errors During Presentation: [b]" + str(bugs_found)+"[/b]"
	
	$Background/Info/ClientImportance.text = "Importance of Done Features: [b]" + str(__total_client_importance)+"[/b]"
	$Background/Info/ExpectedImportance.text = "Expected Evaluation: [b]"+ str(__expected_score())+"[/b]"
	$Background/Info/ActualImportance.text = "Actual Evaluation: [b]"+ str(__last_score)+"[/b]"

	$Background/CommentBubble.update_comment(__last_victory_points,__last_bug_issues,__last_presentation_bugs)
	
	$Background/Info/ProgressBar.update_view(__total_client_importance, __last_bug_issues, \
											__last_presentation_bugs, __expected_score())
# when press the ok button, return to main view.
func _on_ok_button_button_up():
	emit_signal("return_to_office_view", self)
	
# Return a JSON dictionary representing this object in its current state
func to_json():
	var dictionary = {
		"class": "SprintEnd",
		"name": name,
		"total client importance": __total_client_importance,
		"issues done this sprint": __issues_done_this_sprint,
		"last_victory_points": __last_victory_points,
		"current sprint": __current_sprint,
		"clients_visauls":$Background/Sprite.to_json()
	}
	return dictionary

# Basic configuration of Sprint End, use to load scenario
func configure_sprint_end(dict: Dictionary) -> bool:
	if dict["class"] == "SprintEnd":
		__current_sprint = dict["current sprint"]
		__last_victory_points = dict["last_victory_points"]
		__issues_done_this_sprint = dict["issues done this sprint"]
		__total_client_importance = dict["total client importance"]
		if dict.has("clients_presets"):
			$Background/Sprite.configure_from_presets(dict["clients_presets"])
		if dict.has("clients_visuals"):
			$Background/Sprite.configure_visuals(dict["clients_visuals"])
		return true
	return false

# set max importance to get from issues
func set_max_client_importance(importance: int) -> void:
	__max_client_importance = importance
	$Background/Info/ProgressBar.total = importance
