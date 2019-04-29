extends Control

var controlsShowing : bool = false

func _ready():
    Globals.resetUpgrades()
    SoundHandler.mainMenuTheme.play()

func _on_Start_pressed():
    SoundHandler.mainMenuTheme.stop()
    get_tree().change_scene("res://Scenes/gameplay.tscn")


func _on_Controls_pressed():
    if controlsShowing:
        controlsShowing = false
        get_node("Controls").set_text("Controls")
        get_parent().find_node("ControlsUI").hide()
    else:
        controlsShowing = true
        get_node("Controls").set_text("Back")
        get_parent().find_node("ControlsUI").show()
