extends Control


func _ready():
	$easylabel.hide()
	$godlabel.hide()
	$hardlabel.hide()
	$mediumlabel.hide()




func _on_mediumbutton_button_up():
	$easylabel.hide()
	$godlabel.hide()
	$hardlabel.hide()
	$mediumlabel.show()


func _on_easybutton_button_up():
	$mediumlabel.hide()
	$godlabel.hide()
	$hardlabel.hide()
	$easylabel.show()


func _on_hardbutton_button_up():
	$easylabel.hide()
	$godlabel.hide()
	$mediumlabel.hide()
	$hardlabel.show()

func _on_godmodebutton_button_up():
	$easylabel.hide()
	$mediumlabel.hide()
	$hardlabel.hide()
	$godlabel.show()


func _on_Button_button_up():
	get_tree().change_scene("res://scenes/TitleScreen.tscn")
