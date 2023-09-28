extends Node2D
class_name Main

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Called when "Play" button is released. Hides menu and adds game scene to Main node.
func _on_play_button_up():
	var game = load("res://game/game.tscn").instantiate()
	add_child(game)
	$Background.visible = false
	$CanvasLayer.visible = false

#TODO: implement check if game is saved before quitting the game.
# Called when "Quit" button is released. Closes application.
func _on_quit_button_up():
	get_tree().quit()

# save state of whole game to JSON file
func save_to_file(file_name):
	var dictionary = {}
	var issues = []
	var employees = []
	dictionary["Game"] = $Game.to_json()
	dictionary["QualityDeck"] = $Game/Testing/QualityDeck.to_json()
	dictionary["Testing"] = $Game/Testing.to_json()
	dictionary["SprintEnd"] = $Game/SprintEnd.to_json()
	for issue in $Game/Backlog.get_issues():
		issues.append(issue.to_json())
	dictionary["Issues"] = issues
	for employee in $Game/Office.get_employees():
		employees.append(employee.to_json())
	dictionary["Employees"] = employees
	
	var data = JSON.stringify(dictionary, "\t")
	
	var file = FileAccess.open(file_name, FileAccess.WRITE)
	file.store_string(data)
	file.close()

# load JSON state of whole game from file
func load_from_file(file_name: String) -> Dictionary:
	var file = FileAccess.open(file_name, FileAccess.READ)
	var content = file.get_as_text()
	var json = JSON.new()
	var error = json.parse(content)
	if error == OK:
		var data_received = json.data
		data_received["error"] = null
		return data_received
	else:
		print("JSON Parse Error: ", json.get_error_message(), " in ", content, \
		" at line ", json.get_error_line())
		return {"error": "JSON Parse Error"}

# configure whole game based on JSON
func configure_scenario(dict: Dictionary):
	$Game.configure_game(dict["Game"])
	$Game/Testing.configure_testing(dict["Testing"])
	$Game/Testing/QualityDeck.configure_quality_deck(dict["QualityDeck"])
	$Game/SprintEnd.configure_sprint_end(dict["SprintEnd"])
	
	# remove current issues
	for issue in $Game/Backlog.get_issues():
		$Game/Backlog.remove_issue(issue)
		issue.queue_free()
	
	# load issues
	var issues = {}
	for issue_json in dict["Issues"]:
		var issue = preload("res://issue/issue.tscn").instantiate()
		issue.configure_issue(issue_json)
		issues[issue.name] = issue
		$Game/Backlog.add_issue(issue)
	
	# load child_issues
	for issue_json in dict["Issues"]:
		if issue_json["child_issues"].is_empty():
			continue
		for name_issue in issue_json["child_issues"]:
			issues[issue_json["name"]].add_child_issue(issues[name_issue])
	
	# remove current employees
	for employee in $Game/Office.get_employees():
		$Game/Office.remove_employee(employee, true)
	
	# load employees
	for employee_json in dict["Employees"]:
		var employee = preload("res://employee/employee.tscn").instantiate()
		employee.configure_employee(employee_json)
		$Game/Office.add_employee(employee)
		if not employee_json["assigned to"] == "":
			var employee_hook = Hook.new()
			employee_hook.set_origin(employee)
			if employee_json["assigned to"] == "Testing":
				$Game/Testing.assign_employee(employee_hook)
			else:
				var issue: Issue = issues[employee_json["assigned to"]]
				var issue_hook = Hook.new()
				issue_hook.set_origin(issue)
				employee.assign_issue(issue_hook)
				issue.assign_employee(employee_hook)
