extends RigidBody2D

func make_room(_pos, _size):
	position = _pos
	var room = RectangleShape2D.new()
	room.custom_solver_bias = 0.75
	room.extents = _size
	$CollisionShape2D.shape = room
