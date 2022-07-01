extends BattleControl
class_name ActionBtn

onready var btn := $Button
onready var cost := $Button/Cost
onready var cost_sprite := $Button/Cost/Icon/Sprite
onready var stam_cost := $Button/StamCost
onready var stam_img := $Button/StamCost/Image
onready var dmg := $Button/Dmg
onready var dmg_sprite := $Button/Dmg/Icon/Sprite
onready var emphasis := $Button/Emphasis

onready var timer = $Timer
onready var anim = $Button/AnimationPlayer

var _action: Action
var _played: bool
var _holding: bool


func setup(action: Action) -> void:
	_action = action
	update_data()


func show() -> void:
	.show()
	btn.modulate.a = 0
	Ac.play_sfx("pop")
	anim.play("Draw")
	yield(anim, "animation_finished")
	_played = false
	update_data()


func update_data() -> void:
	emphasis.hide()
	if _action.cost == 0:
		stam_cost.hide()
		cost.hide()
	elif _action.cost_type == Enums.ResourceType.STAMINA:
		stam_cost.show()
		stam_img.rect_size.x = _action.cost * 6
	else:
		cost.show()
		cost.text = str(_action.cost)
		cost_sprite.frame = _action.cost_type

	btn.text = _action.title
	if _action.damage > 0:
		dmg.text = str(_action.damage)
		dmg_sprite.frame = _action.damage_type + 9
	elif _action.healing > 0:
		dmg.text = "+" + str(_action.healing)
		dmg_sprite.frame = _action.healing_type

	dmg.rect_position.x = 91 - dmg.rect_size.x


func play() -> void:
	anim.play("Play")
	_battle.play_action(self)


func _on_Button_up() -> void:
	update_data()
	timer.stop()
	if _holding:
		_holding = false
		modulate.a = 1.0
#		emit_signal("hide_card")
		return
	if _played: return
	play()


func _on_Button_down():
	modulate.a = 0.66
	timer.start(.25)


func _on_Timer_timeout() -> void:
	timer.stop()
	_holding = true
