extends Node2D

onready var player = get_tree().get_nodes_in_group("Players")[0]
onready var upgradesMenu = get_node("UILayer/UpgradesRoot").find_node("UpgradesMenu")

onready var transitions : AnimationPlayer = get_node("TransitionAnimationPlayer")

onready var enemyCount : int = get_tree().get_nodes_in_group("Enemies").size()

var basicEnemy = load("res://Scenes/enemy_basic.tscn")
var bullEnemy = load("res://Scenes/bull.tscn")
var archerEnemy = load("res://Scenes/archer.tscn")
var casterEnemy = load("res://Scenes/caster.tscn");

onready var layoutRoot = get_node("LayoutRoot")
onready var nextLayoutChoice = -1

var layoutBasic = load("res://Scenes/layout_basic.tscn")
var layout02 = load("res://Scenes/layout_02.tscn")
var layout03 = load("res://Scenes/layout_03.tscn")
var layout04 = load("res://Scenes/layout_04.tscn")
var layout05 = load("res://Scenes/layout_05.tscn")

var arenaLayouts = [
layoutBasic,
layout02,
layout03,
layout04,
layout05
]

#Hard levels start spawning after this wave
var HARD_LEVELS_START = 5
var layoutHard01 = load("res://Scenes/layoutHard_01.tscn")
var layoutHard02 = load("res://Scenes/layoutHard_02.tscn")
var layoutHard03 = load("res://Scenes/layoutHard_03.tscn")

var arenaLayoutsHard = [
layoutHard01,
layoutHard02,
layoutHard03
]

signal playerDeathAnimationFinished()

# Called when the node enters the scene tree for the first time.
func _ready():
    SoundHandler.arenaTheme.play()

func spawnNewLayout():
    for child in layoutRoot.get_children():
        child.queue_free()
    
    var newLayout
    if Globals.currentWave < HARD_LEVELS_START:
        newLayout = arenaLayouts[nextLayoutChoice].instance()
    else:
        newLayout = arenaLayoutsHard[nextLayoutChoice].instance()
    layoutRoot.add_child(newLayout)
    #enemyCount = get_tree().get_nodes_in_group("Enemies").size()
    enemyCount = 0
    for node in newLayout.get_children():
        if node.is_in_group("Enemies"):
            enemyCount += 1

func enemyDestroyed():
    enemyCount -= 1
    if Globals.DASH_LEVEL >= 3:
            player.resetDashCooldown()
    if enemyCount <= 0: #End of wave
        Globals.CURRENT_HEALTH = player.health
        if Globals.currentWave < HARD_LEVELS_START:
            nextLayoutChoice = randi() % arenaLayouts.size()
        else:
            nextLayoutChoice = randi() % arenaLayoutsHard.size()
        upgradesMenu.syncValues()
        transitions.play("upgrades_menu_transition")
        get_tree().paused = true

func _on_UpgradesMenu_confirmedUpgrades():
    player.updateStats()
    spawnNewLayout()
    transitions.play("upgrades_menu_confirmed_transition")

func _on_TransitionAnimationPlayer_animation_finished(anim_name):
    if anim_name == "upgrades_menu_confirmed_transition":
        get_tree().paused = false
        Globals.currentWave += 1
    if anim_name == "upgrades_menu_transition":
        upgradesMenu.isActive = true
    if anim_name == "player_death_transition":
        emit_signal("playerDeathAnimationFinished")
