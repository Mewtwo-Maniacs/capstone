extends Node2D
	
var playerCamera = Camera2D.new()
var world = preload("res://scenes/Worlds/testDung.tscn").instance()
var player = preload("res://scenes/Player/player.tscn").instance()
var enemy = preload("res://scenes/Enemies/BigDemon.tscn").instance()

func _ready():
	add_child(world)
	add_child(player)
	add_child(enemy)

	player.add_child(playerCamera)
	playerCamera.make_current()
