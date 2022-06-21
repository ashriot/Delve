extends Node
class_name Game

onready var battle := $GUI/Battle
onready var banner_label := $GUI/Banner/Label
onready var title := $GUI/Title

func _ready() -> void:
	title.show()
