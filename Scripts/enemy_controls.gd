extends KinematicBody2D

onready var AGGRO_RANGE = 128

onready var moveSpeed = 32
onready var player = get_tree().get_nodes_in_group("Players")[0]

onready var arena = get_tree().get_nodes_in_group("Arenas")[0]
onready var STARTING_HEALTH = 10;
onready var health = STARTING_HEALTH;

func takeDamage(damage):
    #Can't take damage if already dead
    if health <= 0:
        return
    health -= damage;
    if health <= 0:
        arena.enemyDestroyed();
        queue_free();

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

