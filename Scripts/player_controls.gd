extends KinematicBody2D

onready var health : int = Globals.CURRENT_HEALTH
onready var walkSpeed : float = Globals.CURRENT_SPEED
onready var attackDashSpeed : float = 8
onready var walkVel : Vector2 = Vector2()

onready var slashPivot = get_node("SlashPivot")
onready var attackAnimPlayer : AnimationPlayer = get_node("AttackAnimationPlayer")

onready var PROJECTILE_SPEED = 200;

onready var RANGED_ATTACK_COOLDOWN_TIME = 3.5;
onready var rangedAttackCooldown = 0;

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
    walkSpeed = Globals.CURRENT_SPEED
    rangedAttackCooldown = 0
    for projectile in get_tree().get_nodes_in_group("PlayerProjectiles"):
        projectile.queue_free()
    global_position = Vector2(200, 180)
    emit_signal("healthChanged", health)

func changeState(newState):
    currentState = newState

func takeDamage(amount):
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
    walkVel.x = 0
    walkVel.y = 0
    
    if(Input.is_action_pressed("MOVE_LEFT")):
        walkVel.x += -walkSpeed
    if(Input.is_action_pressed("MOVE_RIGHT")):
        walkVel.x += walkSpeed
    if(Input.is_action_pressed("MOVE_UP")):
        walkVel.y += -walkSpeed
    if(Input.is_action_pressed("MOVE_DOWN")):
        walkVel.y += walkSpeed

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
    
    elif (currentState == State.NORMAL) and Input.is_action_just_pressed("RANGED_ATTACK") and rangedAttackCooldown <= 0:
        walkVel.x = 0
        walkVel.y = 0
        
        var clickPos : Vector2 = get_global_mouse_position()
        var projectileMotion : Vector2 = (clickPos - global_position).normalized()
        
        var projectile_test = player_projectile.instance();
        get_parent().add_child(projectile_test);
        projectile_test.global_position = global_position;
        projectile_test.direction = projectileMotion;
        projectile_test.speed = PROJECTILE_SPEED;
        projectile_test.damage = 5;
        rangedAttackCooldown = RANGED_ATTACK_COOLDOWN_TIME;
        
    
    if currentState == State.ATTACK:
        for body in slashPivot.get_node("SlashArea").get_overlapping_bodies():
            if body.is_in_group("Enemies"):
                #TODO registers multiple times, need melee damage cooldown for enemies
                body.takeDamage(1)
    
    if currentState == State.NORMAL:
        self.move_and_slide(walkVel)

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
