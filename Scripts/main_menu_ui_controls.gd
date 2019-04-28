extends Control

func _ready():
    Globals.resetUpgrades()

func _on_Start_pressed():
    get_tree().change_scene("res://Scenes/gameplay.tscn")
