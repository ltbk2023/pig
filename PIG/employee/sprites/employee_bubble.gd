@tool
extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()

func randomize_text():
	for line in $Text.get_children():
		line.randomize_line()
