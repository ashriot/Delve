class_name EnemyPanel
extends BattleControl

onready var sprite = $Enemy
onready var anim = $AnimationPlayer


func init(battle) -> void:
	.init(battle)
	setup()

func setup() -> void:
	sprite.texture = _battle.enemy.texture
	anim.play("Idle")
