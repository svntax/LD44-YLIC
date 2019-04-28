extends Control

onready var healthLabel = get_node("HBoxContainer/HealthLabel")
onready var transitions = get_parent().get_parent().get_node("TransitionAnimationPlayer")
onready var gameOverRoot = get_parent().find_node("GameOverRoot")

onready var gameOver = false

func _ready():
    healthLabel.set_text("HP " + str(Globals.CURRENT_HEALTH))

func _on_Player_healthChanged(newHealth):
    healthLabel.set_text("HP " + str(newHealth))
    if newHealth <= 0 and not gameOver:
        gameOver = true
        SoundHandler.playerDeath.play()
        transitions.play("player_death_transition")

func _on_Arena_playerDeathAnimationFinished():
    gameOverRoot.get_node("GameOverUI").updateLabels()
    gameOverRoot.show()
    get_tree().paused = true
