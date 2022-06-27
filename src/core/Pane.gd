extends Control

signal done

onready var anim = $AnimationPlayer

func show() -> void:
	.show()
	anim.play("Show")
	yield(anim, "animation_finished")
	emit_signal("done")
	

func hide() -> void:
	anim.play("Hide")
	yield(anim, "animation_finished")
	.hide()
	emit_signal("done")


func hide_instantly() -> void:
	.hide()
