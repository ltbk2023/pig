extends Node
class_name Event

# tags represent element of Event 
# used to easily filter Event
enum EventTag{
	TASK_ASSIGNED, # task assigned to employee
	TASK_COMPLETED, # task completed by employee
	TASK_UNASSIGNED, # task unassigned from employee
	ISSUE, # event is about issue 
	TESTING, # event is about testing
	EMPLOYEE # event is about employee
	}


@export var tags:Array[EventTag]=[]
# information about event that isn't included in tags or extends it
@export var data:Dictionary={}
