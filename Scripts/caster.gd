extends KinematicBody2D

onready var AGGRO_RANGE = 80
onready var PROJECTILE_SPEED = 100;

onready var moveSpeed = 32
onready var player = get_tree().get_nodes_in_group("Players")[0]

onready var RANDOM_MOVE_COOLDOWN = 3;
onready var random_move_cooldown = 0;
onready var RANDOM_MOVE_DURATION = 1;
onready var random_move_ttl = 0;
onready var random_move_direction;

var enemy_projectile = load("res://Scenes/enemy_projectile.tscn")

onready var shotTimer = 5;

onready var arena = get_tree().get_nodes_in_group("Arenas")[0]
onready var STARTING_HEALTH = 5;
onready var health = STARTING_HEALTH;

func faceThePlayer():
    get_node("Sprite").set_flip_h(player.global_position.x > self.global_position.x)

func takeDamage(damage):
    health -= damage;
    if health <= 0:
        arena.enemyDestroyed();
        queue_free();

func _ready():
    pass

func _process(delta):
    faceThePlayer()

func _physics_process(delta):
    var playerPos = player.global_position
    var myPos = self.global_position
    var dist = playerPos - myPos
    
    if random_move_cooldown > 0:
        random_move_cooldown -= delta;
    if random_move_ttl > 0:
        random_move_ttl -= delta;
        if random_move_ttl <= 0:
            random_move_cooldown = RANDOM_MOVE_COOLDOWN;
    
    if dist.length() < AGGRO_RANGE:
        self.move_and_slide(dist.normalized() * moveSpeed * -1);
    elif random_move_cooldown <= 0:
        if random_move_ttl <= 0:
            random_move_ttl = RANDOM_MOVE_DURATION;
            random_move_direction = Vector2(rand_range(-1, 1), rand_range(-1, 1));
        self.move_and_slide(random_move_direction.normalized() * moveSpeed);
    
    shotTimer -= delta;
    if shotTimer <= 0:
        var projectile_test = enemy_projectile.instance();
        get_parent().add_child(projectile_test);
        SoundHandler.casterShoot.play()
        projectile_test.global_position = global_position;
        projectile_test.direction = dist.normalized();
        projectile_test.speed = PROJECTILE_SPEED;
        projectile_test.target_player = true;
        projectile_test.limited_lifespan = true;
        projectile_test.lifespan = 4.5;
        shotTimer = 5;
