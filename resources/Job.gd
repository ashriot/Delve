extends Resource
class_name Job

export var id: String
export var title: String
export (String, MULTILINE) var desc
export var sprite_id: int
export var life: int
export var stamina: int
export var armor: int
export var mana: int
export var gold: int
export var level: int
export var xp: int

export var unlocked := false

export (Dictionary) var initial_actions
export (Array, Resource) var perks
export (Array, Resource) var gears
export (Array, Resource) var specs
