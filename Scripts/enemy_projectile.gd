extends KinematicBody2D

onready var direction;
onready var speed;
onready var accel;
onready var target_player = false;
onready var limited_lifespan = false;
onready var lifespan;
onready var damage = 0;

onready var player = get_tree().get_nodes_in_group("Players")[0]

func _ready():
    pass

func _process(delta):
    pass

func _physics_process(delta):
    if limited_lifespan:
        lifespan -= delta;
    if limited_lifespan and lifespan <= 0:
        queue_free();
    if target_player:
        var playerPos = player.global_position;
        var myPos = self.global_position;
        var dist = playerPos - myPos;
        direction = (direction + dist * delta / 32).normalized();
    move_and_slide(direction * speed);

func _on_Area2D_body_entered(body):
    if body is TileMap:
        queue_free()
