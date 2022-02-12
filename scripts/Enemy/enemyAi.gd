extends KinematicBody2D

export var ACCELERATION = 300
export var MAX_SPEED = 50
export var FRICTION = 200
export var WANDER_RANGE = 4

var knockback = Vector2.ZERO
var velocity = Vector2.ZERO
signal leveler
enum {
	IDLE, 
	WANDER,
	CHASE
}

var state = IDLE
var playerStats = PlayerStats

onready var playerDetectionZone = $PlayerDetectionZone
onready var sprite = $AnimatedSprite
onready var wanderController = $WanderController
onready var softCollision = $SoftCollision
onready var enemyStats = $Stats
onready var label = $HealthUI/Label
onready var enemyHurtBox = $HurtBox
onready var player_level = get_node("/root/PlayerStats").get("level")

func _ready():
	state = pick_new_state([IDLE, WANDER])
	label.text = "HP: " + str(enemyStats.health)

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	match state: 
		IDLE: 
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
			
			if wanderController.get_time_left() == 0: 
				state = pick_new_state([IDLE, WANDER])
				wanderController.timer_start(rand_range(1, 3))
				
			sprite.animation = "Idle"
		WANDER: 
			seek_player()
			if wanderController.get_time_left() == 0: 
				state = pick_new_state([IDLE, WANDER])
				wanderController.timer_start(rand_range(1, 3))
			
			var direction = global_position.direction_to(wanderController.target_position)
			velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
			sprite.flip_h = velocity.x < 0
			sprite.animation = "Run"
						
			if global_position.distance_to(wanderController.target_position) <= WANDER_RANGE:
				state = pick_new_state([IDLE, WANDER])
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
			
		CHASE:
			var player = playerDetectionZone.player
			if player != null: 
				var direction = global_position.direction_to(player.global_position)
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
			else:
				state = IDLE
			sprite.flip_h = velocity.x < 0
			sprite.animation = "Run"
		
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 400
		
	velocity = move_and_slide(velocity)

func seek_player(): 
	if playerDetectionZone.can_see_player(): 
		state = CHASE
		
func pick_new_state(stateList):
	stateList.shuffle()
	return stateList.pop_front()

func _on_HurtBox_area_entered(area):
	enemyHurtBox.hit_effect()
	enemyStats.health -= playerStats.attackPower
	move_and_slide(-velocity * 50)
	
func _on_Stats_no_health():
	#get_node("/root/PlayerStats").gain_experience(10)
	emit_signal("leveler")
	queue_free()

func _on_Stats_update_health():
	label.text = "HP: " + str(enemyStats.health)

func _on_HitBox_overlapping():
	pass # Replace with function body.
