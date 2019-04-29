extends KinematicBody2D

onready var AGGRO_RANGE = 100

onready var moveSpeed = 64
onready var chargeSpeed = 512;
onready var player = get_tree().get_nodes_in_group("Players")[0]


onready var DEFAULT_DAMAGE = 8;
onready var CHARGE_DAMAGE = 15;
onready var contact_damage = DEFAULT_DAMAGE;


onready var charging = false;
onready var charge_moving = false;
onready var charge_rumble = 0;
onready var charge_cooldown = 0;
onready var charge_duration = 0;
onready var charge_ready = true;
onready var locked_on = false;
onready var target;
onready var target_direction;
onready var dist;
onready var random_moving = false;
onready var random_move_cooldown = 0;
onready var random_move_x = 0;
onready var random_move_y = 0;
onready var random_move_duration = 0;
onready var random_move_direction;
onready var true_position;

onready var arena = get_tree().get_nodes_in_group("Arenas")[0]
onready var STARTING_HEALTH = 15;
onready var health = STARTING_HEALTH;

onready var damageAnimPlayer = get_node("DamageAnimationPlayer")

func faceThePlayer():
    get_node("Sprite").set_flip_h(player.global_position.x > self.global_position.x)

func takeDamage(damage):
    damageAnimPlayer.play("enemy_hurt_anim")
    health -= damage;
    if health <= 0:
        arena.enemyDestroyed();
        queue_free();

func _ready():
    randomize();
    pass

func _process(delta):
    pass

func _physics_process(delta):
    var playerPos = player.global_position
    var myPos = self.global_position
    var dist = playerPos - myPos
    if charging == false:
        charge_cooldown -= delta;
        #if charge_cooldown > 0:
            #print("charge cd: ", charge_cooldown);
    if random_moving == false:
        random_move_cooldown -= delta;
        
    if charge_ready == false and charge_cooldown <= 0:
        charge_ready = true;
    #if charge_ready == false:
    #    print("Charge cooldown", charge_cooldown);
    if dist.length() < AGGRO_RANGE and charge_ready and random_moving == false:
        if not charge_moving:
            faceThePlayer()
        if charging == false:
            charge_rumble = 2;
            true_position = position;
        charging = true;
       # print("beginning charge");
        
    if charging:
        charge_duration -= delta;
        charge_rumble -= delta;
        if charge_moving and charge_duration <= 0:
            contact_damage = DEFAULT_DAMAGE;
            charging = false;
            charge_moving = false;
            charge_ready = false;
            locked_on = false;
            charge_cooldown = 8;
            random_move_cooldown = 1;
        var offset;
        if charging and charge_rumble > 0:
            offset = Vector2(randf(), randf());
            #print("rumbling with offset: ", offset)
            position = true_position + offset;
        if charging and charge_rumble > 0 and charge_rumble < 1 and locked_on == false:
            
            locked_on = true;
            target = playerPos;
            #print("Locked onto position ", target);
            target_direction = target - myPos;
        if charging and charge_rumble <= 0 and charge_moving == false:
            #print("Initiating charge movement");
            position = true_position;
            charge_moving = true;
            contact_damage = CHARGE_DAMAGE;
            charge_duration = 0.25;
        if charging and charge_moving:
            get_node("Sprite").set_flip_h(target_direction.x > 0)
            self.move_and_slide(target_direction.normalized() * chargeSpeed)
            
    else:
        
        if random_moving == false and random_move_cooldown <= 0:
            random_move_duration = 1;
            random_moving = true;
            if dist.length() <= AGGRO_RANGE and randf() < 0.65:
                random_move_direction = dist;
            else:
                random_move_direction = Vector2(rand_range(-1, 1), rand_range(-1, 1));
        if random_moving:
            
            random_move_duration -= delta;
            if random_move_duration <= 0:
                random_moving = false;
                random_move_cooldown = 2;
            else:
                get_node("Sprite").set_flip_h(random_move_direction.x > 0)
                self.move_and_slide(random_move_direction.normalized() * moveSpeed)
        

