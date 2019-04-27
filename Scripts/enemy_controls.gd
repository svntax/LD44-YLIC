extends KinematicBody2D

onready var AGGRO_RANGE = 128

onready var moveSpeed = 32
onready var player = get_tree().get_nodes_in_group("Players")[0]

func _ready():
    pass

func _process(delta):
    pass

func _physics_process(delta):
    var playerPos = player.global_position
    var myPos = self.global_position
    var dist = playerPos - myPos
    if dist.length() < AGGRO_RANGE:
        self.move_and_slide(dist.normalized() * moveSpeed)

