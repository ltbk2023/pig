extends Resource
# stores information to create Card
class_name CardDTO

var title:String
var employee_number:int
var employee_filter
var text:String
var options:Array[OptionDTO]

func load(dict:Dictionary):
	title = dict["title"]
	employee_number = dict["employee_number"]
	if dict.has("employee_filter") and dict["employee_filter"] != null:
		employee_filter = dict["employee_filter"]
	else:
		employee_filter = []
		for i in range(employee_number):
			employee_filter.append([])
	text = dict["text"]
	options = []
	for o in dict["options"]:
		var op = OptionDTO.new()
		op.load(o)
		options.append(op)

func to_json():
	var op = []
	for o in options:
		op.append(o.to_json())
	
	return {
		"title":title,
		"employee_number":employee_number,
		"employee_filter":employee_filter if employee_filter != null else [],
		"text":text,
		"option":op
	}

func fill_card(card:StoryCard,format,reference):
	card.title = title.format(format,"_")
	card.story_text = text.format(format,"_")
	card.options = []
	for opt in options:
		card.options.append(opt.create_and_fill_copy(format,reference))
	
	
	
