extends Control
class_name Window

signal done

export var banner: String setget set_banner
export var translucent := false

onready var tween = $Tween

func _ready() -> void:
	$Banner/Label.modulate.a = 1
	$Banner/Label.text = banner
	if translucent:
		$Bg.self_modulate.a = 0.9

func show(flash := false) -> void:
	self.modulate.a = 0
	.show()
	$Banner/Label.modulate.a = 1
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
	$Banner/Label.text = banner
