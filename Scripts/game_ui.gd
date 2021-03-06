extends Control

onready var healthLabel = find_node("HealthLabel")
onready var transitions = get_parent().get_parent().get_node("TransitionAnimationPlayer")
onready var gameOverRoot = get_parent().find_node("GameOverRoot")
onready var player = get_tree().get_nodes_in_group("Players")[0]
onready var animPlayer = get_node("AnimationPlayer")

onready var gameOver = false

var deathParticles = load("res://Scenes/death_particles.tscn")

func spawnBloodParticles(amount):
    var particles = deathParticles.instance()
    get_parent().get_parent().add_child(particles)
    get_parent().get_parent().move_child(particles, 1)
    particles.global_position = player.global_position

    var blueParticles : Particles2D = particles.get_node("BlueParticles")
    blueParticles.set_amount(amount)
    blueParticles.restart()

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
        player.get_node("Sprite").hide()
        player.get_node("DeadSprite").show()
        animPlayer.stop()
        SoundHandler.arenaTheme.stop()
        SoundHandler.playerDeath.play()
        spawnBloodParticles(10)
        transitions.play("player_death_transition")

func _on_Arena_playerDeathAnimationFinished():
    gameOverRoot.get_node("GameOverUI").updateLabels()
    gameOverRoot.show()
    SoundHandler.gameOverTheme.play()
    get_tree().paused = true

func _on_AnimationPlayer_animation_finished(anim_name):
    if anim_name == "low_hp_anim":
        if player.health > 10:
            animPlayer.stop()
