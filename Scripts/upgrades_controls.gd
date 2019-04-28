extends Control

var SPEED_COST = 5

onready var speedUpgrade = get_node("CenterContainer/VBoxContainer/SpeedUpgrade")

onready var speed = Globals.CURRENT_SPEED
onready var health = Globals.CURRENT_HEALTH

onready var isActive = false

signal confirmedUpgrades()

func _ready():
    pass # Replace with function body.

func updateLabels():
    var healthLabel : Label = speedUpgrade.get_parent().get_node("HealthLabel")
    healthLabel.set_text("HP Remaining: " + str(health))
    
    var speedLabel : Label = speedUpgrade.get_node("SpeedLabel")
    speedLabel.set_text("Speed (-%d HP):\n%d" % [SPEED_COST, speed])
    
    var waveLabel : Label = get_node("CenterContainer/VBoxContainer/WaveLabel")
    waveLabel.set_text("Wave %d Complete!" % Globals.currentWave)

func syncValues():
    speed = Globals.CURRENT_SPEED
    health = Globals.CURRENT_HEALTH
    updateLabels()

func _on_SpeedIncrease_pressed():
    if isActive:
        if health > SPEED_COST:
            health -= SPEED_COST
            speed += 5 #TODO make this a variable scale
    
        updateLabels()

func _on_SpeedDecrease_pressed():
    if isActive:
        if speed > Globals.MIN_SPEED: #TODO make htis a variable scale
            speed -= 5
            health += SPEED_COST
    
        updateLabels()

func _on_ConfirmButton_pressed():
    if isActive:
        isActive = false
        Globals.CURRENT_SPEED = speed
        Globals.CURRENT_HEALTH = health
        emit_signal("confirmedUpgrades")