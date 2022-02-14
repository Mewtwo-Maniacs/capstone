extends Control

onready var level_label = $Level
var level = 1
"""
# Called when the node enters the scene tree for the first time.
func _ready():
	level_label.text = "1"

func _on_PlayerStats_leveled_up():
	print('received signal')
	level += 1
	level_label.text = str(level)
"""
