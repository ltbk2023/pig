@tool
extends Node2D

var json:Array = []

# path to preset with vanila look
var reset_path= "res://employee/editor/reset.ep.json"

@export var sitting =true:
	set(s):
		sitting = s
		for child in get_children():
			child.sitting = s
@export var up =true:
	set(s):
		up = s
		for child in get_children():
			child.up = s
@export var laptop_open =true:
	set(s):
		laptop_open = s
		for child in get_children():
			child.laptop_open = s

# path to file with presets
# path can't be reset_path
@export_file("*.json","*.ep.json") var presets="":
	set(p):
		if p != reset_path:
			presets = p
			
# exported values below works as "buttons" in inspector
# when value is clicked they execute code from 

# load or reload presets from variable
@export_group("Reload Button")
@export var reload = false:
	set(r):
		if load_preset(presets):
			print("RELOADED")
		else:
			print("INVALID PRESET")
# load presets from reset_path
@export_group("Reset Button")
@export var reset= false:
	set(r):
		if load_preset(reset_path):
			print("RESETED")
		else:
			print("INVALID PRESET")

func load_preset(path:String):
	var success = false
	var data = Utility.load_from_file(path)
	var json = []
	if data is Array:
		json = data
		success = true
	var i = 0
	print(json.size()," ",get_children().size())
	for child in get_children():
		if i <json.size():
			child.visible = true
			child.configure_visuals(json[i])
		else:
			child.visible = false
		i+=1
	return success
# save visible $Sprite's to file from presets variable overwriting existing file
# saving is done in child order
# invisible are skipped. they not end saving process
@export_group("Save Button")
@export var save = false:
	set(add):
		var file = FileAccess.open(presets,FileAccess.WRITE)
		json = to_json()
		
		for i in json:
			print("number keys to save ",i.size())
		
		file.store_string(JSON.stringify(json,"\t"))
		
		file.close()
		print("SAVED")
# declare with key should be saved
# every preset will have all of them if some are not necessary they can be remove in external editior
@export_group("Keys to Save")
@export_subgroup("Skin")
@export var skin_1=false
@export var skin_2=false
@export var skin_3=false

@export_subgroup("Hair")
@export var hair_1=false
@export var hair_2=false

@export_subgroup("Lips")
@export var lips_1=false
@export var lips_2=false

@export_subgroup("Eyes")
@export var eyeball=false
@export var iris=false

@export_subgroup("Clothes")
@export var clothes1 = false
@export var clothes2 = false
@export var clothes3 = false


@export_subgroup("Accessories")
@export var accessories1 = false
@export var accessories2 = false
@export var accessories3 = false


@export_subgroup("Desk")
@export var desk_1=false
@export var desk_2=false
@export var desk_3=false

@export_subgroup("Laptop")
@export var laptop_1=false
@export var laptop_2=false

@export_subgroup("Model")
@export var nose=false
@export var hair_front=false
@export var hair_back=false
@export var beard=false
@export var body=false
@export var clothes=false
@export var detail=false
@export var desk=false
@export var laptop=false

func to_json():
	var list = []
	for child in get_children():
		if not child.visible:
			continue
		var dict:Dictionary = child.to_json()
		if not skin_1:
			dict.erase(child.make_key(child.skin_color_key,1))
		if not skin_2:
			dict.erase(child.make_key(child.skin_color_key,2))
		if not skin_3:
			dict.erase(child.make_key(child.skin_color_key,3))
		
		if not hair_1:
			dict.erase(child.make_key(child.hair_color_key,1))
		if not hair_2:
			dict.erase(child.make_key(child.hair_color_key,2))
		
		if not lips_1:
			dict.erase(child.make_key(child.lips_color_key,1))
		if not lips_2:
			dict.erase(child.make_key(child.lips_color_key,2))
		
		if not clothes1:
			dict.erase(child.make_key(child.clothes_color_key,1))
		if not clothes2:
			dict.erase(child.make_key(child.clothes_color_key,2))
		if not clothes3:
			dict.erase(child.make_key(child.clothes_color_key,3))
		
		if not accessories1:
			dict.erase(child.make_key(child.accessories_color_key,1))
		if not accessories2:
			dict.erase(child.make_key(child.accessories_color_key,2))
		if not accessories3:
			dict.erase(child.make_key(child.accessories_color_key,3))
		
		if not desk_1:
			dict.erase(child.make_key(child.desk_color_key,1))
		if not desk_2:
			dict.erase(child.make_key(child.desk_color_key,2))
		if not desk_3:
			dict.erase(child.make_key(child.desk_color_key,3))
		
		if not laptop_1:
			dict.erase(child.make_key(child.laptop_color_key,1))
		if not laptop_2:
			dict.erase(child.make_key(child.laptop_color_key,2))
		
		if not eyeball:
			dict.erase(child.eyeball_color_key)
		if not iris:
			dict.erase(child.iris_color_key)
			
		if not nose:
			dict.erase(child.nose_model_key)
		if not hair_front:
			dict.erase(child.hair_front_model_key)
		if not hair_back:
			dict.erase(child.hair_back_model_key)
		if not beard:
			dict.erase(child.beard_model_key)
		if not body:
			dict.erase(child.body_model_key)
		if not clothes:
			dict.erase(child.clothes_model_key)
		if not detail:
			dict.erase(child.detail_model_key)
		if not desk:
			dict.erase(child.desk_model_key)
		if not laptop:
			dict.erase(child.laptop_model_key)
		list.append(dict)
	return list 

