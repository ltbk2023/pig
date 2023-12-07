extends Object
class_name DataValidator

const game_schema = {
	"Employees": [
		{
			"assigned to": "",
			"base morale": 1,
			"base quality": 1,
			"base speed": 3,
			"base testing": 0,
			"class": "Employee",
			"description": "[color=BLACK]Your little apple of the eye. A small, cheerful nine-year-old girl with a big dream. She wants to be the first woman to land on the sun. She says it's not a problem, you just have to fly at night.[/color]",
			"name": "Darling",
			"filter": ["daughter"],
			"presets":
			{
				"res://employee/sprites/preset/skin_hair_lips_color.ep.json":3,
				"res://employee/sprites/preset/nose.ep.json":1,
				"res://employee/sprites/preset/desk.ep.json":1,	
				"res://employee/sprites/preset/laptop.ep.json":4,		

				"res://employee/sprites/preset/clothes_for_women.ep.json":13,
				"res://employee/sprites/preset/body_detail_for_women.ep.json":6,
				"res://employee/sprites/preset/hair_beard_for_women.ep.json":1
			}
		},
		{
			"assigned to": "",
			"base morale": 0,
			"base quality": 3,
			"base speed": 1,
			"base testing": 3,
			"class": "Employee",
			"description": "[color=BLACK]You've been together for eight years now. It's been tough years. Unfortunately, it was difficult for you to communicate at the beginning because she wasn't familiar with modern management methods. BUT NOW, you'll show her how it's done![/color]",
			"name": "Your Wife",
			"filter": ["wife"],
			"presets":
			{
				"res://employee/sprites/preset/skin_hair_lips_color.ep.json":2,
				"res://employee/sprites/preset/nose.ep.json":2,
				"res://employee/sprites/preset/desk.ep.json":2,	
				"res://employee/sprites/preset/laptop.ep.json":2,		

				"res://employee/sprites/preset/clothes_for_elegant_people.ep.json":8,
				"res://employee/sprites/preset/body_detail_for_women.ep.json":0,
				"res://employee/sprites/preset/hair_beard_for_women.ep.json":0
			}
		}
	],
	"Game": {
		"class": "Game",
		"current sprint": 0,
		"current turn": 0,
		"max sprints": 1,
		"name": "Game",
		"turns per sprint": 5,
		"victory points": 0
	},
	"Issues": [
		{
			"child_issues": ["Placing the Engineer into the Carriages"],
			"class": "Issue",
			"description": "[color=BLACK]Every train must have carriages. Nothing is better suited for this than matchboxes.[/color]",
			"difficulty": 1,
			"importance to client": 5,
			"name": "Carriage from matchboxes",
			"progress": 0,
			"remaining parents": 0,
			"state": 1,
			"time": 2,
			"type": 0
		},
		{
			"child_issues": ["Placing the Engineer into the Carriages"],
			"class": "Issue",
			"description": "[color=BLACK]Chestnut figurines are a traditional way of representing working people among the nations of Central and Eastern Europe.[/color]",
			"difficulty": 1,
			"importance to client": 5,
			"name": "Chestnut Train Driver",
			"progress": 0,
			"remaining parents": 0,
			"state": 1,
			"time": 2,
			"type": 0
		},
		{
			"child_issues": [],
			"class": "Issue",
			"description": "[color=BLACK]Your daughter clearly insists on the realization of a glitter-powered locomotive; without it, the train may never leave the station.[/color]",
			"difficulty": 3,
			"importance to client": 2,
			"name": "Glitter Engine",
			"progress": 0,
			"remaining parents": 0,
			"state": 1,
			"time": 5,
			"type": 0
		},
		{
			"child_issues": [],
			"class": "Issue",
			"description": "[color=BLACK]The last thing remains. It is so important that a small mistake could lead the entire project to disaster.[/color]",
			"difficulty": 2,
			"importance to client": 4,
			"name": "Placing the Engineer into the Carriages",
			"progress": 0,
			"remaining parents": 2,
			"state": 0,
			"time": 1,
			"type": 0
		}
	],
	"Testing": {
		"class": "Testing",
		"name": "Testing",
		"testers limit": -1

	},
	"SprintEnd": {
		"class": "SprintEnd",
		"current sprint": 0,
		"issues done this sprint": 0,
		"last_victory_points": 0,
		"name": "SprintEnd",
		"total client importance": 0,
		"boundaries": {
			"fail": -9,
			"warning":-7,
			"low": -5,
			"high": 5
		},
		"score_setting":{
			"base_score_multiplier" : 10
		},
		"clients_presets":
		{
			"res://employee/sprites/preset/skin_hair_lips_color_for_elderly.ep.json":1,
			"res://employee/sprites/preset/nose.ep.json":1,
			"res://employee/sprites/preset/desk.ep.json":1,	
			"res://employee/sprites/preset/laptop.ep.json":1,		

			"res://employee/sprites/preset/clothes_for_elegant_people.ep.json":1,
			"res://employee/sprites/preset/body_detail_for_women.ep.json":2,
			"res://employee/sprites/preset/hair_beard_for_women.ep.json":2
		},
	},
	"QualityDeck": {
		"cards": {
			"0": 0,
			"1": 0
		},
		"class": "QualityDeck",
		"name": "QualityDeck"
	},
	"Epilog" : {
		"class": "Epilog",
		"name": "Epilog",
		"comments" : {
			"bad" : "You barely managed to do that homework. You were surprised by its complexity. Teachers put too much pressure on students! Next day, your daughter presented the project in front of the class. Despite everyone laughing at the crumbling model, your daughter was proud.\n\"I did it with Daddy!\" - she said.\nHowever, your wife had enough of it. \"How could you humiliate our daughter in front of the class?!\" It was over for her. The suitcases were already waiting outside.",
			"failure" : "It was a failure! How can you be a good manager when you can't even do homework with your daughter? All the kids at school were laughing at your little angel. She was lying in bed with a fever for a week. Then you quit your job. Someone like you shouldn't be leading future, complicated projects. You even thought your wife would leave you because of that failure! Take the kid and leave. However, it didn't happen that way. From now on she supported you until the very end.",
			"good" : "You can honestly say that you have completed your masterpiece, the very best project in your life... well, at least the life you have known so far. The train was beautiful. After scoring highest grade, your daughter took it to a model train competition. Everyone marveled at the beautiful sight, except one person. That man asked your daughter about the glitter engine, and soon all the most prestigous academic institutions raced to recreate this new energy source. The glitter fusion reactor.\nHowever, your wife had enough of your arrogance. You wanted to show her what modern management is, and you did. So she showed you the door.",
			"mixed": "You managed to complete the homework. Your daughter even got a good grade. Your project was nothing extraordinary, just a standard, simple train. But your daughter was boasting about it to everyone—classmates, teachers, uncles, and aunts. Everyone was slowly getting tired of it.\n\"Our daughter is becoming arrogant and big-headed. And you know what? I think it's your fault! You have a negative influence on her!\" - this is how you found out that you no longer live in your home."
		}
	},
	"cards_presets":{
		"res://card/presets/comforting_cards.json":[0,1,2,3,4],
		"res://level/level_1_cards.json":[0,1,2,3,4,5]
	}
}

# Verify whether the input data matches the game schema
static func validate_game_data(data: Dictionary) -> bool:
	return _validate_keys_and_types(data, game_schema)
	
static func _validate_keys_and_types(data, schema) -> bool:
	var data_keys = data.keys()
	data_keys.sort()
	var schema_keys = schema.keys()
	schema_keys.sort()
	if schema_keys != data_keys:
		return false
	for key in data_keys:
		if "presets" in key:
			continue
		# In JSON all numeric values are floats, so we will treat the schema's
		# ints as floats
		var type = TYPE_FLOAT if typeof(schema[key]) == TYPE_INT else typeof(schema[key])
		if typeof(data[key]) != type and data[key] != null:
			return false
		if typeof(data[key]) == TYPE_DICTIONARY:
			if not _validate_keys_and_types(data[key], schema[key]):
				return false
		if typeof(data[key]) == TYPE_ARRAY:
			for i in range(len(data[key])):
				if typeof(data[key][i]) == TYPE_DICTIONARY:
					if not _validate_keys_and_types(data[key][i], schema[key][i]):
						return false
	return true
		
