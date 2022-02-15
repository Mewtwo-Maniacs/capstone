extends Node
export(int) var attackPower = 10
export(int) var MAX_HEALTH = 10
onready var health = MAX_HEALTH setget set_health
var level = 1

signal no_health
signal update_health
signal leveled_up
signal gain_xp

func set_health(value):
	health = value
	if health <= 0: 
		emit_signal("no_health")
	else:
		emit_signal("update_health")


var current_experience = 0
var experience_total = 0
var experience_required = get_required_experience(level)

func get_required_experience(level):
	return round(pow(level, 1.8) + level * 4)

func gain_experience(amount):
	experience_total += amount
	current_experience += amount
	emit_signal("gain_xp")
	while current_experience >= experience_required:
		current_experience -= experience_required
		level_up()
func get_current_xp():
	return current_experience
	

func level_up():
	emit_signal("leveled_up")
	level += 1
	attackPower += 2
	health = MAX_HEALTH
	experience_required = get_required_experience(level + 1)


func _on_BigDemonFAST_leveler():
	gain_experience(10)
func _on_BigDemonFAST2_leveler():
	gain_experience(10)
func _on_BigDemonFAST3_leveler():
	gain_experience(10)
func _on_BigDemonFAST4_leveler():
	gain_experience(10)
func _on_BigDemonFAST5_leveler():
	gain_experience(10)
func _on_BigDemon2SLOWER_leveler():
	gain_experience(10)
func _on_BigDemon2SLOWER2_leveler():
	gain_experience(10)
func _on_BigDemon3_leveler():
	gain_experience(10)
func _on_BigDemon4_leveler():
	gain_experience(10)
func _on_BigDemon_leveler():
	gain_experience(10)
func _on_BigDemon7_leveler():
	gain_experience(10)
func _on_BigDemon6_leveler():
	gain_experience(10)
func _on_BigDemon5_leveler():
	gain_experience(10)
func _on_BigDemon2_leveler():
	gain_experience(10)
func _on_BossDemon_leveler():
	gain_experience(500)
