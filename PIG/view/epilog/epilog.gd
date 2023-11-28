extends Node2D

var good_opinion_bug_limit = 0.1

var mixed_opinion_bug_limit = 0.3


var failure_key = "failure"
var bad_key = "bad"
var mixed_key = "mixed"
var good_key = "good"

var opinion_key = "opinion"
var title_key = "title"
var color_key = "color"

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
	data = dict

func to_json():
	return data


func _on_ok_button_button_up():
	end_game.emit() # Replace with function body.
