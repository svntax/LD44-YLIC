extends KinematicBody2D

onready var AGGRO_RANGE = 80
onready var PROJECTILE_SPEED = 325;

onready var moveSpeed = 32
onready var player = get_tree().get_nodes_in_group("Players")[0]

var enemy_projectile = load("res://Scenes/enemy_projectile.tscn")

var deathParticles = load("res://Scenes/death_particles.tscn")

onready var shotTimer = 5;

onready var arena = get_tree().get_nodes_in_group("Arenas")[0]
onready var STARTING_HEALTH = 5;
onready var health = STARTING_HEALTH;

onready var contact_damage = 3;

onready var RANDOM_MOVE_COOLDOWN = 3;
onready var random_move_cooldown = 0;
onready var RANDOM_MOVE_DURATION = 1;
onready var random_move_ttl = 0;
onready var random_move_direction;

onready var damageAnimPlayer = get_node("DamageAnimationPlayer")

func faceThePlayer():
    get_node("Sprite").set_flip_h(player.global_position.x > self.global_position.x)

func spawnBloodParticles(amount):
    var particles = deathParticles.instance()
    get_parent().add_child(particles)
    get_parent().move_child(particles, 1)
    particles.global_position = self.global_position

    var grayParticles : Particles2D = particles.get_node("GrayParticles")
    grayParticles.set_amount(amount)
    grayParticles.restart()

func takeDamage(damage):
    #Can't take damage if already dead
    if health <= 0:
        return
    spawnBloodParticles(3)
    damageAnimPlayer.play("enemy_hurt_anim")
    health -= damage;
    if health <= 0:
        spawnBloodParticles(8)
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
        SoundHandler.arrowShoot.play()
        projectile_test.global_position = global_position;
        projectile_test.direction = dist.normalized();
        projectile_test.speed = PROJECTILE_SPEED;
        shotTimer = 5;
