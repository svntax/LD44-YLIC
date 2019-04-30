extends KinematicBody2D

onready var AGGRO_RANGE = 128

onready var moveSpeed = 45
onready var player = get_tree().get_nodes_in_group("Players")[0]

onready var arena = get_tree().get_nodes_in_group("Arenas")[0]
onready var STARTING_HEALTH = 10;
onready var health = STARTING_HEALTH;

onready var STOP_INTERVAL_LOW = 0.15;
onready var STOP_INTERVAL_HIGH = 0.3;
onready var MOVEMENT_INTERVAL = 0.8;
onready var movement_cooldown = 0.5;
onready var movement_ttl = 0;
onready var movement_direction;

onready var contact_damage = 4;

onready var damageAnimPlayer = get_node("DamageAnimationPlayer")
var deathParticles = load("res://Scenes/death_particles.tscn")

func spawnBloodParticles(amount):
    var particles = deathParticles.instance()
    get_parent().add_child(particles)
    get_parent().move_child(particles, 1)
    particles.global_position = self.global_position

    var greenParticles : Particles2D = particles.get_node("GreenParticles")
    greenParticles.set_amount(amount)
    greenParticles.restart()

func takeDamage(damage):
    #Can't take damage if already dead
    if health <= 0:
        return
    health -= damage;
    spawnBloodParticles(5)
    damageAnimPlayer.play("enemy_hurt_anim")
    if health > 0:
        SoundHandler.enemyHurt.play()
    if health <= 0:
        spawnBloodParticles(10)
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
            movement_cooldown = rand_range(STOP_INTERVAL_LOW, STOP_INTERVAL_HIGH);
        else:
            self.move_and_slide(movement_direction.normalized() * moveSpeed)
            get_node("Sprite").set_flip_h(movement_direction.x > 0)

