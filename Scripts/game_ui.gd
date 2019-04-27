extends Control

onready var healthLabel = get_node("HBoxContainer").get_node("HealthLabel")
onready var transitions = get_parent().get_parent().get_node("TransitionAnimationPlayer")

func _ready():
    healthLabel.set_text("HP " + str(Globals.CURRENT_HEALTH))

func _on_Player_healthChanged(newHealth):
    healthLabel.set_text("HP " + str(newHealth))
    #TODO player death
    if newHealth <= 0:
        print("Player death")
        transitions.play("player_death_transition")
        #get_tree().paused = true
