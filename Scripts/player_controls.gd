extends KinematicBody2D

onready var health = Globals.CURRENT_HEALTH
onready var walkSpeed = 96
onready var walkVel = Vector2()

onready var enemyCount = 0

func _ready():
    pass

func takeDamage(amount):
    health -= amount
    print("Player health: " + str(health))
    if health <= 0:
        health = 0
        #TODO death
        print("Player is dead!")

func _process(delta):
    pass

func _physics_process(delta):
    walkVel.x = 0
    walkVel.y = 0
    
    if(Input.is_action_pressed("MOVE_LEFT")):
        walkVel.x = -walkSpeed
    if(Input.is_action_pressed("MOVE_RIGHT")):
        walkVel.x = walkSpeed
    if(Input.is_action_pressed("MOVE_UP")):
        walkVel.y = -walkSpeed
    if(Input.is_action_pressed("MOVE_DOWN")):
        walkVel.y = walkSpeed
    
    self.move_and_slide(walkVel)

    if Input.is_action_just_pressed("ATTACK"):
        var clickPos = get_global_mouse_position()
        print(clickPos)

func _on_Area2D_body_entered(body):
    if body.is_in_group("Enemies"):
        if enemyCount == 0 and get_node("DamageTimer").is_stopped():
            get_node("DamageTimer").start()
            self.takeDamage(2) #TODO damage amount specific to enemy?
        enemyCount += 1

func _on_Area2D_body_exited(body):
    if body.is_in_group("Enemies"):
        enemyCount -= 1
        if enemyCount == 0:
            get_node("DamageTimer").stop()

func _on_DamageTimer_timeout():
    self.takeDamage(2) #TODO damage amount specific to enemy?
