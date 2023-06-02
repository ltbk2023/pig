extends Node2D
class_name Employee

@export_category("Skills")
@export_range(1,3) var quality = 2 
@export_range(1,3) var speed = 2 
@export_range(1,3) var testing = 2 

@export_category("Morale")
@export var morale = 0


var __base_quality
var __base_speed
var __base_testing
var __base_morale

# Called when the node enters the scene tree for the first time.
func _ready():
	__base_quality = quality
	__base_speed = speed
	__base_testing = testing
	
	__base_morale = morale
	
	update_summary()

func update_summary():
	$Summary.text = name + "\nQ "+ str(quality) + " / S " + str(speed) + " / T " + str(testing) + "\nM "+str(morale)
	
