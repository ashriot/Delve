extends Control
class_name Window

signal done

export var banner: String setget set_banner

onready var tween = $Tween

func _ready() -> void:
	$Bg/Banner/Label.modulate.a = 1
	$Bg/Banner/Label.text = banner

func show(flash := false) -> void:
	self.modulate.a = 0
	.show()
	$Bg/Banner/Label.modulate.a = 1
	tween.interpolate_property(self, "modulate",
		Color.transparent,
		Color.white,
		0.2 * Gm.spd, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
	yield(tween, "tween_all_completed")
	if flash: $AnimationPlayer.play("Flash")
	emit_signal("done")

func hide() -> void:
	tween.interpolate_property(self, "modulate",
		Color.white,
		Color.transparent,
		0.2 * Gm.spd, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()
	yield(tween, "tween_all_completed")
	.hide()
	$AnimationPlayer.stop()
	emit_signal("done")

func show_instantly() -> void:
	modulate = Color.white
	.show()

func hide_instantly() -> void:
	.hide()

func set_banner(value: String) -> void:
	banner = value
	$Bg/Banner/Label.text = banner
