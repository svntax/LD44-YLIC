extends Control

onready var healthLabel = get_node("HBoxContainer/HealthLabel")
onready var transitions = get_parent().get_parent().get_node("TransitionAnimationPlayer")

func _ready():
    healthLabel.set_text("HP " + str(Globals.CURRENT_HEALTH))

func _on_Player_healthChanged(newHealth):
    healthLabel.set_text("HP " + str(newHealth))
    #TODO game over + go back to main menu
    if newHealth <= 0:
        SoundHandler.playerDeath.play()
        transitions.play("player_death_transition")
        #get_tree().paused = true
