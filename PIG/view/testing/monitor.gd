extends Sprite2D


@export var max_complexity = 0.3
@export var max_bugs = 0.1
@export var speed_mulitplier = 10

var speed = 0
@export var complexity:float = 0.0:
	set(c):
		complexity = c
		var pixels = $Pixels.texture.color_ramp
		if pixels is Gradient:
			var p = 1-1/(1+c/10)
			pixels.set_offset(2,1-max_complexity*p)
			speed = speed_mulitplier*p 

@export var bugs_percent:float = 0.0:
	set(b):
		bugs_percent = b
		var pixels = $Pixels.texture.color_ramp
		if pixels is Gradient:
			print(bugs_percent)
			pixels.set_offset(1,max_bugs*bugs_percent)
			

# Called when the node enters the scene tree for the first time.
func _ready():
	complexity = complexity
	bugs_percent = bugs_percent


var progres:float = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	progres -= delta*speed
	$Pixels.texture.noise.offset.y = int(progres)
