extends KinematicBody2D

onready var stats = $PlayerStats
onready var label = $HealthUI/Label
onready var playerHurtBox = $HurtBox
onready var hpBar = $HUD/HealthBar
onready var hpBarCurrentValue = $HUD/CurrentHealth
onready var hpBarMaxHealthValue = $HUD/MaxHealth
onready var level_label = $HUD/Level
onready var xpBar = $HUD/EXPBar
export(int) var speed = 115
var state = MOVE
var velocity

enum {
	MOVE,
	ROLL,
	ATTACK,
	DEATH
}

func _ready():
	level_label.text = str(PlayerStats.level)
	xpBar.value = 0
	hpBar.value = PlayerStats.health
	hpBar.max_value = PlayerStats.health
	hpBarCurrentValue.text = str(PlayerStats.health)
	hpBarMaxHealthValue.text = str(PlayerStats.MAX_HEALTH)
	label.text = "HP: " + str(PlayerStats.health)
	$AnimationTree.active = true
	$deadbutton.hide()

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
		$Node/Attack.play()
		state = ATTACK
	if Input.is_action_just_pressed("roll"):
		state = ROLL
	if Input.is_action_just_pressed("death"):
		state = DEATH

func attack_state():
	if stats.health > 0:
		$AnimationTree.get("parameters/playback").travel("Attack")
	else:
		state = DEATH

func roll_state():
	move_and_slide(velocity * 180)
	$AnimationTree.get("parameters/playback").travel("Roll")

func death_state():
	$AnimationTree.get("parameters/playback").travel("Death")
	$deadbutton.show()

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
	hpBar.value = 0
	hpBarCurrentValue.text = "0"

var hurtCount = 0
func _on_PlayerStats_update_health():
	hurtCount += 1
	if(hurtCount % 2 == 0):
		$Node/Damaged2.play()
	elif(hurtCount % 3 == 0):
		$Node/Damaged3.play()
	else: $Node/Damaged.play()
	label.text = "HP: " + str(stats.health)
	hpBarCurrentValue.text = str(stats.health)
	hpBar.value = stats.health
	

#MainDoor teleport in HomeBase
func _on_MainDoor_area_entered(area):
	get_tree().change_scene("res://scenes/Worlds/Level1.tscn")

func _on_deadbutton_button_up():
	_ready()
	get_tree().change_scene("res://scenes/Worlds/HomeBase.tscn")

var level = 1
func _on_PlayerStats_gain_xp():
	var currentXp = PlayerStats.get_current_xp() + 1
	var xpToLevel = PlayerStats.get_required_experience(level) 
	var currentProg = (currentXp / xpToLevel) * 100
	xpBar.value = currentProg + 20

func _on_PlayerStats_leveled_up():
	if($Node/AudioStreamPlayer):
		var music_pos = $Node/AudioStreamPlayer.get_playback_position()
		$Node/AudioStreamPlayer.stop()
		$Node/LevelUp.play()
		yield(get_tree().create_timer(1.8), "timeout")
		$Node/AudioStreamPlayer.play()
	
	PlayerStats.level += 1
	PlayerStats.attackPower += 2

	PlayerStats.MAX_HEALTH += 1
	stats.health = PlayerStats.MAX_HEALTH
	hpBarMaxHealthValue.text = str(PlayerStats.MAX_HEALTH)
	level_label.text = str(PlayerStats.level)

func _on_ZachOfficeDoor_area_entered(area):
	get_tree().change_scene("res://scenes/Worlds/HomeBase.tscn")

