class_name Battle
extends Window

const _ActionBtn:= preload("res://src/battle/ActionBtn.tscn")

const HAND_SIZE = 5


onready var enemy_panel := $EnemyPanel
onready var player_panel := $PlayerPanel

onready var draw_pile := $Draw/Pile
onready var draw_label := $Draw/Label
onready var discard_pile := $Discard/Pile
onready var discard_label := $Discard/Label
onready var discard_btn := $Discard/Button
onready var dropped_pile := $Dropped
onready var dropped_label := $Dropped/Label
onready var hand := $Hand

onready var state_machine := $StateMachine as StateMachine
onready var next_turn_state := $StateMachine/NextTurnState as State

var player: Player

var _game: Game
var _deck: Deck
var _hand_count: int
var _draw_pile_count: int setget set_draw_pile_count
var _discard_pile_count: int setget set_discard_pile_count
var _dropped_pile_count: int setget set_dropped_pile_count
var _player_turn: bool


func init(game: Game) -> void:
	_game = game
	hide_instantly()


func setup(enemy_job: EnemyJob) -> void:
	enemy_panel.init(self)
	enemy_panel.setup(enemy_job)
	_deck = _game.save.deck
	player = _game.save.player
	player_panel.init(self)
	_hand_count = 0
	$Discard/ColorRect.hide()
	self._draw_pile_count = 0
	self._discard_pile_count = 0
	self._dropped_pile_count = 0
	create_draw_pile()
	yield(get_tree().create_timer(0.5), "timeout")
	call_deferred("shuffle_draw_pile")
	call_deferred("fill_hand")
	state_machine.change_state(next_turn_state)


func create_draw_pile() -> void:
	for key in _game.save.deck.actions:
		for _i in range(_game.save.deck.actions[key]):
			var action := Db.get_action_by_id(key)
			var action_btn := _ActionBtn.instance() as ActionBtn
			action_btn.init(self)
			action_btn.hide()
			action_btn.call_deferred("setup", action)
			draw_pile.add_child(action_btn)
			self._draw_pile_count += 1


func shuffle_draw_pile() -> void:
#	self.deck_count = deck.get_child_count()
	var shuffler := range(0, _draw_pile_count)
	shuffler.shuffle()
	if _draw_pile_count < 2: return
	for i in shuffler:
		var child := draw_pile.get_child(i)
		draw_pile.move_child(child, 0)


func fill_hand() -> void:
	while _hand_count < HAND_SIZE:
		var btn := draw_pile.get_child(0) as ActionBtn
		draw_pile.remove_child(btn)
		self._draw_pile_count -= 1
		set_hand_pos(btn)
		btn.show()
		yield(get_tree().create_timer(0.08), "timeout")


func discard_hand() -> void:
	while _hand_count > 0:
		pass


func start_turn() -> void:
	pass


func end_turn() -> void:
	pass


func play_action(btn: ActionBtn) -> void:
	self._discard_pile_count += 1
	if btn.cost > 0 and btn.cost_type == Enums.ResourceType.STAMINA:
		player_panel.stamina_cur -= btn.cost


func discard_action(btn: ActionBtn) -> void:
	remove_hand_pos(btn)
	discard_pile.add_child(btn)
	btn.set_position(Vector2.ZERO)

func player_lost() -> bool:
	return player.life < 1


func player_won() -> bool:
	return enemy_panel._enemy.life < 1


func set_hand_pos(btn: ActionBtn) -> void:
	for pos in hand.get_children():
		if pos.get_child_count() == 0:
			print("Adding ", btn, " -> ", pos.name)
			_hand_count += 1
			pos.add_child(btn)
			btn.set_position(Vector2.ZERO)
			return


func remove_hand_pos(btn: ActionBtn) -> void:
	for pos in hand.get_children():
		if pos.get_child_count() > 0:
			if pos.get_child(0) == btn:
				print("Removing ", btn, " -> ", pos.name)
				_hand_count -= 1
				pos.remove_child(btn)
				btn.set_position(Vector2.ZERO)
				return


func pad_str(value: int) -> String:
	var string := str(value)
	var zeros := "0".repeat(3 - string.length())

	var res := "[color=#33ffffff]" + zeros + \
		"[/color][color=#ffffffff]" + string + "[/color]"
	return res


func set_draw_pile_count(value: int) -> void:
	_draw_pile_count = value
	draw_label.text = str(_draw_pile_count)


func set_discard_pile_count(value: int) -> void:
	_discard_pile_count = value
	discard_label.text = str(_discard_pile_count)


func set_dropped_pile_count(value: int) -> void:
	_dropped_pile_count = value
	if _dropped_pile_count > 0:
		dropped_pile.show()
		dropped_label.text = str(_dropped_pile_count)
	else:
		dropped_pile.hide()


func show(_move := false) -> void:
	.show_instantly()


func _on_EndTurn_pressed():
	Ac.select()
	end_turn()


func _on_Discard_Button_pressed():
	Ac.click()
	discard_pile.show()
	$Discard/ColorRect.show()
