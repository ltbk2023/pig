extends Node2D
class_name Backlog
@export var issue_visual_separation:Vector2 = Vector2(0,40)
@export var min_issues_visible = 3
# signal containing owner, which should be issue that is currently assigned to employee
signal assign(owner)

var filter_function=null
var sort_function=null
#prevent unnecessary updates
var last_order=null

var extended = null

var position_when_scrool_start = null

var min_scroll_position
var max_scroll_position
# Called when the node enters the scene tree for the first time.
#set position of issue in Issue node
func _ready():
	min_scroll_position = $Issues.position
	update_issues_position()
	$Filter.clear()
	for f in BacklogUtils.get_filter_functions():
		$Filter.add_item(f[0])
	$Sort.clear()
	for f in BacklogUtils.get_sort_functions():
		$Sort.add_item(f[0])

func is_in_scroll():
	return not position_when_scrool_start == null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#set issue positon to given pose
#pose is calculated by multiplying pose_number and issue_visual_separation
func set_issue_position(issue:Issue,pose_number:int):
	issue.position = pose_number * issue_visual_separation


#update position of all chldren of Issues node
#position is based on order in Issues node and issue_visual_separation
func update_issues_position():
	var issues = $Issues.get_children()
	
	if not filter_function == null:
		issues = issues.filter(filter_function)
	
	if not sort_function == null:
		issues.sort_custom(sort_function)
	
	
	#prevent unnecessary updates
	if last_order == issues:
		return
	
	if last_order != null:
		$Issues.position = min_scroll_position
	last_order = issues
	
	var i = 0
	for child in issues:
		set_issue_position(child,i)
		i +=1
		
	update_visible(issues)

# update visibity of issues based on state of backlog
# if order is null call update_issue postion
func update_visible(order:Array[Node]):
	if order == null:
		update_issues_position()
	elif is_in_scroll():
		show_all_from_order(order)
	else:
		show_reachable(order)

# show only issue that are in order
func show_all_from_order(order):
	for child in $Issues.get_children():
		child.visible = false
	
	for child in order:
		child.visible = true

# show only issue that are in order 
# and are not hidden in behind HideIssueBackground
func show_reachable(order):
	for child in $Issues.get_children():
		child.visible = false
	for child in order:
		child.visible = min_scroll_position.y  <= child.position.y + $Issues.position.y

# add issue to the backlog and set it's position
# connect assign signal to _on_assign for new issue
func add_issue(issue:Issue):
	$Issues.add_child(issue)
	issue.assign.connect(_on_assign)
	issue.extending.connect(_on_extending)
	issue.visible = extended == null
	if extended == null:
		update_issues_position()

# sends signal with issue-owner to higher part of tree which should be Game
func _on_assign(owner):
	emit_signal("assign", owner)

#remove issue from the backlog and update position of the others issues
func remove_issue(issue:Issue):
	$Issues.remove_child(issue)
	update_issues_position()
	
#get all issuees from Backlog 
func get_issues():
	return $Issues.get_children()

func _on_extending(owner, extending):
	# when issue is extending hide every issue except of owner
	# if not show all
	if extending:
		for task in $Issues.get_children():
			task.visible = task == owner
		# if backlog is visible move Issue to appear at the center of screen
		if visible and not is_in_scroll():
			owner.position = -$Issues.position
			extended = owner
			last_order = null
		# if not force issue to hide extension
		else:
			owner.set_visibility_on_exteded_description(false)
			return
	else:
		# move all issue to correct positions
		last_order = null
		extended = null
		update_issues_position()
		
	# prevent filter and sort activation when issue is extended
	$Filter.disabled = extending
	$Sort.disabled = extending
# hide extended issue view when backlog became hidden
func _on_hidden():
	if not extended == null:
		extended.set_visibility_on_exteded_description(false)


func _on_filter_item_selected(index):
	filter_function = BacklogUtils.get_filter_functions()[index][1]
	if extended == null:
		update_issues_position()

func _on_sort_item_selected(index):
	sort_function = BacklogUtils.get_sort_functions()[index][1]
	if extended == null:
		update_issues_position()

func __update_form_anim():
	if visible and extended == null:
		update_issues_position()
		
# move issues according to scroll_distance and position when scroll started
# if some issue is extended scrolling is not active
func add_scroll(scroll_distance):
	# if some issue is extended ignore scroll
	if extended != null:
		return
	# if baclog isn't in scroll prepare backlog
	if not is_in_scroll():
		position_when_scrool_start = $Issues.position.y
		# make issue behind HideIssueBackground visible
		update_visible(last_order)
		# set max scroll to ensure that minimal number of issue will be visible
		max_scroll_position = -(last_order.size()-min_issues_visible)*issue_visual_separation + min_scroll_position
	
	# update position based on scroll starting position and limits
	var p = position_when_scrool_start + scroll_distance
	$Issues.position.y = min(min_scroll_position.y,max(max_scroll_position.y,p))

# resolve scroll
func end_scroll():
	position_when_scrool_start=null
	# round scroll to align issue with HideIssueBackround border
	var p = round(($Issues.position.y - min_scroll_position.y)/issue_visual_separation.y)
	$Issues.position.y = p*issue_visual_separation.y+ min_scroll_position.y
	
	# hide issue behind HideIssueBackround
	update_visible(last_order)
