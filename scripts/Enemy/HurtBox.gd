extends Area2D

onready var timer = $Timer
var check_overlapping = get_overlapping_areas()

func hit_effect():
	pass
	
func is_overlapping(duration):
	timer.start(duration)
	set_deferred("monitoring", false)

func _on_Timer_timeout():
	set_deferred("monitoring", true)
	if check_overlapping: 
		is_overlapping(0.5)
	else:
		return
