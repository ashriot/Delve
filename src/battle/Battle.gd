class_name Battle
extends Window

onready var enemy_sprite := $EnemyPanel/Enemy
onready var enemy_life := $EnemyPanel/Life/Value
onready var enemy_life_percent := $EnemyPanel/Life/Percent
onready var enemy_armor := $EnemyPanel/Armor/Value
onready var enemy_mana := $EnemyPanel/Mana/Value

onready var player_life := $Bg/PlayerPanel/Life/Value
onready var player_life_percent := $Bg/PlayerPanel/Life/Percent
onready var player_armor := $Bg/PlayerPanel/Armor/Icon/Value
onready var player_mana := $Bg/PlayerPanel/Mana/Icon/Value
onready var player_stamina := $Bg/PlayerPanel/Stamina/StaminaCur
onready var player_stamina_max := $Bg/PlayerPanel/Stamina/StaminaMax

var _game: Game
var _enemy: Enemy
var _player: Player

func init(game: Game) -> void:
	_game = game
	

func setup(enemy: Enemy) -> void:
	_enemy = enemy
	self.banner = "Lv. " + str(_enemy.level) + " " + _enemy.title
	enemy_sprite.texture = _enemy.texture
	_player = _game.player
	
