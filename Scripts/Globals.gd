extends Node

#To keep track of upgrades over the course of the game
var MIN_SPEED = 50

var CURRENT_HEALTH = 100
var CURRENT_SPEED = 50

var RANGED_ATTACK_LEVEL = 1

var currentWave = 1
var highScore = 0

func resetUpgrades():
    CURRENT_HEALTH = 100
    CURRENT_SPEED = 50
    RANGED_ATTACK_LEVEL = 1
    currentWave = 1

func _ready():
    pass # Replace with function body.
