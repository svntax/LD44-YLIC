extends Node2D

onready var player = get_tree().get_nodes_in_group("Players")[0]
onready var upgradesMenu = get_node("UILayer").get_node("UpgradesMenu")

onready var enemyCount = get_tree().get_nodes_in_group("Enemies").size()

var basicEnemy = load("res://Scenes/enemy_basic.tscn")
var bullEnemy = load("res://Scenes/bull.tscn")
var archerEnemy = load("res://Scenes/archer.tscn")
var casterEnemy = load("res://Scenes/caster.tscn");

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

#TODO spawn new layout and wave of enemies
func spawnNewLayout():
    for i in range(3):
        enemyCount += 1
        var enemy
        if i%3 == 0:
            enemy = archerEnemy.instance()
        elif i%2 == 0:
            enemy = bullEnemy.instance()
        else:
            enemy = casterEnemy.instance()
        self.add_child(enemy)
        enemy.set_global_position(Vector2(randi() % 320, randi() % 50))

func enemyDestroyed():
    enemyCount -= 1
    if enemyCount <= 0: #End of wave
        Globals.CURRENT_HEALTH = player.health
        upgradesMenu.syncValues()
        upgradesMenu.show()
        get_tree().paused = true

func _on_UpgradesMenu_confirmedUpgrades():
    player.updateStats()
    spawnNewLayout()
