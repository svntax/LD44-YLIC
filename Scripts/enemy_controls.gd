extends KinematicBody2D

onready var AGGRO_RANGE = 128

onready var moveSpeed = 45
onready var player = get_tree().get_nodes_in_group("Players")[0]

onready var arena = get_tree().get_nodes_in_group("Arenas")[0]
onready var STARTING_HEALTH = 10;
onready var health = STARTING_HEALTH;

onready var STOP_INTERVAL = 0.4;
onready var MOVEMENT_INTERVAL = 0.8;
onready var movement_cooldown = 1;
onready var movement_ttl = 0;
onready var movement_direction;

func takeDamage(damage):
    #Can't take damage if already dead
    if health <= 0:
        return
    health -= damage;
    if health <= 0:
        arena.enemyDestroyed();
        SoundHandler.basicEnemyDeath.play()
        queue_free();

func _ready():
    pass

func _process(delta):
    pass

func _physics_process(delta):
    var playerPos = player.global_position;
    var myPos = self.global_position;
    var dist = playerPos - myPos;
    var normdist = dist.normalized();
    if movement_cooldown > 0:
        movement_cooldown -= delta;
        if movement_cooldown <= 0:
            movement_ttl = MOVEMENT_INTERVAL;
            if dist.length() < AGGRO_RANGE:
                movement_direction = dist.normalized();
            else:
                var roll = randf();
                var randomOffset = Vector2(rand_range(-1, 1), rand_range(-1, 1)).normalized()/8;
                if roll < 0.4:
                    movement_direction = dist.normalized() + randomOffset;
                elif roll < 0.6:
                    movement_direction = Vector2(normdist.y, -normdist.x) + randomOffset;
                elif roll < 0.8:
                    movement_direction = Vector2(-normdist.y, normdist.x) + randomOffset;
                else:
                    movement_direction = Vector2(-normdist.y, -normdist.x) + randomOffset;
    if movement_ttl > 0:
        movement_ttl -= delta;
        if movement_ttl <= 0:
            movement_cooldown = STOP_INTERVAL;
        else:
            self.move_and_slide(movement_direction.normalized() * moveSpeed)

