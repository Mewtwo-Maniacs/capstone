extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$mainMenu/Play.grab_focus()
	
func _on_Play_pressed():
	get_tree().change_scene("res://scenes/UI/Controls.tscn")
func _on_Login_pressed():
	get_tree().change_scene("res://scenes/login.tscn")
func _on_Options_pressed():
	get_tree().change_scene("res://scenes/UI/Controls.tscn")
func _on_Quit_pressed():
	get_tree().quit()
