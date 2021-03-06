extends Node

export(int) var MAX_HEALTH = 100
export(int) var MELEE_ATTACK = 1 

onready var health = MAX_HEALTH setget set_health

var stats = { 
	MAX_HEALTH: MAX_HEALTH,
	MELEE_ATTACK: MELEE_ATTACK
}

var difficulty = NIGHTMARE
enum {
	EASY, 
	MEDIUM,
	HARD,
	NIGHTMARE
}

signal no_health
signal update_health
	
func set_health(value):
	health = value
	if health <= 0: 
		emit_signal("no_health")
	else:
		emit_signal("update_health")
		

# warning-ignore:shadowed_variable
func select_difficulty(difficulty): 
	print('inside select diff')
	match difficulty: 
		
		EASY:
			for stat in stats.values():
				stat = stat / 2
				
		MEDIUM: 
			print('set to medium')
			pass
			
		HARD: 
			for stat in stats.values():
				stat = stat * 3
				
		NIGHTMARE:
			print ('set to nightmare')
			for stat in stats.values():
				stat = stat * 6
