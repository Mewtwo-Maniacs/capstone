extends Area2D

var active = false

func _ready():
	connect("body_entered", self, '_on_EndTele_body_entered')
	connect("body_exited", self, '_on_EndTele_body_exited')
	
func _input(event):
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_E and active:
			get_tree().change_scene("res://scenes/DungeonGenerator.tscn")

func _on_EndTele_body_entered(body):
	if body.name == 'Player':
		active = true

func _on_EndTele_body_exited(body):
	if body.name == 'Player':
		active = false
