extends Node
class_name EventManager

signal receive_event(event)

#send event to all nodes in event_listners group
func send(event:Event):
	get_tree().call_group("event_listners","receive",event)

#receive event and forward it via receive_event signal
func receive(event:Event):
	emit_signal("receive_event",event)

