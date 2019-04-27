extends Node2D

onready var player = get_tree().get_nodes_in_group("Players")[0]
onready var upgradesMenu = get_node("UILayer/UpgradesRoot/UpgradesMenu")

onready var transitions : AnimationPlayer = get_node("TransitionAnimationPlayer")

onready var enemyCount : int = get_tree().get_nodes_in_group("Enemies").size()

var basicEnemy = load("res://Scenes/enemy_basic.tscn")
var bullEnemy = load("res://Scenes/bull.tscn")
var archerEnemy = load("res://Scenes/archer.tscn")
var casterEnemy = load("res://Scenes/caster.tscn");

onready var layoutRoot = get_node("LayoutRoot")

var arenaLayouts = {
layoutBasic = load("res://Scenes/LayoutBasic")
}

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

#TODO spawn new layout and wave of enemies
func spawnNewLayout():
    #TODO delete and spawn new layout
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
        enemy.set_global_position(Vector2(randi() % 320, randi() % 50 + 100))

func enemyDestroyed():
    enemyCount -= 1
    if enemyCount <= 0: #End of wave
        Globals.CURRENT_HEALTH = player.health
        upgradesMenu.syncValues()
        upgradesMenu.isActive = true
        transitions.play("upgrades_menu_transition")
        get_tree().paused = true

func _on_UpgradesMenu_confirmedUpgrades():
    player.updateStats()
    spawnNewLayout()
    transitions.play("upgrades_menu_confirmed_transition")

func _on_TransitionAnimationPlayer_animation_finished(anim_name):
    if anim_name == "upgrades_menu_confirmed_transition":
        get_tree().paused = false
