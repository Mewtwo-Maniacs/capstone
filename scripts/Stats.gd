extends Node

export(int) var MAX_HEALTH = 3
onready var health = MAX_HEALTH setget set_health

signal no_health
signal update_health

func set_health(value):
	health = value
	if health <= 0: 
		emit_signal("no_health")
	else:
		emit_signal("update_health")
