extends Resource
class_name Deck

export var actions := {}


func add_action(id: String, qty := 1) -> void:
	if id in actions:
		actions[id] += qty
	else:
		actions[id] = qty
	emit_changed()


func get_quantity(id: String) -> int:
	if not id in actions:
		printerr("Trying to get the qty of item %s but the deck doesn't have it." % id)
		return -1

	return actions[id]


func remove_item(id: String, qty := 1) -> void:
	if not id in actions:
		printerr("Trying to remove item %s but the deck doesn't have it." % id)
		return

	actions[id] -= qty
	if actions[id] <= 0:
		# warning-ignore:return_value_discarded
		actions.erase(id)
	emit_changed()
