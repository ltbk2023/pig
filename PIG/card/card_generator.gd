extends Node2D
class_name CardGenerator

@export var json_path: String = "story_cards.json"

# Dictionary that holds story cards parsed from the file under :json_path
var story_cards: Array[CardDTO]

# Called when the node enters the scene tree for the first time.
func _ready():
	var story_cards_json = Utility.load_from_resource(json_path)
	story_cards = []
	for sc in story_cards_json:
		var card = CardDTO.new()
		card.load(sc)
		story_cards.append(card)
	randomize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Return a random entry from the JSON File
func generate_card() -> CardDTO:
	var card_id = randi_range(0, story_cards.size() - 1)
	return story_cards[card_id]
