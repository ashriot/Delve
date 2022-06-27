extends Resource
class_name Action

export var id: String
export var title: String
export(String, MULTILINE) var desc setget, get_desc
export var rank := 1
export(Enums.ActionType) var action_type := Enums.ActionType.WEAPON
export(Enums.SubType) var sub_type := Enums.SubType.NONE
export(Enums.TargetType) var target_type := Enums.TargetType.OPPONENT
export(Enums.ResourceType) var cost_type := Enums.ResourceType.STAMINA
export var cost := 0
export(Enums.DamageType) var damage_type:= Enums.DamageType.MARTIAL
export(Enums.ResourceType) var damage_vs:= Enums.ResourceType.LIFE
export var damage := 0
export var hits := 1
export var healing := 0
export var lifesteal := 0.0
export var crit_chance := 0.0
export var impact := 0
export var penetrate := false
export var blindside := false
export var undodgeable := false
export var drop := false
export var fade := false
export var consume := false
export var draw_qty := 0
export var draw_chance := 1.0
export(Enums.ActionType) var draw_type := Enums.ActionType.ANY
export var discard_random_qty := 0
export var discard_qty := 0
export var fx: PackedScene
export(Array, Array) var gain_buffs
export(Array, Array) var gain_debuffs
export(Array, Array) var inflict_debuffs
export(Array, Array) var inflict_buffs

func get_desc() -> Array:
	var dmg = str(damage) + ("x" + str(hits) if hits > 1 else "")
	var text = desc.replace("{dmg}", dmg)
	var dmg2 = str(damage * 2) + ("x" + str(hits) if hits > 1 else "")
	var dmg3 = str(damage * 3) + ("x" + str(hits) if hits > 1 else "")
	text = text.replace("{dx2}", dmg2)
	text = text.replace("{dx3}", dmg3)
	text = text.replace("{draw}", str(draw_qty))
	if crit_chance > 0:
		text += " " + str(crit_chance* 100) + "% Crit chance."
	if impact > 0:
		text += " Impact x" + str(impact) + "."
	if penetrate:
		text += " Penetrate."
	if drop:
		text += " Drop."
	if fade:
		text += " Fade."
	if consume:
		text += " Consume."
	var type = (Enums.ActionType.keys()[action_type] as String).capitalize()
	return [type, text]
