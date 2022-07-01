class_name EnemyJob
extends Resource

export var id: String
export var title: String
export (String, MULTILINE) var desc
export var life: int
export var stamina: int
export var armor: int
export var mana: int
export var gold: int
export var level: int
export var texture: Texture

export (Dictionary) var initial_actions
export (Array, Resource) var perks
