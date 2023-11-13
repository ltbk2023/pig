extends Node2D
class_name StoryCard

# Signal emitted when the player has picked an option. Should be caught by
# Deck Master which will transfer the signal to Game.
signal done(owner)

var id: int

# All employees mentiones in this card
var employees: Array[Employee]

var title: String

# The story. Pretty self-explanatory.
var story_text: String

# An of possible options (dictionaries)
var options : Array[OptionDTO]


# Called when the node enters the scene tree for the first time.
func _ready():
	update_view()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Update the view after receiving data from the Deck Master
func update_view():
	$Sprite/Title.text = "[center][color=BLACK][b]" + title + "[/b][/color][/center]"
	$Sprite/Story.text = "[center][color=BLACK]" + story_text + "[/color][/center]"
	
	$Sprite.reset_options()
	for i in range(options.size()):
		var button:Button = $Sprite.add_option(options[i].text)
		button.button_up.connect(_on_option_selected.bind(i))


# Execute the consequences of an option
func execute_option(option: int):
	var op = options[option]
	for type in op.effects:
		for effect in op.effects[type]:
			var modifier =effect.create_modifier()
			get_tree().call_group("ModifierHandlers", "handle", modifier)

	emit_signal("done", self)

func _on_hide_button_up():
	self.visible = false

func _on_option_selected(option:int):
	execute_option(option)
