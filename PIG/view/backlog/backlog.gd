extends Node2D
class_name Backlog
@export var issue_visual_separation:Vector2 = Vector2(0,40)
# signal containing owner, which should be issue that is currently assigned to employee
signal assign(owner)

# Called when the node enters the scene tree for the first time.
#set position of issue in Issue node
func _ready():
	update_issues_position()

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
	var i = 0
	for child in $Issues.get_children():
		set_issue_position(child,i)
		i += 1

# add issue to the backlog and set it's position
# connect assign signal to _on_assign for new issue
func add_issue(issue:Issue):
	$Issues.add_child(issue)
	issue.assign.connect(_on_assign)
	issue.extending.connect(_on_extending)
	set_issue_position(issue,$Issues.get_child_count()-1)

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
	if not extending:
		return
	for issue in $Issues.get_children():
		if issue != owner:
			issue.set_visibility_on_exteded_desription(false)
	
