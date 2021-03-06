extends Node

#Sounds
onready var arrowShoot = get_node("ArrowShoot")
onready var casterShoot = get_node("CasterShoot")
onready var slash01 = get_node("Slash01")
onready var playerShoot = get_node("PlayerShoot")

onready var playerDeath = get_node("PlayerDeath")
onready var playerDash = get_node("Dash")
onready var playerHurt = get_node("PlayerHurt")

onready var enemyHurt = get_node("EnemyHurt")

onready var archerDeath = get_node("ArcherDeath")
onready var casterDeath = get_node("CasterDeath")
onready var bullDeath = get_node("BullDeath")
onready var basicEnemyDeath = get_node("BasicEnemyDeath")

#Music
onready var gameOverTheme = get_node("GameOverTheme")
onready var mainMenuTheme = get_node("MainMenuTheme")
onready var arenaTheme = get_node("ArenaTheme")

func _ready():
    pass
