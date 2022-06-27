extends Node
class_name Game

const DEFAULT_SAVE := preload("res://resources/defaults/default_save.tres")
const FIGHTER := preload("res://resources/jobs/fighter.tres")
const SORCERER := preload("res://resources/jobs/sorcerer.tres")
const THIEF := preload("res://resources/jobs/thief.tres")

signal fade_done
signal done_loading

onready var battle := $GUI/Battle
onready var main_menu := $GUI/MainMenu
onready var overlay := $GUI/Overlay
onready var fader := $GUI/Overlay/Fader

var active_window: Window setget , get_active_window
var save_data: SaveGame setget, get_save
var profile_name: String setget set_profile_name, get_profile_name

var _save: SaveGame
var _cur_scene: Control
var _active_windows: Array
var _player: Player

func _ready() -> void:
	_create_or_load_save()
	yield(self, "done_loading")
	overlay.show()
	main_menu.init(self)
	_cur_scene = main_menu
	fade_in()
	if _save.run:
		print("Deck contents:")
		for action in _save.run.deck.actions.keys():
			print(action, " x", _save.run.deck.actions[action])

func _create_or_load_save() -> void:
	if SaveGame.save_exists():
		_save = SaveGame.load_savegame() as SaveGame
	else:
		_save = SaveGame.new()
		create_new_data()

		_save.write_savegame()
		
	call_deferred("emit_signal", "done_loading")

func create_new_data() -> void:
	_save.profile_name = "Hero"
	
	var fighter = JobData.new()
	fighter.id = FIGHTER.id
	fighter.level = 1
	for perk in FIGHTER.perks:
		fighter.perk_data[perk.id] = 0
	_save.job_data[fighter.id] = fighter
	
	var sorcerer = JobData.new()
	sorcerer.id = SORCERER.id
	sorcerer.level = 1
	for perk in SORCERER.perks:
		sorcerer.perk_data[perk.id] = 0
	_save.job_data[sorcerer.id] = sorcerer
	
	var thief = JobData.new()
	thief.id = THIEF.id
	thief.level = 1
	for perk in THIEF.perks:
		thief.perk_data[perk.id] = 0
	_save.job_data[thief.id] = thief

func save_game() -> void:
	print("Saving the game.")
	_save.write_savegame()
	
func change_scene(scene: Control) -> void:
	fade_out()
	yield(fader, "animation_finished")
	_cur_scene.hide()
	_cur_scene = scene
	for window in _active_windows:
		window.hide()
	_active_windows.clear()
	scene.show()
	fade_in()

func show_window(window: Window, flash := false) -> void:
	_active_windows.append(window)
	window.show(flash)

func hide_window() -> void:
	var window = _active_windows.pop_back()
	window.hide()

func fade_in() -> void:
	overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	fader.play("FadeIn")
	yield(fader, "animation_finished")
	overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
func fade_out() -> void:
	overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	fader.play("FadeOut")
	yield(fader, "animation_finished")
	overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE

func get_active_window() -> Window:
	return _active_windows.back()

func get_save() -> SaveGame:
	return _save


func set_profile_name(text: String) -> void:
	_save.profile_name = text
	
func get_profile_name() -> String:
	if _save: return _save.profile_name
	return ""

func _on_SettingsBtn_pressed():
	$GUI/SettingsMenu.show()
