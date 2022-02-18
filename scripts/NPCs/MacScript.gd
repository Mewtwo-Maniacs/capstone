extends Area2D

var active = false

func _ready():
	connect("body_entered", self, '_on_NPC_body_entered')
	connect("body_exited", self, '_on_NPC_body_exited')

func _process(delta):
	$QuestionMark.visible = false

func _input(event):
	if get_node_or_null('DialogNode') == null:
		if event.is_action_pressed("ui_yeet") and active:
			pass

func unpause(timeline_name):
	get_tree().paused = false

func _on_NPC_body_entered(body):
	if body.name == 'Player':
		active = true


func _on_NPC_body_exited(body):
	if body.name == 'Player':
		active = false
