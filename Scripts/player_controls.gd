extends KinematicBody2D

onready var health : int = Globals.CURRENT_HEALTH
onready var walkSpeed : float = Globals.getSpeed()
onready var attackDashSpeed : float = 8
onready var walkVel : Vector2 = Vector2()

onready var slashPivot = get_node("SlashPivot")
onready var attackAnimPlayer : AnimationPlayer = get_node("AttackAnimationPlayer")
onready var damageAnimPlayer : AnimationPlayer = get_node("DamageAnimationPlayer")

onready var PROJECTILE_SPEED_SLOW = 150;
onready var PROJECTILE_SPEED_FAST = 300;

onready var RANGED_ATTACK_COOLDOWN_TIME = 3.5;
onready var rangedAttackCooldown = 0;

onready var DASH_DURATION = 0.1;
onready var dash_ttl = 0;
onready var DASH_SPEEDUP = 300;

onready var dash_slowdown_ttl = 0;
onready var DASH_SLOWDOWN_FACTOR = 1;
onready var DASH_SLOWDOWN_DURATION = 0.8;

onready var DASH_COOLDOWN = 4;
onready var dash_cooldown = 0;

onready var MIN_MELEE_DAMAGE = 4

var player_projectile = load("res://Scenes/player_projectile.tscn")

onready var enemyCount : int = 0

enum State {NORMAL, ATTACK}
onready var currentState = State.NORMAL

signal healthChanged(newHealth)

func _ready():
    pass

#Called when a new wave starts and the player needs to reset and sync with the new upgrades
func updateStats():
    changeState(State.NORMAL)
    health = Globals.CURRENT_HEALTH
    walkSpeed = Globals.getSpeed()
    rangedAttackCooldown = 0
    for projectile in get_tree().get_nodes_in_group("PlayerProjectiles"):
        projectile.queue_free()
    global_position = Vector2(200, 180)
    emit_signal("healthChanged", health)

func changeState(newState):
    currentState = newState
    match newState:
        State.ATTACK:
            slashPivot.get_node("SlashArea").monitoring = true
        State.NORMAL:
            slashPivot.get_node("SlashArea").monitoring = false

func takeDamage(amount):
    #Don't play the hurt animation effect if already dead
    if health > 0:
        SoundHandler.playerHurt.play()
        damageAnimPlayer.play("player_hurt_anim")
    health -= amount
    if health <= 0:
        health = 0
    emit_signal("healthChanged", health)

func updateSlashPivot():
    if not currentState == State.ATTACK:
        var pivotAngle : float = slashPivot.global_position.angle_to_point(get_global_mouse_position())
        slashPivot.set_global_rotation(pivotAngle - deg2rad(90))

func _process(delta):
    updateSlashPivot()
    pass

func _physics_process(delta):
    if health <= 0:
        return
    
    walkVel.x = 0
    walkVel.y = 0
    if(Input.is_action_pressed("MOVE_LEFT")):
        walkVel.x += -1
    if(Input.is_action_pressed("MOVE_RIGHT")):
        walkVel.x += 1
    if(Input.is_action_pressed("MOVE_UP")):
        walkVel.y += -1
    if(Input.is_action_pressed("MOVE_DOWN")):
        walkVel.y += 1
        
    var effective_movespeed = walkSpeed;
    
    if(Input.is_action_pressed("DASH") and dash_cooldown <= 0):
        dash_ttl = DASH_DURATION;
        dash_cooldown = DASH_COOLDOWN;
        SoundHandler.playerDash.play()
        
    if dash_ttl > 0:
        dash_ttl -= delta;
        effective_movespeed = walkSpeed + DASH_SPEEDUP;
        if dash_ttl <= 0:
            dash_slowdown_ttl = DASH_SLOWDOWN_DURATION;
            
    if dash_slowdown_ttl > 0:
        dash_slowdown_ttl -= delta;
        effective_movespeed = walkSpeed * DASH_SLOWDOWN_FACTOR;
        
    if dash_cooldown > 0:
        dash_cooldown -= delta;
        

    if rangedAttackCooldown > 0:
        rangedAttackCooldown -= delta;

    if (currentState == State.NORMAL) and Input.is_action_just_pressed("ATTACK"):
        walkVel.x = 0
        walkVel.y = 0
        attackAnimPlayer.play("slash_anim")
        changeState(State.ATTACK)
        
        var clickPos : Vector2 = get_global_mouse_position()
        var moveVector : Vector2 = (clickPos - global_position).normalized() * attackDashSpeed
        self.set_global_position(self.global_position + moveVector)
    
    elif (currentState == State.NORMAL) and Input.is_action_just_pressed("RANGED_ATTACK"):
        if rangedAttackCooldown <= 0 and Globals.RANGED_ATTACK_LEVEL >= 1:
            walkVel.x = 0
            walkVel.y = 0

            var clickPos : Vector2 = get_global_mouse_position()
            var projectileMotion : Vector2 = (clickPos - global_position).normalized()
            
            var effective_projectile_speed;
            if Globals.RANGED_ATTACK_LEVEL >= 2:
                effective_projectile_speed = PROJECTILE_SPEED_FAST;
            else:
                effective_projectile_speed = PROJECTILE_SPEED_SLOW;
                
            var projectile_test = player_projectile.instance();
            get_parent().add_child(projectile_test);
            projectile_test.global_position = global_position;
            projectile_test.direction = projectileMotion;
            projectile_test.speed = effective_projectile_speed;
            projectile_test.damage = 5;
            rangedAttackCooldown = RANGED_ATTACK_COOLDOWN_TIME;
        
            if Globals.RANGED_ATTACK_LEVEL == 3:
                var perp_vector = Vector2(projectileMotion.y, -projectileMotion.x);
                var p1 = player_projectile.instance();
                var p2 = player_projectile.instance();
                get_parent().add_child(p1);
                get_parent().add_child(p2);
                p1.global_position = global_position;
                p2.global_position = global_position;
                p1.speed = effective_projectile_speed;
                p2.speed = effective_projectile_speed;
                p1.damage = 5;
                p2.damage = 5;
                p1.direction = (projectileMotion + perp_vector/8).normalized();
                p2.direction = (projectileMotion - perp_vector/8).normalized();        
        
    
#    if currentState == State.ATTACK:
#        for body in slashPivot.get_node("SlashArea").get_overlapping_bodies():
#            if body.is_in_group("Enemies"):
#                body.takeDamage(1)
    
    if currentState == State.NORMAL:
        self.move_and_slide(walkVel.normalized() * effective_movespeed)

func _on_Area2D_body_entered(body):
    if body.is_in_group("Enemies"):
        if enemyCount == 0 and get_node("DamageTimer").is_stopped():
            get_node("DamageTimer").start()
            self.takeDamage(2) #TODO damage amount specific to enemy?
        enemyCount += 1
    if body.is_in_group("EnemyProjectiles"):
        self.takeDamage(2) #TODO projectile-specific damage?
        body.queue_free()

func _on_Area2D_body_exited(body):
    if body.is_in_group("Enemies"):
        enemyCount -= 1
        if enemyCount == 0:
            get_node("DamageTimer").stop()

func _on_DamageTimer_timeout():
    self.takeDamage(2) #TODO damage amount specific to enemy?

func _on_AttackAnimationPlayer_animation_finished(anim_name):
    if anim_name == "slash_anim":
        changeState(State.NORMAL)

func _on_SlashArea_body_entered(body):
    if body.is_in_group("Enemies"):
        body.takeDamage(MIN_MELEE_DAMAGE)
