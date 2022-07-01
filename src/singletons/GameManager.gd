extends Node

const VERSION = "0.1"

var profile_id: String
var path: String
var file_path: String
var save_data: Resource

var profile: Resource

var loading: = false
var spd: = 1.0 setget, get_spd

var game: Game

var ui_color: Color
var gold_color = Color("#ffbe22")
var gray_color = Color("#606060")

func init() -> void:
	var profile_path = "user://profile"
	var dir = Directory.new();
	for i in range(3):
		var full_path = profile_path + str(i + 1)
		if dir.file_exists(full_path.plus_file("data.tres")):
			if i == 0: profile = load(full_path.plus_file("data.tres")) as Resource
		else:
			dir.make_dir_recursive(full_path)

func initialize_game_data(_game):
	game = _game
	ui_color = Enums.default_color
	profile_id = str(game.profile_id)
	path = "user://profile" + profile_id;
	file_path = path.plus_file("data.tres")
	spd = game.spd
	var dir = Directory.new();
	if dir.file_exists(file_path):
		save_data = load(file_path) as Resource
		if save_data.game_version != VERSION:
			dir.remove(file_path)
			loading = false
		else:
			loading = true
	if !loading:
		dir.make_dir_recursive(path)
		save_data = Resource.new()
		save_data.game_version = VERSION
		loading = false

func actions_to_dict(actions: Dictionary) -> Dictionary:
	var dict = {}
	for i in range(10):
		if not actions[i]: dict[i] = null
		else:
			var action = actions[i] as Action
			var action_name = action.name
			dict[i] = [action_name, action.uses]
	return dict

func dict_to_actions(dict: Dictionary) -> Dictionary:
	var actions = {}
	for i in range(10):
		if not dict[i]: actions[i] = null
		else:
			var action = Db.get_action(dict[i][0]) as Action
			assert(action, dict[i][0] + " is missing!")
			actions[i] = action
			action.uses = dict[i][1]
	return actions

func perks_to_dict(perks: Dictionary) -> Dictionary:
	var dict = {}
	for i in range(5):
		if not perks[i]: dict[i] = null
		else:
			dict[i] = [perks[i].name, perks[i].rank]
	return dict

func equips_to_dict(equips: Dictionary) -> Dictionary:
	var dict = {}
	for i in range(5):
		if equips[i] == null: dict[i] = null
		else:
			dict[i] = equips[i].name
	return dict

func dict_to_perks(dict: Dictionary) -> Dictionary:
	var perks = {}
	for i in range(5):
			if not dict[i]: perks[i] = null
			else:
				var perk = Db.get_perk(dict[i][0]) as Resource
				assert(perk, dict[i][0] + " is missing!")
				perks[i] = perk
				perk.rank = dict[i][1]
	return perks

func dict_to_equips(dict: Dictionary) -> Dictionary:
	var equips = {}
	for i in range(5):
			if dict[i] == null: equips[i] = null
			else:
				var equip = Db.get_equip(dict[i])
				equips[i] = equip
	return equips

func _on_player_changed(player):
	var new_player = {}
	new_player["stats"] = {}
	new_player["name"] = player.name
	new_player["job"] = player.job
	new_player["job_tab"] = player.job_tab
	new_player["job_skill"] = player.job_skill
	new_player["slot"] = player.slot
	new_player["tab"] = player.tab
	new_player["frame"] = player.frame
	new_player["stats"]["hp_max"] = player.base_hp_max()
	new_player["stats"]["hp_cur"] = player.hp_cur
	new_player["stats"]["ap"] = player.ap
	new_player["stats"]["str"] = player.base_str()
	new_player["stats"]["agi"] = player.base_agi()
	new_player["stats"]["int"] = player.base_int()
	new_player["stats"]["def"] = player.base_def()
	new_player["stats"]["crit_chance"] = player.get_base_stat(Enums.StatType.CRIT)
	new_player["xp"] = player.xp
	new_player["skill"] = player.skill
	new_player["job_xp"] = player.job_xp
	new_player["job_lv"] = player.job_lv
	new_player["job_data"] = player.job_data
	new_player["actions"] = actions_to_dict(player.actions)
	new_player["perks"] = perks_to_dict(player.perks)
	new_player["equipment"] = equips_to_dict(player.equipment)
	save_data.players[player.slot] = new_player
	var error = ResourceSaver.save(file_path, save_data)
	check_error(error)

func _on_level_changed() -> void:
	save_data.dungeon_lvs = game.dungeon_lvs
	var error = ResourceSaver.save(file_path, save_data)
	check_error(error)

func initialize_deck():
	game.deck.connect("deck_changed", self, "_on_deck_changed")
	game.deck.connect("gold_changed", self, "_on_gold_changed")
	var inv = [ ["Potion", 5], ["Potion", 5], ["Potion", 5] ]
	var gold = 100
	if loading:
		inv = save_data.deck.duplicate()
		gold = save_data.gold
	game.deck.set_actions(inv)
	game.deck.gold = gold

func _on_deck_changed(deck):
	print("Deck Changed")
	var action_list = []
	for action in deck.get_actions():
		action_list.append([action.name, action.uses])
	save_data.deck = action_list
	var error = ResourceSaver.save(file_path, save_data)
	check_error(error)

func _on_gold_changed(amt: int):
	print("Gold changed")
	save_data.gold = amt
	var err := ResourceSaver.save(file_path, save_data)
	if err != OK:
		push_error("Unable to save gold! Err: " + str(err))

func check_error(error):
	if error != OK:
		print("There was an error writing the save %s to %s -> %s" % [save_data.profile_name, file_path, error])

func get_spd() -> float:
	return 1 / spd


# HELPER FUNCTIONS

static func comma_sep(val: int) -> String:
	var string = str(val)
	var mod = string.length() % 3
	var res = ""

	for i in range(0, string.length()):
		if i != 0 && i % 3 == mod:
			res += ","
		res += string[i]

	return res
