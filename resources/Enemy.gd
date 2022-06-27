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
