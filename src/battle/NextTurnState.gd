class_name NextTurnState
extends BattleState

export var actor_start_turn_state_path: NodePath

onready var _actor_start_turn_state := get_node(actor_start_turn_state_path) \
		as State

export var victory_state_path: NodePath
export var game_over_state_path: NodePath

onready var _victory_state := get_node(victory_state_path) as State
onready var _game_over_state := get_node(game_over_state_path) as State

func start(_data: Dictionary) -> void:
	call_deferred("_start_turn")


func _start_turn() -> void:
	if _battle.player_lost():
		emit_signal("state_change_requested", _game_over_state)
	elif _battle.player_won():
		emit_signal("state_change_requested", _victory_state)
	else:
		_start_next_turn()


func _start_next_turn() -> void:
	_battle.start_turn()
	emit_signal("state_change_requested", _actor_start_turn_state)
