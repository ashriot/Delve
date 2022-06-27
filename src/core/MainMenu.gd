extends Window

onready var new_game := $NewGame
onready var title := $Title
onready var profile_pane := $ProfilePane/Pane
onready var name_edit := $ProfilePane/Pane/NameEdit
onready var profile_btn := $ProfileBtn

var _game: Game

func init(game: Game) -> void:
	_game = game
	new_game.init(_game)
	profile_btn.text = _game.profile_name
	new_game.hide_instantly()
	profile_pane.hide_instantly()
	$ProfilePane.show()
	title.show()

func _on_ContinueBtn_pressed():
	Ac.confirm()
	
func _on_NewBtn_pressed():
	Ac.click()
	_game.show_window(new_game, true)

func _on_Back_pressed():
	Ac.back()
	if _game._active_windows:
		var window = _game.active_window
		if window == profile_pane:
			_game.profile_name = profile_btn.text
			_game.save_game()
		_game.hide_window()
		yield(window, "done")
	elif not title.visible:
		$Title/AnimationPlayer.play()
		title.show()
		tween.interpolate_property(title, "modulate",
			Color.transparent,
			Color.white,
			0.2 * Gm.spd, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		tween.start()
		yield(tween, "tween_all_completed")
		$Title/Start.disabled = false

func _on_Start_pressed():
	Ac.select()
	$Title/Start.disabled = true
	tween.interpolate_property(title, "modulate",
		Color.white,
		Color.transparent,
		0.2 * Gm.spd, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
	yield(tween, "tween_all_completed")
	title.hide()
	$Title/AnimationPlayer.stop()

func _on_ProfileBtn_pressed():
	Ac.click()
	name_edit.text = profile_btn.text
	_game._active_windows.append(profile_pane)
	profile_pane.show()
	name_edit.grab_focus()
	name_edit.caret_position = name_edit.text.length()


func _on_NameEdit_text_changed(new_text):
	if name_edit.text.length() < 2:
		$Back.disabled = true
	else:
		$Back.disabled = false
	profile_btn.text = name_edit.text
