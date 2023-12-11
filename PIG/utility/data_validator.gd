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
			"filter": [
				"daughter"
			],
			"name": "Darling",
			"visuals": {
				"accessories_color_1": "ffffffff",
				"accessories_color_2": "ffffffff",
				"accessories_color_3": "ffffffff",
				"beard_model": 0,
				"body_model": 2,
				"clothes_color_1": "eb009dff",
				"clothes_color_2": "ff54b5ff",
				"clothes_color_3": "ff5eb8ff",
				"clothes_model": 2,
				"desk_color_1": "a1632dff",
				"desk_color_2": "c46d2fff",
				"desk_color_3": "c9864fff",
				"desk_model": 1,
				"detail_model": 2,
				"eyeball_color": "ffe6e6ff",
				"hair_back_model": 2,
				"hair_color_1": "13b4bdfe",
				"hair_color_2": "00a2b8ff",
				"hair_front_model": 1,
				"iris_color": "0b0b1bff",
				"laptop_color_1": "ceb1b1ff",
				"laptop_color_2": "cf8081ff",
				"laptop_model": 1,
				"lips_color_1": "ba2f2fff",
				"lips_color_2": "c43b3bff",
				"nose_model": 1,
				"skin_color_1": "c79d83ff",
				"skin_color_2": "edbd9fff",
				"skin_color_3": "f7cdb2ff"
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
			"filter": [
				"wife"
			],
			"name": "Your Wife",
			"visuals": {
				"accessories_color_1": "ffd498ff",
				"accessories_color_2": "ffcc86ff",
				"accessories_color_3": "ffb849ff",
				"beard_model": 0,
				"body_model": 1,
				"clothes_color_1": "530900ff",
				"clothes_color_2": "7b1200ff",
				"clothes_color_3": "981800ff",
				"clothes_model": 0,
				"desk_color_1": "a1632dff",
				"desk_color_2": "c46d2fff",
				"desk_color_3": "c9864fff",
				"desk_model": 0,
				"detail_model": 0,
				"eyeball_color": "ffe6e6ff",
				"hair_back_model": 1,
				"hair_color_1": "d1502cfe",
				"hair_color_2": "b34d25fe",
				"hair_front_model": 1,
				"iris_color": "0b0b1bff",
				"laptop_color_1": "00002cff",
				"laptop_color_2": "ff0066ff",
				"laptop_model": 0,
				"lips_color_1": "ba462fff",
				"lips_color_2": "c4523bff",
				"nose_model": 1,
				"skin_color_1": "d5b09aff",
				"skin_color_2": "f1c8b0ff",
				"skin_color_3": "f9dac6ff"
			}
		}
	],
	"Epilog": {
		"class": "Epilog",
		"comments": {
			"bad": "You barely managed to do that homework. You were surprised by its complexity. Teachers put too much pressure on students! Next day, your daughter presented the project in front of the class. Despite everyone laughing at the crumbling model, your daughter was proud.\n\"I did it with Daddy!\" - she said.\nHowever, your wife had enough of it. \"How could you humiliate our daughter in front of the class?!\" It was over for her. The suitcases were already waiting outside.",
			"failure": "It was a failure! How can you be a good manager when you can't even do homework with your daughter? All the kids at school were laughing at your little angel. She was lying in bed with a fever for a week. Then you quit your job. Someone like you shouldn't be leading future, complicated projects. You even thought your wife would leave you because of that failure! Take the kid and leave. However, it didn't happen that way. From now on she supported you until the very end.",
			"good": "You can honestly say that you have completed your masterpiece, the very best project in your life... well, at least the life you have known so far. The train was beautiful. After scoring highest grade, your daughter took it to a model train competition. Everyone marveled at the beautiful sight, except one person. That man asked your daughter about the glitter engine, and soon all the most prestigous academic institutions raced to recreate this new energy source. The glitter fusion reactor.\nHowever, your wife had enough of your arrogance. You wanted to show her what modern management is, and you did. So she showed you the door.",
			"mixed": "You managed to complete the homework. Your daughter even got a good grade. Your project was nothing extraordinary, just a standard, simple train. But your daughter was boasting about it to everyone—classmates, teachers, uncles, and aunts. Everyone was slowly getting tired of it.\n\"Our daughter is becoming arrogant and big-headed. And you know what? I think it's your fault! You have a negative influence on her!\" - this is how you found out that you no longer live in your home."
		},
		"name": "Epilog"
	},
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
			"child_issues": [
				"Placing the Engineer into the Carriages"
			],
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
			"child_issues": [
				"Placing the Engineer into the Carriages"
			],
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
	"QualityDeck": {
		"cards": {
			"0": 0,
			"1": 0
		},
		"class": "QualityDeck",
		"name": "QualityDeck"
	},
	"SprintEnd": {
		"boundaries": {
			"fail": -9,
			"high": 5,
			"low": -5,
			"warning": -7
		},
		"class": "SprintEnd",
		"clients_visauls": {
			"accessories_color_1": "ffffffff",
			"accessories_color_2": "eeeeeeff",
			"accessories_color_3": "e2e2e2ff",
			"beard_model": 0,
			"body_model": 2,
			"clothes_color_1": "001329ff",
			"clothes_color_2": "001b3bff",
			"clothes_color_3": "05274dff",
			"clothes_model": 0,
			"desk_color_1": "2da174ff",
			"desk_color_2": "39cc94ff",
			"desk_color_3": "40bda8ff",
			"desk_model": 1,
			"detail_model": 2,
			"eyeball_color": "ffe6e6ff",
			"hair_back_model": 3,
			"hair_color_1": "474540fe",
			"hair_color_2": "3c3735fe",
			"hair_front_model": 1,
			"iris_color": "0b0b1bff",
			"laptop_color_1": "979797ff",
			"laptop_color_2": "bfbfbfff",
			"laptop_model": 1,
			"lips_color_1": "210f07ff",
			"lips_color_2": "290f0aff",
			"nose_model": 0,
			"skin_color_1": "24150cff",
			"skin_color_2": "2b1b10ff",
			"skin_color_3": "36201bff"
		},
		"current sprint": 0,
		"issues done this sprint": 0,
		"last_victory_points": 0,
		"name": "SprintEnd",
		"score_settings": {
			"base_score_multiplier": 10
		},
		"total client importance": 0
	},
	"Testing": {
		"class": "Testing",
		"complexity": 0,
		"name": "Testing",
		"testers limit": -1,
		"total_bugs": 0,
		"total_tests": 0
	},
	"cards_data": [
		{
			"employee_filter": [
				[]
			],
			"employee_number": 1,
			"options": [
				{
					"effects": {
						"modify_stat": [
							[
								"${E1}",
								"morale",
								2,
								2
							]
						]
					},
					"text": "Buy ${E1}.name a cupcake"
				},
				{
					"effects": {
						"modify_stat": [
							[
								"${E1}",
								"morale",
								-1,
								1
							]
						]
					},
					"text": "Do nothing"
				}
			],
			"text": "${E1}.name is sad. What do you do?",
			"title": "Sad day"
		},
		{
			"employee_filter": [
				[]
			],
			"employee_number": 1,
			"options": [
				{
					"effects": {
						"modify_stat": [
							[
								"${E1}",
								"morale",
								2,
								2
							]
						]
					},
					"text": "Invite ${E1}.name for a tea break."
				},
				{
					"effects": {
						"modify_stat": [
							[
								"${E1}",
								"morale",
								-1,
								1
							]
						]
					},
					"text": "Encourage ${E1}.name to keep working."
				}
			],
			"text": "${E1}.name looks tired. How will you help?",
			"title": "Tea break"
		},
		{
			"employee_filter": [
				[]
			],
			"employee_number": 1,
			"options": [
				{
					"effects": {
						"modify_stat": [
							[
								"${E1}",
								"morale",
								2,
								2
							]
						]
					},
					"text": "Praise ${E1}.name"
				},
				{
					"effects": {
						"modify_stat": [
							[
								"${E1}",
								"morale",
								-1,
								1
							]
						]
					},
					"text": "Ignore ${E1}.name"
				}
			],
			"text": "${E1}.name appears demotivated. How will you respond?",
			"title": "Recognition"
		},
		{
			"employee_filter": [
				[]
			],
			"employee_number": 1,
			"options": [
				{
					"effects": {
						"modify_stat": [
							[
								"${E1}",
								"morale",
								2,
								2
							]
						]
					},
					"text": "Invite for a tea break."
				},
				{
					"effects": {
						"modify_stat": [
							[
								"${E1}",
								"morale",
								-1,
								1
							]
						]
					},
					"text": "Encourage to keep working."
				}
			],
			"text": "${E1}.name looks tired. How will you help?",
			"title": "Tea break"
		},
		{
			"employee_filter": [
				[]
			],
			"employee_number": 1,
			"options": [
				{
					"effects": {
						"modify_stat": [
							[
								"${E1}",
								"morale",
								2,
								2
							]
						]
					},
					"text": "Offer constructive feedback"
				},
				{
					"effects": {
						"modify_stat": [
							[
								"${E1}",
								"morale",
								-1,
								1
							]
						]
					},
					"text": "Say: Figure it out!"
				}
			],
			"text": "${E1}.name seems unsure about where the project goes. How do you respond?",
			"title": "Assess Project Progress"
		},
		{
			"employee_filter": [
				[],
				[]
			],
			"employee_number": 2,
			"options": [
				{
					"effects": {
						"modify_stat": [
							[
								"${E1}",
								"morale",
								1,
								1
							],
							[
								"${E2}",
								"morale",
								-1,
								1
							]
						]
					},
					"text": "Support ${E1}.name opinion"
				},
				{
					"effects": {
						"modify_stat": [
							[
								"${E1}",
								"morale",
								-1,
								1
							],
							[
								"${E2}",
								"morale",
								1,
								1
							]
						]
					},
					"text": "Support ${E2}.name opinion."
				},
				{
					"effects": {
						"modify_stat": [
							[
								"${E1}",
								"speed",
								-1,
								1
							],
							[
								"${E2}",
								"speed",
								-1,
								1
							]
						]
					},
					"text": "Go to another room and wait."
				}
			],
			"text": "The debate has sparked over whether maple leaves or plane tree leaves would be a better roof covering for the train carriages. \n${E1}.name believes that the platanus tree is more aesthetically pleasing. \n${E2}.name believes that promoting invasive species should be avoided.",
			"title": "Maple or Plane Tree?"
		},
		{
			"employee_filter": [
				[]
			],
			"employee_number": 1,
			"options": [
				{
					"effects": {
						"modify_stat": [
							[
								"${E1}",
								"speed",
								-3,
								1
							]
						]
					},
					"text": "Tell her to clean herself"
				},
				{
					"effects": {
						"modify_stat": [
							[
								"${E1}",
								"speed",
								-1,
								3
							],
							[
								"${E1}",
								"quality",
								-1,
								3
							]
						]
					},
					"text": "Tell her to keep working"
				}
			],
			"text": "${E1}.name spilled on herself “Handy Glue: Bonds Forever”. Her shirt has a new ugly pattern.",
			"title": "Sticky situaction"
		},
		{
			"employee_filter": [
				[
					"wife"
				]
			],
			"employee_number": 1,
			"options": [
				{
					"effects": {
						"modify_stat": [
							[
								"${E1}",
								"speed",
								-3,
								1
							]
						]
					},
					"text": "Explain your management approach"
				},
				{
					"effects": {
						"modify_stat": [
							[
								"${E1}",
								"morale",
								-1,
								5
							]
						]
					},
					"text": "Explain why you should be leader"
				}
			],
			"text": "${E1}.name is at odds with your team leadership. How do you manage this disagreement?",
			"title": "Disagreement"
		},
		{
			"employee_filter": [
				[
					"wife"
				]
			],
			"employee_number": 1,
			"options": [
				{
					"effects": {
						"modify_stat": [
							[
								"${E1}",
								"morale",
								-1,
								5
							]
						]
					},
					"text": "Explain how you were right then."
				},
				{
					"effects": {
						"modify_stat": [
							[
								"${E1}",
								"morale",
								-1,
								5
							]
						]
					},
					"text": "Tell her that the past is past"
				}
			],
			"text": "${E1}.name wants to talk about an old disagreement she had with you.",
			"title": "Old Conflicts"
		},
		{
			"employee_filter": [
				[]
			],
			"employee_number": 1,
			"options": [
				{
					"effects": {
						"modify_stat": [
							[
								"${E1}",
								"morale",
								-1,
								5
							]
						]
					},
					"text": "I will do it later"
				},
				{
					"effects": {
						"modify_stat": [
							[
								"${E1}",
								"speed",
								-3,
								1
							]
						]
					},
					"text": "I already did it. Check it yourself!"
				}
			],
			"text": "${E1}.name wants to talk about broken doors to her wardrobe",
			"title": "Wardrobe Return"
		},
		{
			"employee_filter": [
				[
					"daughter"
				]
			],
			"employee_number": 1,
			"options": [
				{
					"effects": {
						"modify_stat": [
							[
								"${E1}",
								"morale",
								3,
								2
							],
							[
								"${E1}",
								"quality",
								1,
								-1
							],
							[
								"${E1}",
								"speed",
								1,
								-1
							],
							[
								"${E1}",
								"testing",
								-1,
								-1
							]
						]
					},
					"text": "Cupcake, I believe in your success"
				},
				{
					"effects": {
						"modify_stat": [
							[
								"${E1}",
								"morale",
								-3,
								1
							],
							[
								"${E1}",
								"quality",
								-1,
								-1
							],
							[
								"${E1}",
								"speed",
								-1,
								-1
							],
							[
								"${E1}",
								"testing",
								1,
								-1
							]
						]
					},
					"text": "Do you know that you would burn?"
				}
			],
			"text": "${E1}.name tells you about her the biggest dream. She wants to be the first woman to land on the sun.",
			"title": "Big Dream"
		}
	]
}


# Verify whether the input data matches the game schema
static func validate_game_data(data: Dictionary) -> bool:
	return _validate_keys_and_types_simple(data, game_schema)
	
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
		
static func _validate_keys_and_types_simple(data, schema) -> bool:
	for key in schema:
		if not data.has(key):
			return false
	return true
