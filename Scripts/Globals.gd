extends Node

#To keep track of upgrades over the course of the game
var CURRENT_HEALTH = 100

var MIN_SPEED_LEVEL = 1
var MAX_SPEED_LEVEL = 5
#var CURRENT_SPEED = 40
var SPEED_LEVEL = 1
var MIN_SPEED = 40
var SPEED_INCREMENT = 20

var RANGED_ATTACK_LEVEL = 1

var currentWave = 1
var highScore = 0

func getSpeed():
    return MIN_SPEED + ((SPEED_LEVEL - 1) * SPEED_INCREMENT)

func resetUpgrades():
    CURRENT_HEALTH = 100
    #CURRENT_SPEED = 50
    SPEED_LEVEL = 1
    RANGED_ATTACK_LEVEL = 1
    currentWave = 1

func _ready():
    pass # Replace with function body.
