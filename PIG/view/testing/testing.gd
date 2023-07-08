extends Node2D
class_name Testing


# Signal that informs the tree that the player wants to assign an employee to
# testing
signal assign(owner)

# Maximum number of simultaneous testers
# -1 represent infinity
@export var testers_limit:int = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	update_quality_cards_text()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Update QualityCardsNum text to include the current number of cards in the
# quality deck
func update_quality_cards_text():
	pass
	
# Update Result text to show the result of testing
func update_result_text():
	pass


# Send the assign_testing signal up the tree. Should be received by Game.
func _on_assign_button_button_up():
	emit_signal("assign",self)
	
# Assign employee to testing. This works similar to assigning employee to
# issue, except multiple Employees can be assigned simultaneously
func assign_employee(hook: Hook):
	$EmployeeHook.add_child(hook)

# check if employee can be assigned to testing
# return true when number of testers is smaller than limit 
# or limit is set to -1
func check_employee_can_be_assigned():
	return testers_limit == -1 or $EmployeeHook.get_child_count() < testers_limit


