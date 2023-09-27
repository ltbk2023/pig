@tool
extends Node2D

@export var dot=false:
	set(d):
		if is_inside_tree():
			dot = d
			set_dot(d)
@export var tab=false:
	set(t):
		if is_inside_tree():
			tab = t
			set_tab(t)
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# calls set_dot and set_line 
# it is usefull in animation
func set_line(dot:bool,tab:bool):
	set_dot(dot)
	set_tab(tab)

# set visibility of dot in front of line
func set_dot(dot:bool):
	$Dot.visible = dot

# set postion where text start
func set_tab(tab:bool):
	if tab:
		$MainText.position.x = 3
	else:
		$MainText.position.x = 0

# randomize text look
func randomize_line():
	$MainText.frame_coords.y = randi_range(0,$MainText.vframes-1)
