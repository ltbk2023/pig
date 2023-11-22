# This script works also in the editor. Be carefull!
# Changes in code will have effects only after saving scene
@tool
extends Node2D

# configuration when not inside three may have no effect
# so in case of that configuration is set again in _ready()
var config = null
func _ready():
	if config != null:
		configure_visuals(config)
		config = null
# group of variables that modify visible state of employee
@export_group("State")
# control if employee look straight or down 
@export var up=true:
	set(u):
		up = u
		if is_inside_tree():
			update_up_down()
@export var laptop_open=true:
	set(l):
		laptop_open = l
		if is_inside_tree():
			update_laptop()
# control angry, unhappy look 
@export var angry = false:
	set(a):
		angry = a
		if is_inside_tree():
			update_angry()
#control smile of employee
@export var smile = false:
	set(s):
		smile = s
		if is_inside_tree():
			update_smile()
#control visibility of Desk and Laptop
@export var sitting = true:
	set(s):
		sitting = s
		if is_inside_tree():
			update_sitting()
			
@export_range(-1,1) var eye_pose = 0:
	set(e):
		eye_pose = e
		if is_inside_tree():
			$EyeLeftUD/Iris.position.x = max(-1,eye_pose-1)
			$EyeRigthUD/Iris.position.x = min(0,eye_pose)
@export var bubble = false:
	set(b):
		bubble = b
		if is_inside_tree():
			$Bubble.visible = b
# group of variables that modify colors of the employee
# variables are in tematic subgroups
@export_group("Color")
@export_subgroup("Skin")
@export var skin_1=Color.WHITE:
	set(c):
		skin_1 = c
		if is_inside_tree():
			$FaceUD/Skin1.modulate = c
			$NoseUD/Skin1.modulate = c
			$Body/Skin1.modulate = c
			$Detail/Skin1.modulate = c

@export var skin_2=Color.WHITE:
	set(c):
		skin_2 = c
		if is_inside_tree():
			$FaceUD/Skin2.modulate = c
			$Body/Skin2.modulate = c
		
@export var skin_3=Color.WHITE:
	set(c):
		skin_3 = c
		if is_inside_tree():
			$FaceUD/Skin3.modulate = c
			$NoseUD/Skin3.modulate = c
			$Body/Skin3.modulate = c
			$Detail/Skin3.modulate = c

@export_subgroup("Hair")
@export var hair_1=Color.WHITE:
	set(c):
		hair_1 = c
		if is_inside_tree():
			$FrontHairUD/Hair1.modulate= c
			$BackHair/Hair1.modulate= c
			$EyeBrowLeft/Hair1.modulate = c
			$EyeBrowRigth/Hair1.modulate = c
			$BeardUD/Hair1.modulate = c

@export var hair_2=Color.WHITE:
	set(c):
		hair_2 = c
		if is_inside_tree():
			$FrontHairUD/Hair2.modulate= c
			$BackHair/Hair2.modulate= c
			$EyeBrowLeft/Hair2.modulate = c
			$EyeBrowRigth/Hair2.modulate = c
			$BeardUD/Hair2.modulate = c
			
@export_subgroup("Lips")
@export var lips_1=Color.WHITE:
	set(c):
		lips_1 = c
		if is_inside_tree():
			$Lips/Lips1.modulate= c
		
@export var lips_2=Color.WHITE:
	set(c):
		lips_2 = c
		if is_inside_tree():
			$Lips/Lips2.modulate= c
@export_subgroup("Eyes")
@export var eyeball=Color.WHITE:
	set(c):
		eyeball = c
		if is_inside_tree():
			$EyeLeftUD/EyeBall.modulate= c
			$EyeRigthUD/EyeBall.modulate= c

@export var iris=Color.BLACK:
	set(c):
		iris = c
		if is_inside_tree():
			$EyeLeftUD/Iris.modulate= c
			$EyeRigthUD/Iris.modulate= c
@export_subgroup("Clothes")
@export var clothes1 = Color.WHITE:
	set(c):
		clothes1 =c
		if is_inside_tree():
			$Body/Clothes1.modulate = c
			$Detail/Clothes1.modulate = c

@export var clothes2 = Color.WHITE:
	set(c):
		clothes2 =c
		if is_inside_tree():
			$Body/Clothes2.modulate = c

@export var clothes3 = Color.WHITE:
	set(c):
		clothes3 =c
		if is_inside_tree():
			$Body/Clothes3.modulate = c
			$Detail/Clothes3.modulate = c
@export_subgroup("Accessories")
@export var accessories1 = Color.WHITE:
	set(c):
		accessories1 =c
		if is_inside_tree():
			$Body/Accessories1.modulate = c
			$Detail/Accessories1.modulate = c

@export var accessories2 = Color.WHITE:
	set(c):
		accessories2 =c
		if is_inside_tree():
			$Body/Accessories2.modulate = c

@export var accessories3 = Color.WHITE:
	set(c):
		accessories3 =c
		if is_inside_tree():
			$Body/Accessories3.modulate = c
			$Detail/Accessories3.modulate = c
@export_subgroup("Desk")
@export var desk_1=Color.WHITE:
	set(c):
		desk_1 = c
		if is_inside_tree():
			$Desk/Desk1.modulate = c
@export var desk_2=Color.WHITE:
	set(c):
		desk_2 = c
		if is_inside_tree():
			$Desk/Desk2.modulate = c
@export var desk_3=Color.WHITE:
	set(c):
		desk_3 = c
		if is_inside_tree():
			$Desk/Desk3.modulate = c
@export_subgroup("Laptop")
@export var laptop_1=Color.WHITE:
	set(c):
		laptop_1 = c
		if is_inside_tree():
			$Laptop/Laptop1.modulate = c
@export var laptop_2=Color.WHITE:
	set(c):
		laptop_2 = c
		if is_inside_tree():
			$Laptop/Laptop2.modulate = c
			
# group of variables that modify look of employee
# look is updaded via frame_coords.y
# when frame_coords.y depends on more than one variable,
# after updating variable adequate function is called to get coord
@export_group("Model")
@export_range(0,1) var nose:int=0:
	set(y):
		nose = y
		if is_inside_tree():
			var cord =  get_up_down_coord(y)
			$NoseUD/Skin1.frame_coords.y = cord
			$NoseUD/Skin3.frame_coords.y = cord
			
@export_range(0,2) var hair_front:int=0:
	set(y):
		hair_front = y
		if is_inside_tree():
			var cord =  get_up_down_coord(y)
			$FrontHairUD/Hair1.frame_coords.y = cord
			$FrontHairUD/Hair2.frame_coords.y = cord
			
@export_range(0,3) var hair_back:int=0:
	set(y):
		hair_back = y
		if is_inside_tree():
			$BackHair/Hair1.frame_coords.y = y
			$BackHair/Hair2.frame_coords.y = y
			
@export_range(0,3) var beard:int=0:
	set(y):
		beard = y
		if is_inside_tree():
			var cord =  get_up_down_coord(y)
			$BeardUD/Hair1.frame_coords.y = cord
			$BeardUD/Hair2.frame_coords.y = cord
			
@export_range(0,3) var body:int=0:
	set(y):
		body=y
		if is_inside_tree():
			y = get_body_clothes_coord()
			for ch in $Body.get_children():
				ch.frame_coords.y = y

@export_range(0,4) var clothes:int=0:
	set(y):
		clothes = y
		if is_inside_tree():
			y = get_body_clothes_coord()
			for ch in $Body.get_children():
				ch.frame_coords.y = y
			y = get_detail_clothes_coord()
			for ch in $Detail.get_children():
				ch.frame_coords.y = y
@export_range(0,3) var detail:int=0:
	set(y):
		detail =y
		if is_inside_tree():
			y = get_detail_clothes_coord()
			for ch in $Detail.get_children():
				ch.frame_coords.y = y
				
@export_range(0,1) var desk:int=0:
	set(y):
		desk =y
		if is_inside_tree():
			for ch in $Desk.get_children():
				ch.frame_coords.y = y
				
@export_range(0,1) var laptop:int=0:
	set(y):
		laptop = y
		if is_inside_tree():
			update_laptop()
			
# return offset that depends on up variable
func get_up_down_offset():
	if up:
		return 0
	else:
		return 1

# return coord modify by up down state
func get_up_down_coord(base):
	return 2*base+get_up_down_offset()

# return coord that depends on body and coords states
func get_body_clothes_coord():
	return 4*clothes+body

# return coord that depends on detail and coords states
func get_detail_clothes_coord():
	return 4*clothes+detail

func update_laptop():
	var mod = 0
	if laptop_open:
		mod = 1
	var cord=  2*laptop+mod
	$Laptop/Laptop1.frame_coords.y = cord
	$Laptop/Laptop2.frame_coords.y = cord

# realize change of up down state
func update_up_down():
	# update sprites frames
	var cord = get_up_down_offset()
	$FaceUD/Skin1.frame_coords.y = cord
	$FaceUD/Skin2.frame_coords.y = cord
	$FaceUD/Skin3.frame_coords.y = cord
	
	$EyeLeftUD/EyeBall.frame_coords.y = cord
	$EyeLeftUD/Iris.frame_coords.y = cord
	
	$EyeRigthUD/EyeBall.frame_coords.y = cord
	$EyeRigthUD/Iris.frame_coords.y = cord
	
	cord = get_up_down_coord(hair_front)
	$FrontHairUD/Hair1.frame_coords.y = cord
	$FrontHairUD/Hair2.frame_coords.y = cord
	
	cord = get_up_down_coord(nose)
	$NoseUD/Skin1.frame_coords.y = cord
	$NoseUD/Skin3.frame_coords.y = cord
	
	cord = get_up_down_coord(beard)
	$BeardUD/Hair1.frame_coords.y = cord
	$BeardUD/Hair2.frame_coords.y = cord
	
	# update sprites position
	if up:
		$Lips.position.y = 4
		$NoseUD.position.y = 1
		$EyeLeftUD.position.y = 0.5
		$EyeRigthUD.position.y = 0.5
		$EyeBrowLeft.position.y = -1
		$EyeBrowRigth.position.y = -1
		$FrontHairUD.position.y = 0
		$BackHair.position.y = 0.5
		$BeardUD.position.y = 6
	else:
		$Lips.position.y = 5
		$NoseUD.position.y = 3
		$EyeLeftUD.position.y = 2.5
		$EyeRigthUD.position.y = 2.5
		$EyeBrowLeft.position.y = 2
		$EyeBrowRigth.position.y = 2
		$FrontHairUD.position.y = 3
		$BackHair.position.y = 2.5
		$BeardUD.position.y = 7

# realize change of angry state
func update_angry():
	var mode = 0
	if angry:
		mode = 1
	# update sprites position
	$EyeBrowLeft/Hair2.position.y = mode
	$EyeBrowRigth/Hair2.position.y = mode

# realize change of smile state
func update_smile():
	var mod = 0
	if smile:
		mod = 1
	# update sprites frames
	$Lips/Lips1.frame_coords.y = mod
	$Lips/Lips2.frame_coords.y = mod
	# update sprites position
	$Lips/Lips2.position.y = -mod
# realize change of sitting state

func update_sitting():
	# update visibility of Laptop and Desk
	$Laptop.visible = sitting
	$Desk.visible = sitting
	$Badge.visible = sitting

# transform linear speed to exponential animation speed
func get_anim_speed(speed):
	var s = pow(1.5,speed-2)
	return s

# play animation of employee not working
func display_idle():
	$MainAnimationPlayer.stop()
	$SupportAnimationPlayer.stop()
	$MainAnimationPlayer.play("idle")

# play animation of coding
func display_issue_coding(speed:int,too_hard:bool):
	$MainAnimationPlayer.stop()
	$SupportAnimationPlayer.stop()
	if too_hard:
		$MainAnimationPlayer.play("coding_too_hard",-1,get_anim_speed(speed))
	else:
		$MainAnimationPlayer.play("coding_normal",-1,get_anim_speed(speed))

#play animation of testing 
func display_testing(speed:int):
	$MainAnimationPlayer.stop()
	$SupportAnimationPlayer.stop()
	$MainAnimationPlayer.play("testing",-1,get_anim_speed(speed))

# prepare sprite to extention view
func display_extended_view():
	$MainAnimationPlayer.stop()
	$SupportAnimationPlayer.stop()
	eye_pose = 0
	sitting = false
	up = true
	laptop_open = false
	bubble = false

var skin_color_key = "skin_color"
var hair_color_key = "hair_color"
var lips_color_key = "lips_color"
var eyeball_color_key = "eyeball_color"
var iris_color_key = "iris_color"
var clothes_color_key = "clothes_color"
var desk_color_key = "desk_color"
var laptop_color_key = "laptop_color"
var accessories_color_key = "accessories_color"

var nose_model_key = "nose_model"
var hair_front_model_key = "hair_front_model"
var hair_back_model_key = "hair_back_model"
var beard_model_key = "beard_model"
var body_model_key = "body_model"
var clothes_model_key = "clothes_model"
var detail_model_key = "detail_model"
var desk_model_key = "desk_model"
var laptop_model_key = "laptop_model"

func make_key(key:String,number:int):
	return key+"_"+str(number)

func __get_if_contain(dict:Dictionary,key:String,number:int=-1):
	if number >-1:
		key = make_key(key,number)
	return dict.get(key)

# load visualization from dictionary
# if key is not present in the dictionary value will be skiped
func configure_visuals(dict:Dictionary):
	# save config in case node is not in three
	if not is_inside_tree():
		config = dict.duplicate(true)
	var value = __get_if_contain(dict,skin_color_key,1)
	if value != null:
		skin_1 = Color.from_string(value,skin_1)
	value = __get_if_contain(dict,skin_color_key,2)
	if value != null:
		skin_2 = Color.from_string(value,skin_2)
	value = __get_if_contain(dict,skin_color_key,3)
	if value != null:
		skin_3 = Color.from_string(value,skin_3)
	
	value = __get_if_contain(dict,hair_color_key,1)
	if value != null:
		hair_1 = Color.from_string(value,hair_1)
	value = __get_if_contain(dict,hair_color_key,2)
	if value != null:
		hair_2 = Color.from_string(value,hair_2)
	
	value = __get_if_contain(dict,lips_color_key,1)
	if value != null:
		lips_1 = Color.from_string(value,lips_1)
	value = __get_if_contain(dict,lips_color_key,2)
	if value != null:
		lips_2 = Color.from_string(value,lips_2)
	
	value = __get_if_contain(dict,clothes_color_key,1)
	if value != null:
		clothes1 = Color.from_string(value,clothes1)
	value = __get_if_contain(dict,clothes_color_key,2)
	if value != null:
		clothes2 = Color.from_string(value,clothes2)
	value = __get_if_contain(dict,clothes_color_key,3)
	if value != null:
		clothes3 = Color.from_string(value,clothes3)
	
	value = __get_if_contain(dict,accessories_color_key,1)
	if value != null:
		accessories1 = Color.from_string(value,accessories1)
	value = __get_if_contain(dict,accessories_color_key,2)
	if value != null:
		accessories2 = Color.from_string(value,accessories2)
	value = __get_if_contain(dict,accessories_color_key,3)
	if value != null:
		accessories3 = Color.from_string(value,accessories3)
	
	value = __get_if_contain(dict,desk_color_key,1)
	if value != null:
		desk_1 = Color.from_string(value,desk_1)
	value = __get_if_contain(dict,desk_color_key,2)
	if value != null:
		desk_2 = Color.from_string(value,desk_2)
	value = __get_if_contain(dict,desk_color_key,3)
	if value != null:
		desk_3 = Color.from_string(value,desk_3)
		
	value = __get_if_contain(dict,laptop_color_key,1)
	if value != null:
		laptop_1 = Color.from_string(value,laptop_1)
	value = __get_if_contain(dict,laptop_color_key,2)
	if value != null:
		laptop_2 = Color.from_string(value,laptop_2)
		
	value = dict.get(eyeball_color_key)
	if value != null:
		eyeball = Color.from_string(value,eyeball)
	value = dict.get(iris_color_key)
	if value != null:
		iris = Color.from_string(value,iris)
	
	value = dict.get(nose_model_key)
	if value != null:
		nose = value
	
	value = dict.get(hair_front_model_key)
	if value != null:
		hair_front = value
	value = dict.get(hair_back_model_key)
	if value != null:
		hair_back = value
	value = dict.get(beard_model_key)
	if value != null:
		beard = value
	value = dict.get(body_model_key)
	if value != null:
		body = value
	value = dict.get(clothes_model_key)
	if value != null:
		clothes = value
	value = dict.get(detail_model_key)
	if value != null:
		detail = value
	value = dict.get(desk_model_key)
	if value != null:
		desk = value
	value = dict.get(laptop_model_key)
	if value != null:
		laptop = value
		
# configure visuals besed on given dictionary of presets
# key represents resource it is loaded from
# value number of the preset 
# if value is null or out of range preset is randomly selected
# dictionary can contain may key-value pairs
# if preset contains overlaping values 
# final values are selected in not determinstic way
func configure_from_presets(dict:Dictionary):
	var new_dict = Dictionary()
	randomize()
	
	for p in dict:
		var preset:Array = load(p).data
		var value = dict[p]
		if (not value is int) or value < 0 or value >=preset.size():
			value = randi_range(0,preset.size()-1)
		new_dict.merge(preset[value])
	configure_visuals(new_dict)
	
# save visualization to dictionary
# visualization can be loaded via configure_visuals()
func to_json():
	var dict = Dictionary()
	
	dict[make_key(skin_color_key,1)] = skin_1.to_html()
	dict[make_key(skin_color_key,2)] = skin_2.to_html()
	dict[make_key(skin_color_key,3)] = skin_3.to_html()
	
	dict[make_key(hair_color_key,1)] = hair_1.to_html()
	dict[make_key(hair_color_key,2)] = hair_2.to_html()
	
	dict[make_key(lips_color_key,1)] = lips_1.to_html()
	dict[make_key(lips_color_key,2)] = lips_2.to_html()
	
	dict[make_key(clothes_color_key,1)] = clothes1.to_html()
	dict[make_key(clothes_color_key,2)] = clothes2.to_html()
	dict[make_key(clothes_color_key,3)] = clothes3.to_html()
	print(accessories1)
	dict[make_key(accessories_color_key,1)] = accessories1.to_html()
	dict[make_key(accessories_color_key,2)] = accessories2.to_html()
	dict[make_key(accessories_color_key,3)] = accessories3.to_html()
	
	dict[make_key(desk_color_key,1)] = desk_1.to_html()
	dict[make_key(desk_color_key,2)] = desk_2.to_html()
	dict[make_key(desk_color_key,3)] = desk_3.to_html()
		
	dict[make_key(laptop_color_key,1)] = laptop_1.to_html()
	dict[make_key(laptop_color_key,2)] = laptop_2.to_html()
		
	dict[eyeball_color_key] = eyeball.to_html()
	dict[iris_color_key] = iris.to_html()
	
	dict[nose_model_key] = nose
	dict[hair_front_model_key] = hair_front
	dict[hair_back_model_key] = hair_back
	dict[beard_model_key] = beard
	dict[body_model_key] = body
	dict[clothes_model_key] = clothes
	dict[detail_model_key] = detail
	dict[desk_model_key] = desk
	dict[laptop_model_key] = laptop
	
	return dict
