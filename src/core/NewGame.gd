extends Window

export (Array, Resource) var jobs

onready var portrait := $Portrait
onready var title := $Title
onready var xp_gauge := $XpGauge
onready var xp_val := $XpVal
onready var life := $Stats/Life/Label
onready var armor := $Stats/Armor/Label
onready var mana := $Stats/Mana/Label
onready var stamina := $Stats/Stamina/Label
onready var gold := $Stats/Gold/Label
onready var desc := $Desc

onready var perks_btn := $Btns/Perks
onready var gear_btn := $Btns/Gear
onready var spec_btn := $Btns/Spec
onready var perks_window := $Perks

var _game: Game
var _cur_job: Job
var _cur_job_index: int
var _job_data: Dictionary

func init(game: Game) -> void:
	perks_window.hide_instantly()
	_game = game
	_job_data = game.save.job_data
	set_job_data()
	set_cur_job(0)

func set_job_data() -> void:
	for job in jobs:
		var job_data = _job_data[job.id]
		job.unlocked = job_data.unlocked
		job.level = job_data.level
		job.xp = job_data.xp
		print(job.title, " -> Lv. ", job.level, "  XP: ", job.xp)
		for perk in job.perks:
			perk.ranks = job_data.perk_data[perk.id]
			print("\t", perk.title, " -> Ranks: ", perk.ranks, "/", perk.max_ranks)

func set_cur_job(index: int) -> void:
	_cur_job_index = index
	var job = jobs[_cur_job_index]
	_cur_job = job
	portrait.frame = job.sprite_id
	title.text = "Lv. " + str(job.level) + " " + job.title
	var max_val = get_max_xp_val(job.level)
	if job.level < 10:
		xp_val.text = "Xp. " + Gm.comma_sep(job.xp) + "/" + Gm.comma_sep(max_val)
	else:
		xp_val.text = "Max Level"
		max_val = 0
	xp_gauge.max_value = max_val
	xp_gauge.value = job.xp
	life.text = str(job.life)
	armor.text = str(job.armor)
	mana.text = str(job.mana)
	stamina.text = str(job.stamina)
	gold.text = str(job.gold)
	desc.text = job.desc
	
	if job.level < 3:
		perks_btn.text = "Perks unlocked at Lv. 2"
	else:
		perks_btn.text = job.title + " Perks"
		perks_btn.disabled = false
		perks_window.banner = "Lv. " + str(job.level) + " " + job.title + " Perks"
		
	if job.level < 3:
		gear_btn.text = "Gear unlocked at Lv. 3"
	else:
		gear_btn.text = job.title + "'s Gear"
		gear_btn.disabled = false
		
	if job.level < 4:
		spec_btn.text = "Specs unlocked at Lv. 4"
	else:
		spec_btn.text = job.title + "'s Specs"
		spec_btn.disabled = false

func get_max_xp_val(level: int) -> int:
	return 100 * (level + 1)


func _on_Perks_pressed():
	Ac.click()
	_game.show_window(perks_window)


func _on_Delve_pressed():
	Ac.confirm()
	_game.start_game(_cur_job)


func _on_Prev_pressed():
	Ac.click()
	set_cur_job((_cur_job_index - 1) % jobs.size())

func _on_Next_pressed():
	Ac.click()
	set_cur_job((_cur_job_index + 1) % jobs.size())
