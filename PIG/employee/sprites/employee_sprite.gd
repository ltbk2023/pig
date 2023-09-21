# This script works also in the editor. Be carefull!
# Changes in code will have effects only after saving scene
@tool
extends Node2D
# group of variables that modify visible state of employee
@export_group("State")
# control if employee look straight or down 
@export var up=true:
	set(u):
		up = u
		if is_inside_tree():
			update_up_down()
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
			for ch in $Laptop.get_children():
				ch.frame_coords.y = get_up_down_coord(y)
				
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
	
	cord=  get_up_down_coord(laptop)
	$Laptop/Laptop1.frame_coords.y = cord
	$Laptop/Laptop2.frame_coords.y = cord
	
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