extends Node
class_name  BacklogUtils

#filtering functions
static func __type_filter(type:Issue.IssueType,issue:Issue):
	return type == issue.type
	
static func bug_filter(issue:Issue):
	return __type_filter(Issue.IssueType.BUG_ISSUE,issue)
	
static func feature_filter(issue:Issue):
	return __type_filter(Issue.IssueType.FEATURE,issue)

#static var workaround
static func get_filter_functions():
	return [
		["Default",null],
		["Feature",Callable(BacklogUtils,"feature_filter")],
		["Bug Issue",Callable(BacklogUtils,"bug_filter")]
	]

#sort functions
static func state_sort(issueA:Issue,issueB:Issue) -> bool:
	return issueA.state < issueB.state

static func rev_state_sort(issueA:Issue,issueB:Issue) -> bool:
	return not state_sort(issueA,issueB)

static func client_importance_sort(issueA: Issue, issueB: Issue) -> bool:
	return issueA.importance_to_client > issueB.importance_to_client
	
static func time_sort(issueA: Issue, issueB: Issue) -> bool:
	return issueA.time > issueB.time
	
static func difficulty_sort(issueA: Issue, issueB: Issue) -> bool:
	return issueA.difficulty > issueB.difficulty
	
#static var workaround
static func get_sort_functions():
	return [
		["Default",null],
		["State",Callable(BacklogUtils,"state_sort")],
		["Reverse State",Callable(BacklogUtils,"rev_state_sort")],
		["Importance to client", Callable(BacklogUtils,
		"client_importance_sort")],
		["Time", Callable(BacklogUtils, "time_sort")],
		["Difficulty", Callable(BacklogUtils, "difficulty_sort")]
	]
