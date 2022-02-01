extends Area2D

onready var timer = $Timer

func hit_effect():
	pass
	
func is_overlapping(duration):
	print("Timer started")
	timer.start(duration)
	set_deferred("monitoring", false)

func _on_Timer_timeout():
	set_deferred("monitoring", true)
	if get_overlapping_areas(): 
		is_overlapping(0.5)
	else:
		return
