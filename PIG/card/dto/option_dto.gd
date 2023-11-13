extends Resource
# stores information to create Option
class_name OptionDTO
var text
var effects:Dictionary

var mod_stat = "modify_stat"

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

func create_and_fill_copy(format,reference) -> OptionDTO:
	var op = OptionDTO.new()
	op.text = text.format(format,"_")
	for type in effects:
		var list = []
		if type == mod_stat:
			for e in effects[type]:
				list.append(e.create_and_fill_copy(reference))
		op.effects[type]=list
	return op
