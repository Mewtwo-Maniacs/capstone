extends RigidBody2D

func make_room(_pos, _size):
	position = _pos
	var room = RectangleShape2D.new()
	room.extents = _size
	$CollisionShape2D.shape = room
