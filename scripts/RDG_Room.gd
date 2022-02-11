extends RigidBody2D

var size 

func make_room(_pos, _size):
	position = _pos
	size = _size
	var room = RectangleShape2D.new()
	room.custom_solver_bias = 0.75
	room.extents = _size
	$CollisionShape2D.shape = room
