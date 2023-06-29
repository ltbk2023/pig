extends Node
class_name QualityDeck

enum QualityType{CLEAN,BUG}

# dictionary that contains amounts of cards 
@export var cards = {
	QualityType.CLEAN:0,
	QualityType.BUG:0
	}

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
