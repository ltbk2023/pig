extends Node2D
class_name CardGenerator


# Dictionary that holds story cards parsed from the file under :json_path
var story_cards: Array[CardDTO]

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()

func configure_from_data(data):
	story_cards = []
	for sc in data:
		var card = CardDTO.new()
		card.load(sc)
		story_cards.append(card)

func configure_from_presets(dict):
	var story_cards_data = []
	for path in dict:
		var data = load(path).data
		for index in dict[path]:
			story_cards_data.append(data[index])
	configure_from_data(story_cards_data)

func to_json():
	var data = []
	for card in story_cards:
		data.append(card.to_json())
	return data
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Return a random entry from the JSON File
func generate_card() -> CardDTO:
	var card_id = randi_range(0, story_cards.size() - 1)
	return story_cards[card_id]
