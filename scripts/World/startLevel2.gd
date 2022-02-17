extends Area2D

var active = true

func _ready():
	if get_node_or_null('DialogNode') == null:
		if active:
			get_tree().paused = true
			var dialog = Dialogic.start('zachLevel2')
			dialog.pause_mode = Node.PAUSE_MODE_PROCESS
			dialog.connect('timeline_end', self, 'unpause')
			add_child(dialog)
			active = false

func unpause(timeline_name):
	get_tree().paused = false

