extends Node2D
class_name Main

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Called when "Play" button is released. Hides menu and adds game scene to Main node
func _on_play_button_up():
	var game = load("res://game/game.tscn").instantiate()
	add_child(game)
	$Background.visible = false
	$CanvasLayer.visible = false
