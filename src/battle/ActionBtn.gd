extends Button
class_name ActionBtn

onready var cost := $Cost
onready var ap_cost := $ApCost
onready var damage := $Dmg
onready var damage_sprite := $Dmg/Icon/Sprite

func init() -> void:
	pass

func setup(action: Action) -> void:
	pass
