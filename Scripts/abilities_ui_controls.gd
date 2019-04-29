extends Control

onready var dashBar : ProgressBar = find_node("DashCooldown")
onready var rangedBar : ProgressBar = find_node("RangedCooldown")

func _ready():
    pass

func _on_Player_dashCooldownChanged(newValue):
    dashBar.set_value(dashBar.get_max() - newValue)

func _on_Player_rangedCooldownChanged(newValue):
    rangedBar.set_value(rangedBar.get_max() - newValue)
