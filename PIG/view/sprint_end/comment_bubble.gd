extends Node2D

# main keys
var good_key = "good"
var mixed_key = "mixed"
var bad_key = "bad"

var earned_point_to_type={-1:bad_key,1:mixed_key,2:good_key}

# secondary keys
var bug_issues_key = "bug_issues"
var presentation_key = "presentation"
var both_key = "both"

var progress_key = "progress"

# minium influence on score to count
var importance_minimum = 4

var end_sprint_comment:Dictionary
# Called when the node enters the scene tree for the first time.
func _ready():
	end_sprint_comment = load("res://view/sprint_end/end_script_comment.json").data
	
func update_comment(earned_point,bug_issues,presentation):
	var dict = end_sprint_comment[earned_point_to_type[earned_point]]
	
	var text = dict[progress_key]
	if bug_issues >= importance_minimum:
		if presentation >= importance_minimum:
			text = dict[both_key]
		else:
			text = dict[bug_issues_key]
	elif presentation >= importance_minimum:
		text = dict[presentation_key]
	
	$BubbleText.text = "[center]"+text+ "[/center]"
	
