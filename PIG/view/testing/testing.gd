extends Node2D
class_name Testing

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
