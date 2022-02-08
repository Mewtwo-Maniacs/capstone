extends RigidBody2D

var roomWidth = 1
var roomHeight
var roomCount

var TREASURE_ROOM = {
	roomWidth: 1,
	roomHeight: 1,
	roomCount: rand_range(2, 4)
}

var BOSS_ROOM = {
	roomWidth: 1,
	roomHeight: 1,
	roomCount: 1,
}

var MOB_ROOM = {
	roomWidth: 1,
	roomHeight: 1,
	roomCount: rand_range(4, 6)
}

var room_types = [
	TREASURE_ROOM,
	BOSS_ROOM,
	MOB_ROOM
]

func make_room(_pos, _size, _type):
	position = _pos
	var room = RectangleShape2D.new()
	room.extents = _size
	$CollisionShape2D.shape = room

