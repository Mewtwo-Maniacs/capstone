extends Area2D

var active = false

func _ready():
	connect("body_entered", self, '_on_ZacPortal_body_entered')
	connect("body_exited", self, '_on_ZacPortal_body_exited')
	
func _input(event):
	if event.is_action_pressed("ui_yeet") and active:
		get_tree().change_scene("res://scenes/Worlds/ZachOffice.tscn")
		

func _on_ZacPortal_body_entered(body):
	#label pops up that says "Press 'E' to Teleport
	if body.name == 'Player':
		$zacDetection.text = "Press 'E' to Teleport"
		active = true

func _on_ZacPortal_body_exited(body):
	if body.name == 'Player':
		active = false
		$zacDetection.text = ""
