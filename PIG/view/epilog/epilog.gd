extends Node2D

var good_opinion_bug_limit = 0.1

var mixed_opinion_bug_limit = 0.3


const failure_key = "failure"
const bad_key = "bad"
const mixed_key = "mixed"
const good_key = "good"

const opinion_key = "opinion"
const title_key = "title"
const color_key = "color"

var data

signal  end_game()
# Called when the node enters the scene tree for the first time.
func _ready():
	data = load("res://view/epilog/epilog.json").data
	show_epilog(true,0.39)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func show_epilog(failure:bool,bugs_percent):
	var dict:Dictionary
	$BugPercent.visible = true
	if failure:
		dict = data[failure_key]
		$Image.frame = 0
		$BugPercent.visible = false
	elif bugs_percent <= good_opinion_bug_limit:
		dict = data[good_key]
		$Image.frame = 3
	elif bugs_percent <= mixed_opinion_bug_limit:
		dict = data[mixed_key]
		$Image.frame = 2
	else:
		dict = data[bad_key]
		$Image.frame = 1
	
	$BugPercent.text = "Percent of Bugs in Software: [b]"+str(ceil(100*bugs_percent))+"%[/b]"
	
	$Backround.modulate = Color.from_string(dict[color_key],Color.WHITE_SMOKE)
	$Opinion.text = dict.get(opinion_key,"")
	$Title.text = "[center][b]"+dict.get(title_key,"")+"[/b][/center]"
	
func configure(dict:Dictionary):
	var comments = dict["comments"] 
	for key in comments:
		data[key][opinion_key] = comments[key]

func to_json():
	var dictionary = {
		"class" : "Epilog",
		"name" : "Epilog",
		"comments" : {
			bad_key : data[bad_key][opinion_key],
			failure_key : data[failure_key][opinion_key],
			good_key : data[good_key][opinion_key],
			mixed_key : data[mixed_key][opinion_key]
		}
	}
	return dictionary


func _on_ok_button_button_up():
	end_game.emit() # Replace with function body.
