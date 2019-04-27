extends KinematicBody2D

onready var AGGRO_RANGE = 128
onready var PROJECTILE_SPEED = 100;

onready var moveSpeed = 32
onready var player = get_tree().get_nodes_in_group("Players")[0]

var enemy_projectile = load("res://Scenes/enemy_projectile.tscn")

onready var shotTimer = 5;

func _ready():
    pass

func _process(delta):
    pass

func _physics_process(delta):
    var playerPos = player.global_position
    var myPos = self.global_position
    var dist = playerPos - myPos
    if dist.length() < AGGRO_RANGE:
        self.move_and_slide(dist.normalized() * moveSpeed * -1)
    shotTimer -= delta;
    if shotTimer <= 0:
        var projectile_test = enemy_projectile.instance();
        get_parent().add_child(projectile_test);
        projectile_test.global_position = global_position;
        projectile_test.direction = dist.normalized();
        projectile_test.speed = PROJECTILE_SPEED;
        projectile_test.target_player = true;
        projectile_test.limited_lifespan = true;
        projectile_test.lifespan = 6;
        shotTimer = 5;
