extends Area2D

var active = false

func _ready():
	connect("body_entered", self, '_on_BotTele_body_entered')
	connect("body_exited", self, '_on_BotTele_body_exited')
	
func _input(event):
	if event.is_action_pressed("ui_yeet") and active:
		get_tree().change_scene("res://scenes/Worlds/HomeBase.tscn")
		print ("E was pressed")

func _on_BotTele_body_entered(body):
	#label pops up that says "Press 'E' to Teleport
	if body.name == 'Player':
		$botTele2.text = "Press 'E' to Teleport"
		active = true

func _on_BotTele_body_exited(body):
	if body.name == 'Player':
		active = false
		$botTele2.text = ""
		
