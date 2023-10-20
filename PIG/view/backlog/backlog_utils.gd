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
