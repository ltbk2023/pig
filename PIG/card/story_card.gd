extends Node2D
class_name StoryCard

# Signal emitted when the player has picked an option. Should be caught by Game,
# which will then destroy this object.
signal done(owner)

var id: int

# All employees mentiones in this card
var employees: Array[Employee]

var title: String

# The story. Pretty self-explanatory.
var story_text: String

# An of possible options (dictionaries)
var options : Array[Dictionary]

# A dictionary that maps strings received from the Deck Master to Callable
# objects
var action_types = \
{
	"modify_stat": Callable(self, "modify_stat")
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Update the view after receiving data from the Deck Master
func update_view():
	$Sprite/Title.text = "[color=RED]" + title + "[/color]"
	$Sprite/Story.text = "[color=BLACK]" + story_text + "[/color]"
	$Sprite/Option1.text = options[0]["text"]
	$Sprite/Option2.text = options[1]["text"]
	
# Modify the stat of an employee 
func modify_stat(employee: Employee, stat_string: String, value: int,
duration: int):
	var stat = Utility.str_to_stat(stat_string)
	var modifier =\
	preload("res://modifier/employee_stat_modifier.tscn").instantiate()
	modifier.initialize(stat, value, duration)
	#EmployeeStatModifier.new(stat, value, duration)
	modifier.attach_employee(employee)
	

# Execute the consequences of an option
func execute_option(option: int):
	for effect in options[option]["effects"]:
		for args_set in effect["args"]:
			action_types[effect["type"]].callv(args_set)
			print("Executing " + str(action_types[effect["type"]])\
			+ " with args: " + str(args_set))
	emit_signal("done", self)
			
func _on_option_1_button_up():
	execute_option(0)

func _on_option_2_button_up():
	execute_option(1)
