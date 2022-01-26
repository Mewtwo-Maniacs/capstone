extends KinematicBody2D

export(int) var speed = 115.0

enum {
	MOVE,
	ROLL,
	ATTACK,
	DEATH
}

func _ready():
	$AnimationTree.active = true

var state = MOVE

func move_state():
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("right"):
		velocity.x += 1.0
	if Input.is_action_pressed("left"):
		velocity.x -= 1.0
	if Input.is_action_pressed("up"):
		velocity.y -= 1.0
	if Input.is_action_pressed("down"):
		velocity.y += 1.0
		
	velocity = velocity.normalized()
	
	if velocity == Vector2.ZERO:
		$AnimationTree.get("parameters/playback").travel("Idle")
	else:
		$AnimationTree.get("parameters/playback").travel("Walk")
		$AnimationTree.set("parameters/Idle/blend_position", velocity)
		$AnimationTree.set("parameters/Walk/blend_position", velocity)
		$AnimationTree.set("parameters/Attack/blend_position", velocity)
		$AnimationTree.set("parameters/Roll/blend_position", velocity)
	
	move_and_slide(velocity * speed)
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
	if Input.is_action_just_pressed("roll"):
		state = ROLL
	if Input.is_action_just_pressed("death"):
		state = DEATH

func attack_state():
	$AnimationTree.get("parameters/playback").travel("Attack")

func roll_state():
	$AnimationTree.get("parameters/playback").travel("Roll")

func death_state():
	$AnimationTree.get("parameters/playback").travel("Death")

func attack_animation_finished():
	state = MOVE
func roll_animation_finished():
	state = MOVE

func _physics_process(delta):
	match state:
		MOVE:
			move_state()
		ROLL:
			roll_state()
		ATTACK:
			attack_state()
		DEATH:
			death_state()






""" 
# OLD MOVEMENT CODE
var velocity : Vector2 = Vector2()
var direction : Vector2 = Vector2()

func read_input():
	velocity = Vector2()
		
	if Input.is_action_pressed("up"):
		velocity.y -= 1
		direction = Vector2(0, -1)
		
	if Input.is_action_pressed("down"):
		velocity.y += 1
		direction = Vector2(0, 1)
		
	if Input.is_action_pressed("left"):
		velocity.x -= 1
		direction = Vector2(-1, 0)
		
	if Input.is_action_pressed("right"):
		velocity.x += 1
		direction = Vector2(1, 0)
	
	velocity = velocity.normalized()
	velocity = move_and_slide(velocity * 200)

func _physics_process(_delta):
	read_input()
	
"""
