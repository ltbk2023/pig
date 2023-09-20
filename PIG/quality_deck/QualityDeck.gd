extends Node
class_name QualityDeck

enum QualityType{CLEAN,BUG}
enum QualityPreset{LOW,HIGH}

# dictionary that contains amounts of cards 
@export var cards = {
	QualityType.CLEAN:0,
	QualityType.BUG:0
	}

# dictionary that defined presets
# presets are dictionaries that contain propabilities of cards types
# propabilies should add up to 1.0
@export var presets_propabilities = {
	QualityPreset.LOW :{
		QualityType.BUG:0.75,
		QualityType.CLEAN:0.25
	},
	QualityPreset.HIGH:{
		QualityType.BUG:0.25,
		QualityType.CLEAN:0.75
	}
	
}

func _ready():
	randomize()

# add given amount of cards of given type to deck
# return false when amount is negative number 
# or type doesn't exist in cards dictionary
func add_cards(type:QualityType,amount:int)-> bool:
	if amount <= 0 || type not in cards:
		return false
	else:
		cards[type] += amount
		return true

# remove given amount of cards of given type from deck
# return false if amount cards in deck after removing will be negative
# or type doesn't exist in cards dictionary
func remove_card(type:QualityType,amount:int)->bool:
	if type not in cards || cards[type] - amount < 0:
		return false
	else:
		cards[type] -= amount
		return true
		
# check random card's types
# function doesn't modify deck
# it performs sampling without replacement on copy of cards dictionary 
# if amount is negative, return empty dictionary
# if amount is not smaller then amount of cards, return copy of cards
func check_cards(amount:int)->Dictionary:
	if amount < 0:
		return Dictionary()
	
	# create copy of deck state
	var local = cards.duplicate()
	
	var result:Dictionary= Dictionary()
	var local_sum = 0
	
	# initiatie result dictionary with zeros
	# calculate total number of cards in deck
	for type in local:
		result[type] = 0
		local_sum +=local[type]
		
	if local_sum <= amount:
		return local
		
	for i in range(amount):
		# get position of random card in current deck
		var pose = randi_range(0,local_sum-1)
		
		# finding type of that card
		for type in local:
			if local[type] > 0:
				
				# check if card is given type
				if local[type] > pose:
					# add card to the result
					result[type] += 1
					# remove card from the deck
					local[type] -= 1
					local_sum -= 1
					break
				else:
					pose -= local[type]
	return result

# add cards with defined propability of becoming bug or clean code
# if amount is negative, return false
func add_from_preset(preset:QualityPreset,amount:int) -> bool:
	if amount < 0:
		return false
	var propabilities = presets_propabilities[preset]
	for i in range(amount):
		# get random value from <0.0,1.0> to define card type
		var p = randf()
		for type in propabilities:
			# check if card is given type
			if p <= propabilities[type]:
				# add card to deck
				cards[type] += 1
				break
			else:
				p -= propabilities[type]
	return true
	
# Return a JSON string representing this object in its current state
func to_json():
	var dictionary = {
		"class": "QualityDeck",
		"name": name,
		"cards": cards
	}
	var json_string = JSON.stringify(dictionary, "\t")
	return json_string
