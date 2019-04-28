extends Control

var SPEED_HP_COST = 5
var RANGED_ATTACK_HP_COST = 8

onready var speedUpgrade = find_node("SpeedUpgrade")
onready var rangedAttackUpgrade = find_node("RangeAttackUpgrade")

onready var speedLevel = Globals.SPEED_LEVEL
onready var health : int = Globals.CURRENT_HEALTH
onready var rangedAttackLevel : int = Globals.RANGED_ATTACK_LEVEL

onready var isActive : bool = false

signal confirmedUpgrades()

func _ready():
    pass

func updateLabels():
    var healthLabel : Label = speedUpgrade.get_parent().get_node("HealthLabel")
    healthLabel.set_text("HP Remaining: " + str(health))
    
    var speedLabel : Label = speedUpgrade.get_node("SpeedLabel")
    speedLabel.set_text("Speed (-%d HP):\nLevel %d / %d" % [SPEED_HP_COST, speedLevel, Globals.MAX_SPEED_LEVEL])
    
    var rangedAttackLabel : Label = rangedAttackUpgrade.get_node("RangedAttackLabel")
    rangedAttackLabel.set_text("Ranged Attack (-%d HP):\nLevel %d / 3" % [RANGED_ATTACK_HP_COST, rangedAttackLevel])
    
    var waveLabel : Label = find_node("WaveLabel")
    waveLabel.set_text("Wave %d Complete!" % Globals.currentWave)

func syncValues():
    speedLevel = Globals.SPEED_LEVEL
    health = Globals.CURRENT_HEALTH
    rangedAttackLevel = Globals.RANGED_ATTACK_LEVEL
    updateLabels()

func _on_SpeedIncrease_pressed():
    if isActive:
        if health > SPEED_HP_COST and speedLevel < Globals.MAX_SPEED_LEVEL:
            health -= SPEED_HP_COST
            speedLevel += 1
            #speed += 5
        updateLabels()

func _on_SpeedDecrease_pressed():
    if isActive:
        if speedLevel > Globals.MIN_SPEED_LEVEL:
            #speed -= 5
            speedLevel -= 1
            health += SPEED_HP_COST
        updateLabels()

func _on_ConfirmButton_pressed():
    if isActive:
        isActive = false
        Globals.SPEED_LEVEL = speedLevel
        Globals.CURRENT_HEALTH = health
        Globals.RANGED_ATTACK_LEVEL = rangedAttackLevel
        emit_signal("confirmedUpgrades")

func _on_RangedAttackIncrease_pressed():
    if isActive:
        if health > RANGED_ATTACK_HP_COST and rangedAttackLevel < 3:
            health -= RANGED_ATTACK_HP_COST
            rangedAttackLevel += 1
        updateLabels()

func _on_RangedAttackDecrease_pressed():
    if isActive:
        if rangedAttackLevel > 0:
            health += RANGED_ATTACK_HP_COST
            rangedAttackLevel -= 1
        updateLabels()
