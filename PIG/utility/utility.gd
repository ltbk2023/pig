extends Object
class_name Utility

static func delete_children(node: Node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()
