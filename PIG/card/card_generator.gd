extends Node2D
class_name CardGenerator

@export var json_path: String = "story_cards.json"

# Dictionary that holds story cards parsed from the file under :json_path
var story_cards: Dictionary

# Called when the node enters the scene tree for the first time.
func _ready():
	story_cards = Utility.load_from_file(json_path)
	randomize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Return a random entry from the JSON File
func generate_card() -> Dictionary:
	var card_id = str(randi_range(0,story_cards.size()))
	return story_cards[card_id]	
