extends Node2D
class_name CardGenerator


# Dictionary that holds story cards parsed from the file under :json_path
var story_cards: Array[CardDTO]
var story_cards_per_turn: Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()

func configure_for_turn(dict):
	for number in dict:
		var path = dict[number]["path"]
		var data = load(path).data
		var sc = data[dict[number]["index"]]
		var card = CardDTO.new()
		card.load(sc)
		story_cards_per_turn[number] = card

func configure_from_data(data):
	story_cards = []
	for sc in data:
		var card = CardDTO.new()
		card.load(sc)
		if sc.has("turn"):
			story_cards_per_turn[sc["turn"]] = card
		story_cards.append(card)

func configure_from_presets(dict):
	if dict.has("cards_per_turn"):
		configure_for_turn(dict["cards_per_turn"])
		dict.erase("cards_per_turn")
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
	var cards_per_turn = {}
	for number in story_cards_per_turn:
		var card = story_cards_per_turn[number]
		var json_card = card.to_json()
		json_card["turn"] = number
		data.append(json_card)
	return data
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Return a random entry from the JSON File
func generate_card(turn: int) -> CardDTO:
	var str_turn = str(turn)
	if story_cards_per_turn.has(str_turn):
		var card = story_cards_per_turn[str_turn]
		story_cards_per_turn.erase(str_turn)
		return card
	if story_cards.size() == 0:
		return null
	var card_id = randi_range(0, story_cards.size() - 1)
	return story_cards.pop_at(card_id)
