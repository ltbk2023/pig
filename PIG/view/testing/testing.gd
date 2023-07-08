extends Node2D
class_name Testing


# Sent up the tree when a bug is found by testing. Should be caught by Game
# which will add a random bug issue to the Backlog
signal bug_found()

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
func update_result_text(amount: int):
	$Background/Result.text = "Result:\nBugs: " + str(amount)
	
# Test [amount] quality cards. Update result visuals
# TODO: add bug issue to backlog
func test(amount: int):
	var cards = $QualityDeck.check_cards(amount)
	var bugs = cards[QualityDeck.QualityType.BUG]
	update_result_text(amount)
	emit_signal("bug_found")
