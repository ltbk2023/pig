extends Resource
# stores information to create ModifyClientSatisfactionDTO
class_name ModifyClientSatisfactionDTO

var value: int

func load(value):
	self.value = value

func to_json():
	return value

func create_and_fill_copy()->ModifyClientSatisfactionDTO:
	var dto = ModifyClientSatisfactionDTO.new()
	dto.value = value
	return dto
