@tool
extends Node2D

@export var color1 = Color.WHITE:
	set(c):
		color1 = c
		if is_inside_tree():
			_update_color1()
@export var color2 = Color.LIGHT_GRAY:
	set(c):
		color2 = c
		if is_inside_tree():
			_update_color2()
@export var color3 = Color.DARK_GRAY:
	set(c):
		color3 = c
		if is_inside_tree():
			_update_color3()
@export var color4 = Color.DIM_GRAY:
	set(c):
		color4 = c
		if is_inside_tree():
			_update_color4()

var button_theme = preload("res://card/sprite/button_gradient.tres")
# Called when the node enters the scene tree for the first time.
func _ready():
	_update_color1()
	_update_color2()
	_update_color3()
	_update_color4()

func _update_color1():
	$Sprite.modulate = color1
	
func _update_color2():
	$Title.get_theme_stylebox("normal").\
		texture.gradient.set_color(0,color2)
	$Story.get_theme_stylebox("normal").bg_color = color2
	
func _update_color3():
	$Title.get_theme_stylebox("normal").\
		texture.gradient.set_color(1,color3)
	$Bar.modulate = color3
	button_theme.get_stylebox("normal","Button").\
		texture.gradient.set_color(0,color3)
	button_theme.get_stylebox("pressed","Button").\
		texture.gradient.set_color(1,color3)

func _update_color4():
	button_theme.get_stylebox("normal","Button").\
		texture.gradient.set_color(1,color4)
	button_theme.get_stylebox("pressed","Button").\
		texture.gradient.set_color(0,color4)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# creates button with given text
# sets it and adds in to options
# update positon of the elements
func add_option(text)->Button:
	var button = Button.new()
		
	$Options.add_child(button)
	
	button.text = text
	
	button.position = Vector2(10,50*$Options.get_child_count())
	button.size = Vector2(340,40)
	button.theme = button_theme
	
	$Options.position.y -= 50
	$Bar.position.y -= 50
	$Story.size.y -= 50
	return button

# removes all options buttons
# reset positions of the elements
func reset_options():
	var count = $Options.get_child_count()
	$Options.position.y += 50*count
	$Bar.position.y += 50*count
	$Story.size.y += 50*count
	
	for child in $Options.get_children():
		$Options.remove_child(child)
		child.queue_free()
		
