extends Resource
# stores information to create Option
class_name OptionDTO
var text
var effects:Dictionary

var mod_stat = "modify_stat"
var mod_client = "modify_client_satisfaction"

func load(dict:Dictionary):
	text = dict["text"]
	effects = dict["effects"]
	
	if effects.has(mod_stat):
		var list = []
		for e in effects[mod_stat]:
			var ms = ModifyStatDTO.new()
			ms.load(e)
			list.append(ms)
		effects[mod_stat]=list
	if effects.has(mod_client):
		var mcs = ModifyClientSatisfactionDTO.new()
		mcs.load(effects[mod_client])
		effects[mod_client]=mcs

func to_json():
	var eff= {}
	
	for e in effects:
		if effects[e] is Array:
			eff[e] = []
			for e1 in effects[e]:
				eff[e].append(e1.to_json())
		else:
			eff[e] = effects[e].to_json()
	
	return {
		"text":text,
		"effects":eff
	}
func create_and_fill_copy(format,reference) -> OptionDTO:
	var op = OptionDTO.new()
	op.text = text.format(format,"_")
	for type in effects:
		var list = []
		if type == mod_stat:
			for e in effects[type]:
				list.append(e.create_and_fill_copy(reference))
		op.effects[type]=list
		if type == mod_client:
			op.effects[type] = effects[type].create_and_fill_copy()
	return op
