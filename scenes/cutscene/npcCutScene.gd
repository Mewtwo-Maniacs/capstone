extends KinematicBody2D


onready var anim = $AnimationPlayer

func _ready() -> void:
	anim.play("idle")

func play_anim(animation_name) -> void:
	anim.play(animation_name)

func stop_anim() -> void:
	anim.stop()
