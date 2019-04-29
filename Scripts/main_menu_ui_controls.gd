extends Control

func _ready():
    Globals.resetUpgrades()
    SoundHandler.mainMenuTheme.play()

func _on_Start_pressed():
    SoundHandler.mainMenuTheme.stop()
    get_tree().change_scene("res://Scenes/gameplay.tscn")


func _on_Controls_pressed():
    #TODO
    pass # Replace with function body.
