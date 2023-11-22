extends Node2D

# total client importance
var total: int = 0

# boundry for Blue Indicator
var __low_boundry: int = 0
var __high_boundry: int = 0
# boundry for Dark Indicator
var __score_boundary_of_fail: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func __rescale(number: int) -> int:
	return number * 340 / total

# update boundry
func update_boundry(low_boundry: int, high_boundry: int, score_boundary_of_fail: int):
	__low_boundry = low_boundry
	__high_boundry = high_boundry
	__score_boundary_of_fail = score_boundary_of_fail

# For red and orange
func set_color_line(color, green: int, offset: int, length: int):
	color.position.x = __rescale(green - offset) if green - offset > 0 else 0
	color.scale.x = __rescale(green) - color.position.x if length < green else __rescale(green)

# For Target and Warning
func set_color_marker(color, left: int, right: int):
	color.position.x = __rescale(left) if left > 0 else  0
	color.scale.x = __rescale(right) if right < total else 340
	color.scale.x -= color.position.x

# update progress bar
# green is satisfaction of client
# orange is point for bugs in backlog
# red is point for found bugs
func update_view(green: int, orange: int, red: int, blue: int):
	$Green.scale.x = __rescale(green)
	set_color_line($Orange, green, red + orange, orange)
	set_color_line($Red, green, red, red)
	set_color_marker($Target, blue + __low_boundry, blue + __high_boundry)
	if blue + __score_boundary_of_fail > 0:
		$Fail.visible = true
		set_color_marker($Fail, $Fail.position.x, blue + __score_boundary_of_fail)
	else:
		$Fail.visible = false
