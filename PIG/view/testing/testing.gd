extends Node2D
class_name Testing

# Signal that informs the tree that the player wants to assign an employee to
# testing
signal assign_testing

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
	emit_signal("assign_testing")
	
# Assign employee to testing. This works similar to assigning employee to
# issue, except multiple Employees can be assigned simultaneously
func assign_employee(hook: Hook):
	$EmployeeHook.add_child(hook)
