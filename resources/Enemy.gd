class_name Enemy
extends Resource


export var id: String
export var title: String
export(String, MULTILINE) var desc
export var level: int
export var life: int
export var stamina: int
export var armor: int
export var mana: int
export var bonus_gold: int
export var texture: Texture
export (Dictionary) var actions

export var is_alive: bool setget , get_is_alive


func init(enemy_job: EnemyJob) -> void:
	id = enemy_job.id
	title = enemy_job.title
	desc = enemy_job.desc
	level = enemy_job.level
	life = enemy_job.life
	stamina = enemy_job.stamina
	armor = enemy_job.armor
	mana = enemy_job.mana
	texture = enemy_job.texture


func get_is_alive() -> bool:
	return life > 0
