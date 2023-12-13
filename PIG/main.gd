extends Node2D
class_name Main

var __nr_of_levels : int = 2
var __nr_of_current_levels : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	var metadata = preload("res://level/levels_metadata.json").data
	var i = 0
	for data in metadata:
		var button = Button.new()
		button.text = "Level "+str(i)+": "+data["name"]+"\n"+\
			"Focus on: "+data["focus"]
		button.theme = preload("res://menu/gray_button_2.tres")
		
		button.custom_minimum_size = Vector2(340,60)
		button.alignment =HORIZONTAL_ALIGNMENT_LEFT
		
		$CanvasLayer/LevelsContainer.add_child(button)
		button.button_up.connect(_on_level_button_up.bind(data["path"]))
		i += 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func create_entry_to_level(dict: Dictionary):
	pass
	

# Called when "Play" button is released. Hides menu and adds game scene to Main node.
func _on_play_button_up():
	$CanvasLayer/VBoxContainer.visible = false
	$Background.visible = false
	$CanvasLayer/LevelsContainer.visible = true
	$CanvasLayer/Back.visible = true

#TODO: implement check if game is saved before quitting the game.
# Called when "Quit" button is released. Closes application.
func _on_quit_button_up():
	get_tree().quit()

# Called when "Back" button is released. Return to main menu
func _on_back_button_up():
	$CanvasLayer/VBoxContainer.visible = true
	$Background.visible = true
	$CanvasLayer/LevelsContainer.visible = false
	$CanvasLayer/Back.visible = false
	$CanvasLayer/ControlAbout.visible = false
	$CanvasLayer/Load.visible = false

# save state of whole game to JSON file
func save_to_file(file_name):
	var dictionary = {}
	var issues = []
	var employees = []
	dictionary["Game"] = $Game.to_json()
	dictionary["QualityDeck"] = $Game/Testing/QualityDeck.to_json()
	dictionary["Testing"] = $Game/Testing.to_json()
	dictionary["SprintEnd"] = $Game/SprintEnd.to_json()
	dictionary["Epilog"] = $Game/Epilog.to_json()
	dictionary["cards_data"] = $Game/DeckMaster/CardGenerator.to_json()
	
	for issue in $Game/Backlog.get_issues():
		issues.append(issue.to_json())
	dictionary["Issues"] = issues
	for employee in $Game/Office.get_employees():
		employees.append(employee.to_json())
	dictionary["Employees"] = employees
	
	dictionary["Modifiers"] = $Game/Modifiers.to_json()
	
	if OS.get_name() != "Web":
		file_name = OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS)+ "/" + file_name
		var data = JSON.stringify(dictionary, "\t")
		var file = FileAccess.open(file_name, FileAccess.WRITE)
		file.store_string(data)
		file.close()
	else:
		var code = """
			var data = """ + JSON.stringify(dictionary) +""";
			var filename = \"""" + file_name + """\";
			var blob = new Blob([JSON.stringify(data)], {type: 'text/plain'});
			var link = document.createElement("a");
			link.href = window.URL.createObjectURL(blob);
			link.download = filename;
			link.dataset.downloadurl = ['text/plain', link.download, link.href].join(':');
			document.body.appendChild(link);
			link.click();
			document.body.removeChild(link);
		"""
		JavaScriptBridge.eval(code)

# configure whole game based on JSON
func configure_scenario(dict: Dictionary):
	var max_client_importance : int = 0
	$Game.configure_game(dict["Game"])
	$Game/Testing.configure_testing(dict["Testing"])
	$Game/Testing/QualityDeck.configure_quality_deck(dict["QualityDeck"])
	$Game/SprintEnd.configure_sprint_end(dict["SprintEnd"])
	$Game/SprintEnd.all_victory_points = $Game.victory_points
	$Game/SprintEnd.__current_sprint = $Game.__current_sprint
	$Game/Epilog.configure(dict["Epilog"])

	if dict.has("cards_presets"):
			$Game/DeckMaster/CardGenerator.configure_from_presets(dict["cards_presets"])
	else:
			$Game/DeckMaster/CardGenerator.configure_from_data(dict["cards_data"])
	
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
		max_client_importance += issue.importance_to_client
	
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
		$Game/Office.add_employee(employee)
		employee.configure_employee(employee_json)
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
	if dict.has("Modifiers"):
		$Game/Modifiers.configure($Game/Office.get_employees(), dict["Modifiers"])
	# add max importance to sprint_end
	$Game/SprintEnd.set_max_client_importance(max_client_importance)
	
	# Add first card
	$Game.draw_story_card()
	$Game/CanvasLayer/Button.visible = not $Game/DeckMaster.has_card()

func start_level(file: String,internal:bool):
	var game = load("res://game/game.tscn").instantiate()
	add_child(game)
	# connect signals
	game.end_game.connect(_on_game_end_game)
	game.show_menu.connect(_on_show_menu)
	
	var data
	if internal:
		data = Utility.load_from_resource(file)
	else:
		data = Utility.load_from_file(file)
	configure_scenario(data)
	$CanvasLayer.visible = false
	$Background.visible = false

func start_level_from_string(string:String):
	var data = JSON.parse_string(string)
	if data == null:
		$CanvasLayer/Load/TextEdit.text = ""
		$CanvasLayer/Load/TextEdit.placeholder_text = "JSON parse failed!"
		return
	if not DataValidator.validate_game_data(data):
		$CanvasLayer/Load/TextEdit.text = "Invalid data format!"
		return

	var game = load("res://game/game.tscn").instantiate()
	add_child(game)
	# connect signals
	game.end_game.connect(_on_game_end_game)
	game.show_menu.connect(_on_show_menu)
	
	$CanvasLayer.visible = false
	$Background.visible = false
	$CanvasLayer/Load.visible = false
	$CanvasLayer/Back.visible = false
	configure_scenario(data)
	

func _on_game_end_game():
	$Game.queue_free()
	$Background.visible = true
	$CanvasLayer.visible = true
	$CanvasLayer/LevelsContainer.visible = false
	$CanvasLayer/ControlAbout.visible = false
	$CanvasLayer/Back.visible = false
	$CanvasLayer/VBoxContainer.visible = true
	$CanvasLayer/Load.visible = false
	
func _on_show_menu():
	$Game.visible = false
	$Game/CanvasLayer.visible = false
	$CanvasLayer.visible = true
	$CanvasLayer/LevelsContainer.visible = false
	$CanvasLayer/VBoxContainer2.visible = true
	$CanvasLayer/Back.visible = false

# Called when "Level1" button is released. Load first level
func _on_level_button_up(path):
	start_level(path,true)


func _on_about_button_up():
	$CanvasLayer/VBoxContainer.visible = false
	$Background.visible = false
	$CanvasLayer/Back.visible = true
	$CanvasLayer/ControlAbout.visible = true

func _on_exit_button_up():
	$CanvasLayer/VBoxContainer2.visible = false
	_on_game_end_game()

func _on_resume_button_up():
	$Game.visible = true
	$Game/CanvasLayer.visible = true
	$CanvasLayer.visible = false
	$CanvasLayer/VBoxContainer2.visible = false


func _on_load_button_up():
	$CanvasLayer/VBoxContainer.visible = false
	$Background.visible = false
	$CanvasLayer/Back.visible = true
	$CanvasLayer/ControlAbout.visible = false
	$CanvasLayer/Load.visible = true


func _on_load_from_editor_button_up():
	start_level_from_string($CanvasLayer/Load/TextEdit.text)


func _on_save_button_up():
	save_to_file("save.json")
		
