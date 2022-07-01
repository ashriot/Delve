class_name EnemyPanel
extends BattleControl


onready var sprite := $Sprite
onready var life := $Life/Value
onready var life_percent := $Life/Percent
onready var armor := $Armor/Value
onready var mana := $Mana/Value
onready var traits := $Traits
onready var anim = $AnimationPlayer

var _enemy: Enemy

func setup(enemy_job: EnemyJob) -> void:
	_enemy = Enemy.new()
	_enemy.init(enemy_job)
	_battle.banner = "Lv. " + str(_enemy.level) + " " + _enemy.title
	sprite.texture = _enemy.texture
	traits.hide()
	update_data()


func update_data() -> void:
	life.bbcode_text = _battle.pad_str(_enemy.life, true)
	if _enemy.armor > 0:
		$Armor.show()
		armor.bbcode_text = _battle.pad_str(_enemy.armor, true)
	else: $Armor.hide()
	if _enemy.mana > 0:
		$Mana.show()
		mana.bbcode_text = _battle.pad_str(_enemy.mana, true)
	else: $Mana.hide()
