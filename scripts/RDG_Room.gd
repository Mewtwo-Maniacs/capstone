extends RigidBody2D

var size 

func make_room(_pos, _size):
	position = _pos
	size = _size
	var room = RectangleShape2D.new()
	room.extents = size
	$CollisionShape2D.shape = room

