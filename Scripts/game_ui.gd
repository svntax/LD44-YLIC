extends Control

onready var healthLabel = get_node("HBoxContainer/HealthLabel")
onready var transitions = get_parent().get_parent().get_node("TransitionAnimationPlayer")
onready var gameOverRoot = get_parent().find_node("GameOverRoot")
onready var player = get_tree().get_nodes_in_group("Players")[0]
onready var animPlayer = get_node("AnimationPlayer")

onready var gameOver = false

func _ready():
    healthLabel.set_text("HP " + str(Globals.CURRENT_HEALTH))

func _on_Player_healthChanged(newHealth):
    healthLabel.set_text("HP " + str(newHealth))
    if newHealth <= 10:
        if not animPlayer.is_playing():
            animPlayer.play("low_hp_anim")
    else:
        animPlayer.play("reset_text_color")
    if newHealth <= 0 and not gameOver:
        gameOver = true
        animPlayer.stop()
        SoundHandler.playerDeath.play()
        transitions.play("player_death_transition")

func _on_Arena_playerDeathAnimationFinished():
    gameOverRoot.get_node("GameOverUI").updateLabels()
    gameOverRoot.show()
    get_tree().paused = true


func _on_AnimationPlayer_animation_finished(anim_name):
    if anim_name == "low_hp_anim":
        if player.health > 10:
            animPlayer.stop()
