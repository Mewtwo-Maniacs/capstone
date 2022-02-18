extends Area2D

var active = false

func _ready():
	connect("body_entered", self, '_on_BossEndTele_body_entered')
	connect("body_exited", self, '_on_BossEndTele_body_exited')
	
var count = 0
func _input(event):
	if event.is_action_pressed("ui_yeet") and active:
		if(count == 0):
			count += 1
			get_tree().paused = true
			var dialog = Dialogic.start('endOfBossFight')
			dialog.pause_mode = Node.PAUSE_MODE_PROCESS
			dialog.connect('timeline_end', self, 'unpause')
			add_child(dialog)
		elif(count == 1):
			get_tree().change_scene("res://scenes/Worlds/HomeBase.tscn")
			print ("count = 1")

func unpause(timeline_name):
	get_tree().paused = false


func _on_BossEndTele_body_entered(body):
	if body.name == 'Player':
		$bossTeleLabel.text ="'E'"
		active = true

func _on_BossEndTele_body_exited(body):
	if body.name == 'Player':
		active = false
		$bossTeleLabel.text = ""
		

