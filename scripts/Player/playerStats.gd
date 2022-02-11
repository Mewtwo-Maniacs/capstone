extends Node
export var attackPower = 10
export(int) var MAX_HEALTH = 10
onready var health = MAX_HEALTH setget set_health

signal no_health
signal update_health

func set_health(value):
	health = value
	if health <= 0: 
		emit_signal("no_health")
	else:
		emit_signal("update_health")

export(int) var level = 1

var current_experience = 0
var experience_total = 0
var experience_required = get_required_experience(level)

func get_required_experience(level):
	return round(pow(level, 1.8) + level * 4)

func gain_experience(amount):
	experience_total += amount
	current_experience += amount
	while current_experience >= experience_required:
		current_experience -= experience_required
		level_up()

func level_up():
	print('current_level', level)
	level += 1
	attackPower += 5
	health = MAX_HEALTH
	print('after_level_up', level)
	experience_required = get_required_experience(level + 1)
