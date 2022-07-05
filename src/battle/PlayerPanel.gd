class_name PlayerPanel
extends BattleControl

onready var life_txt := $Life/Value
onready var life_percent := $Life/Percent
onready var armor_txt := $Armor/Icon/Value
onready var mana_txt := $Mana/Icon/Value
onready var anim = $AnimationPlayer
onready var stamina_gauge := $Stamina/StaminaCur
onready var stamina_gauge_max := $Stamina/StaminaMax

var _player: Player
var life_cur: int setget set_life
var life_max: int setget set_life_max
var armor_cur: int setget set_armor
var mana_cur: int setget set_mana
var stamina_cur: int setget set_stamina
var stamina_max: int setget set_stamina_max

func init(battle) -> void:
	.init(battle)
	_player = battle.player
	self.life_cur = _player.life
	self.life_max = _player.life_max
	self.armor_cur = _player.armor_initial
	self.mana_cur = _player.mana_initial
	self.stamina_cur = _player.stamina
	self.stamina_max = _player.stamina_max


func set_life(value: int) -> void:
	_player.life = value
	var text = _battle.pad_str(_player.life) + "/" + \
		_battle.pad_str(_player.life_max)
	life_txt.bbcode_text = text


func set_life_max(value: int) -> void:
	life_max = value
	life_percent.max_value = life_max


func set_armor(value: int) -> void:
	armor_cur = value
	_player.armor = armor_cur
	armor_txt.bbcode_text = _battle.pad_str(armor_cur)


func set_mana(value: int) -> void:
	mana_cur = value
	_player.armor = mana_cur
	mana_txt.bbcode_text = _battle.pad_str(mana_cur)


func set_stamina(value: int) -> void:
	stamina_cur = value
	_player.stamina = stamina_cur
	stamina_gauge.rect_size.x = stamina_cur * 6


func set_stamina_max(value: int) -> void:
	stamina_max = value
	stamina_gauge_max.rect_size.x = stamina_max * 6


func is_alive() -> bool:
	return _player.life > 0
