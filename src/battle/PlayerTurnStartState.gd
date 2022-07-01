class_name PlayerTurnStartState
extends BattleState


func start(_data: Dictionary) -> void:
	call_deferred("_start_turn")


func _start_turn() -> void:
	if _battle._player_turn:
		assert(_battle.player.is_alive)


func _next_state(state: State) -> void:
	emit_signal("state_change_requested", state)
