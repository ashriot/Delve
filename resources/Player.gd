class_name Player
extends Resource

export var title: String
export var job_id: String
export var level: int
export var life: int
export var life_max: int
export var stamina: int
export var stamina_max: int
export var armor: int
export var armor_initial: int
export var mana: int
export var mana_initial: int
export var gold: int

export var is_alive: bool setget , get_is_alive


func init(job: Job) -> void:
	title = job.title
	job_id = job.id
	level = job.level
	life_max = job.life
	life = life_max
	stamina_max = job.stamina
	armor_initial = job.armor
	mana_initial = job.mana


func get_is_alive() -> bool:
	return life > 0
