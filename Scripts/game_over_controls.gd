extends Control

onready var wavesCompletedLabel : Label = find_node("WavesCompleted")
onready var highScore : Label = find_node("HighScore")
onready var speedLabel : Label = find_node("SpeedStat")
onready var rangedAttackLabel : Label = find_node("RangedAttackStat")
onready var dashLabel : Label = find_node("DashStat")

func updateLabels():
    var waveWord : String = "waves"
    if Globals.currentWave - 1 == 1:
        waveWord = "wave"
    wavesCompletedLabel.set_text("You completed %d %s!" % [Globals.currentWave - 1, waveWord])
    
    if Globals.currentWave - 1 > Globals.highScore:
        Globals.highScore = Globals.currentWave - 1
        highScore.set_text("New High Score! %d %s" % [Globals.highScore, waveWord])
    else:
        if Globals.highScore == 1:
            waveWord = "wave"
        else:
            waveWord = "waves"
        highScore.set_text("High Score: %d %s" % [Globals.highScore, waveWord])

    speedLabel.set_text("Speed: Level %d / %d" % [Globals.SPEED_LEVEL, Globals.MAX_SPEED_LEVEL])
    
    rangedAttackLabel.set_text("Ranged Attack: Level %d / 3" % Globals.RANGED_ATTACK_LEVEL)
    
    dashLabel.set_text("Dash: Level %d / 3" % Globals.DASH_LEVEL)

func _ready():
    pass

func _on_ReturnButton_pressed():
    get_tree().paused = false
    get_tree().change_scene("res://Scenes/main_menu.tscn")
