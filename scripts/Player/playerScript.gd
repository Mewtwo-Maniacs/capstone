extends KinematicBody2D

onready var stats = $PlayerStats
onready var label = $HealthUI/Label
onready var playerHurtBox = $HurtBox
export(int) var speed = 115
enum {
	MOVE,
	ROLL,
	ATTACK,
	DEATH
}

func _ready():
	label.text = "HP: " + str(stats.health)
	$AnimationTree.active = true

var state = MOVE
var velocity
func move_state():
	velocity = Vector2.ZERO
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
	move_and_slide(velocity * 200)
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

func _on_HurtBox_area_entered(area):
	stats.health -= EnemyStats.MELEE_ATTACK
	playerHurtBox.is_overlapping(0.5)
	if stats.health == 0:
		$Node/Death.play()
		state = DEATH
		stats.health -= 1
		

func _on_PlayerStats_no_health():
	label.text = "You Have Died!"

var hurtCount = 0
func _on_PlayerStats_update_health():
	hurtCount += 1
	if(hurtCount % 2 == 0):
		$Node/Damaged2.play()
	elif(hurtCount % 3 == 0):
		$Node/Damaged3.play()
	else: $Node/Damaged.play()
	label.text = "HP: " + str(stats.health)
	
var SoundArray = [$Node/Damaged, $Node/Damaged2, $Node/Damaged3]


func _on_SwordHitbox_area_entered(area):
	pass # Replace with function body.

#TopTeleport in HomeBase
func _on_TopTele_area_entered(area):
	get_tree().change_scene("res://scenes/Worlds/Level1.tscn")

#BottomTeleport in HomeBase
func _on_BotTele_area_entered(area):
	get_tree().change_scene("res://scenes/Worlds/HomeBase.tscn")

#MainDoor teleport in HomeBase
func _on_MainDoor_area_entered(area):
	get_tree().change_scene("res://scenes/main.tscn")


