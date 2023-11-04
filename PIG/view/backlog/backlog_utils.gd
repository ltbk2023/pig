extends Node
class_name  BacklogUtils

#filtering functions
static func __type_filter(type:Issue.IssueType,issue:Issue) -> bool:
	return type == issue.type
	
static func bug_filter(issue:Issue) -> bool:
	return __type_filter(Issue.IssueType.BUG_ISSUE,issue)
	
static func feature_filter(issue:Issue) -> bool:
	return __type_filter(Issue.IssueType.FEATURE,issue)

static func __state_filter(state: Issue.IssueState, issue: Issue) -> bool:
	return state == issue.state
	
static func available_filter(issue: Issue) -> bool:
	return not __state_filter(Issue.IssueState.UNAVAILABLE, issue)
	
static func completed_filter(issue: Issue) -> bool:
	return __state_filter(Issue.IssueState.COMPLETED, issue)
	
static func to_do_filter(issue: Issue) -> bool:
	return __state_filter(Issue.IssueState.IN_BACKLOG, issue) or \
	__state_filter(Issue.IssueState.UNAVAILABLE, issue)

static func in_progress_filter(issue: Issue) -> bool:
	return __state_filter(Issue.IssueState.IN_PROGRESS, issue)
	
#static var workaround
static func get_filter_functions():
	return [
		["Default",null],
		["Feature",Callable(BacklogUtils,"feature_filter")],
		["Bug Issue",Callable(BacklogUtils,"bug_filter")],
		["Available", Callable(BacklogUtils, "available_filter")],
		["To do", Callable(BacklogUtils, "to_do_filter")],
		["In progress", Callable(BacklogUtils, "in_progress_filter")],
		["Completed", Callable(BacklogUtils, "completed_filter")],
	]

#sort functions
static func state_sort(issueA:Issue,issueB:Issue):
	return issueA.state < issueB.state

static func rev_state_sort(issueA:Issue,issueB:Issue):
	return not state_sort(issueA,issueB)

#static var workaround
static func get_sort_functions():
	return [
		["Default",null],
		["State",Callable(BacklogUtils,"state_sort")],
		["Reverse State",Callable(BacklogUtils,"rev_state_sort")]
	]
