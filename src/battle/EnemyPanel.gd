class_name EnemyPanel
extends BattleControl


onready var sprite := $Sprite
onready var life_txt := $Life/Value
onready var life_percent := $Life/Percent
onready var armor_txt := $Armor/Value
onready var mana_txt := $Mana/Value
onready var traits := $Traits
onready var anim = $AnimationPlayer

var _enemy: Enemy
var life_cur: int setget set_life
var life_max: int setget set_life_max
var armor_cur: int setget set_armor
var mana_cur: int setget set_mana


func setup(enemy_job: EnemyJob) -> void:
	traits.hide()
	_enemy = Enemy.new()
	_enemy.init(enemy_job)
	_battle.banner = "Lv. " + str(_enemy.level) + " " + _enemy.title
	sprite.texture = _enemy.texture
	anim.play("Idle")
	self.life_cur = _enemy.life
	self.life_max = _enemy.life
	self.armor_cur = _enemy.armor
	self.mana_cur = _enemy.mana


func set_life(value: int) -> void:
	value = int(clamp(value, 0, life_max))
	life_cur = value
	life_txt.bbcode_text = _battle.pad_str(_enemy.life)
	life_percent.value = value


func set_life_max(value: int) -> void:
	life_max = value
	life_percent.max_value = life_max


func set_armor(value: int) -> void:
	if _enemy.armor > 0:
		$Armor.show()
		armor_txt.bbcode_text = _battle.pad_str(_enemy.armor)
	else: $Armor.hide()


func set_mana(value: int) -> void:
	if _enemy.mana > 0:
		$Mana.show()
		mana_txt.bbcode_text = _battle.pad_str(_enemy.mana)
	else: $Mana.hide()


func is_alive() -> bool:
	return _enemy.life > 0


func _on_Btn_pressed():
	Ac.select()

