extends Game
class_name GamePlaceholder

# These variables exist only in the placeholder.
@export_category("Test variables")
@export var employee_number = 3
@export var issue_number = 6

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	for i in range(employee_number):
		var employee = preload("res://employee/employee.tscn").instantiate()
		employee.speed = (i % 3) + 1
		employee.quality = 3 - (i % 3)
		employee.testing = 2
		$Office.add_employee(employee)
	for i in range(issue_number):
		var issue = preload("res://issue/issue.tscn").instantiate()
		issue.difficulty = (i % 4) + 1
		issue.time = (i % 3) + 1
		issue.importance_to_client = (2*i%5) + 1
		issue.state = Issue.IssueState.IN_BACKLOG
		issue.name = "PIG-"+str(i)+": "+"test ".repeat(i)
		$Backlog.add_issue(issue)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
