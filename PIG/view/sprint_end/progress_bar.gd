extends Node2D

# total client importance
var total: int = 0

# boundry for Blue Indicator
var __low_boundry: int = 0
var __high_boundry: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func __rescale(number: int) -> int:
	return number * 340 / total

# update boundry
func update_boundry(low_boundry: int, high_boundry: int):
	__low_boundry = low_boundry
	__high_boundry = high_boundry

# update progress bar
# green is satisfaction of client
# orange is point for bugs in backlog
# red is point for found bugs
func update_view(green: int, orange: int, red: int, blue: int):
	$Green.scale.x = __rescale(green)
	if green - red - orange > 0:
		$Orange.position.x = __rescale(green - red - orange)
	else:
		$Orange.position.x = 0
	if orange < green:
		$Orange.scale.x = __rescale(green) - $Orange.position.x
	else:
		$Orange.scale.x = __rescale(green)
		
	if green - red > 0:
		$Red.position.x = __rescale(green - red)
	else:
		$Red.position.x = 0
	if red < green:
		$Red.scale.x = __rescale(green) - $Red.position.x
	else:
		$Red.scale.x = __rescale(green)
	$Target.position.x = __rescale(blue + __low_boundry)
	if blue + __high_boundry < total:
		$Target.scale.x = __rescale(__high_boundry - __low_boundry)
	else:
		$Target.scale.x = __rescale(total - blue - __low_boundry)
