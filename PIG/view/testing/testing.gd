extends Node2D
class_name Testing


# Signal that informs the tree that the player wants to assign an employee to
# testing
signal assign(owner)

# Maximum number of simultaneous testers
# -1 represent infinity
@export var testers_limit:int = -1


var bugs_in_last_turn = 0
var test_in_last_turn = 0

var total_bugs = 0
var total_test = 0
# Sent up the tree when a bug is found by testing. Should be caught by Game
# which will add a random bug issue to the Backlog
signal bug_found()

# Called when the node enters the scene tree for the first time.
func _ready():
	update_result_text()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Update QualityCardsNum text to include the current number of cards in the
# quality deck
func update_quality_cards_text():
	pass
	
func get_bugs_to_test_text(bugs,tests):
	var st = "[b]"
	if bugs > 0:
		st+="[color=RED]"+str(bugs)+"[/color]"
	else:
		st += str(bugs)
	st+="[/b] Bugs Found During [b]"+str(tests)+"[/b] Tests"
	return st
	
# Update Result text to show the result of testing
func update_result_text():
	$Background/Result.text = "Today:\n\t"+\
		get_bugs_to_test_text(bugs_in_last_turn,test_in_last_turn)+\
	"\nTotal:\n\t"+\
		get_bugs_to_test_text(total_bugs,total_test)

func update_testers_text():
	var st = "Testers:"
	for hook in $EmployeeHook.get_children():
		if !hook.is_queued_for_deletion():
			st += "\n\t"+hook.get_origin().name
	$Background/Testers.text = st

func new_turn():
	bugs_in_last_turn = 0
	test_in_last_turn = 0
	update_result_text()

# Send the assign_testing signal up the tree. Should be received by Game.
func _on_assign_button_button_up():
	emit_signal("assign",self)
	
# Assign employee to testing. This works similar to assigning employee to
# issue, except multiple Employees can be assigned simultaneously
func assign_employee(hook: Hook):
	$EmployeeHook.add_child(hook)
	update_testers_text()

# check if employee can be assigned to testing
# return true when number of testers is smaller than limit 
# or limit is set to -1
func check_employee_can_be_assigned():
	return testers_limit == -1 or $EmployeeHook.get_child_count() < testers_limit
	
# Test [amount] quality cards. Update result visuals
func test(amount: int):
	total_test += amount
	test_in_last_turn += amount
	
	var cards = $QualityDeck.check_cards(amount)
	var bugs = cards[QualityDeck.QualityType.BUG]
	if not $QualityDeck.remove_card(QualityDeck.QualityType.BUG, bugs):
		print("Removing non-extisting bugs. This shouldn't be possible.")
		return
	
	total_bugs += bugs
	bugs_in_last_turn += bugs
	update_result_text()
	$Background/Monitor.bugs_percent = float(bugs_in_last_turn)/test_in_last_turn
	for i in range(bugs):
		emit_signal("bug_found")
		
# Unassign given employee from testing. Return bool indicating whether the
# operation was successful
func unassign_employee(employee: Employee) -> bool:
	for hook in $EmployeeHook.get_children():
		if hook.get_origin() == employee:
			hook.queue_free()
			update_testers_text()
			return true
	return false
	
# Return a JSON dictionary representing this object in its current state
func to_json():
	var dictionary = {
		"class": "Testing",
		"name": name,
		"testers limit": testers_limit,
		"total_bugs":total_bugs,
		"total_tests":total_test,
		"complexity":$Background/Monitor.complexity
	}
	return dictionary

# Basic configuration of Testing, use to load scenario
func configure_testing(dict: Dictionary) -> bool:
	if dict["class"] == "Testing":
		Utility.delete_children($EmployeeHook)
		testers_limit = dict["testers limit"]
		if dict.has("total_bugs"):
			total_bugs = dict["total_bugs"]
		if  dict.has("total_tests"):
			total_test = dict["total_tests"]
		if  dict.has("complexity"):
			$Background/Monitor.complexity = dict["complexity"]
		return true
	return false

func _get_quality_deck():
	return $QualityDeck
