extends Node2D
class_name Backlog
@export var issue_visual_separation:Vector2 = Vector2(0,40)
# signal containing owner, which should be issue that is currently assigned to employee
signal assign(owner)

var filter_function=null
var sort_function=null
#prevent unnecessary updates
var last_order=null

var extended = null
# Called when the node enters the scene tree for the first time.
#set position of issue in Issue node
func _ready():
	update_issues_position()
	$Filter.clear()
	for f in BacklogUtils.get_filter_functions():
		$Filter.add_item(f[0])
	$Sort.clear()
	for f in BacklogUtils.get_sort_functions():
		$Sort.add_item(f[0])

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
	last_order = issues
	
	# hide filter out issues
	for child in $Issues.get_children():
		child.visible = false
	
	var i = 0
	for child in issues:
		child.visible = true
		set_issue_position(child,i)
		i += 1

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
	for task in $Issues.get_children():
		task.visible = task == owner or not extending 
	if extending:
		# if backlog is visible move Issue to appear at the center of screen
		if visible:
			owner.position = -$Issues.position
			extended = owner
			last_order = null
		# if not force issue to hide extension
		else:
			owner.set_visibility_on_exteded_description(false)
	else:
		# move all issue to correct positions
		update_issues_position()
		extended = null
	
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
