class_name ActorStartTurnState
extends BattleState

export var player_turn_state_path: NodePath
export var enemy_turn_state_path: NodePath

onready var _player_turn_state := get_node(player_turn_state_path) as State
#onready var _enemy_turn_state := get_node(enemy_turn_state_path) as State


func start(_data: Dictionary) -> void:
	call_deferred("_start_turn")


func _start_turn() -> void:
	if _battle._player_turn:
		assert(_battle.player.is_alive)
		_next_state(_player_turn_state)
	else:
		assert(_battle.enemy.is_alive)
#		_next_state(_enemy_turn_state)


func _next_state(state: State) -> void:
	emit_signal("state_change_requested", state)
