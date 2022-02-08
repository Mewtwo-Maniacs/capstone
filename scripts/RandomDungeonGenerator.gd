extends Node2D

var Rooms = preload("res://scenes/RDG_Room.tscn")
var roomTiles = preload("res://scenes/Worlds/DungeonGenRoomAutotiles.tres")
var player = preload("res://scenes/Player/player.tscn")
onready var dungeonBase = $Base
var instancedPlayer

#var roomList = ["TREASURE_ROOM", "BOSS_ROOM", "MOB_ROOM", "SPAWN_ROOM"]
#var outerBorder = Rect2(1, 1, 180, 108)
var roomWidth = 4
var roomHeight = 10
var tileSize = 16
var roomScaling = 1
var roomPositions = []
var shuffledRooms = []
var dungeonCreationOrigin = Vector2(350, 200)
var roomCount = 10
var path
var dungeonSeed
var spawnRoom
var endRoom

var room_types = {
	"TREASURE_ROOM": {
		"roomWidth": 4,
		"roomHeight": 8,
		"roomCount": 2
	},
	"BOSS_ROOM": {
		"roomWidth": 10,
		"roomHeight": 15,
		"roomCount": 1
	},
	"MOB_ROOM": {
		"roomWidth": 8,
		"roomHeight": 10,
		"roomCount": 6
	},
	"SPAWN_ROOM": {
		"roomWidth": 4,
		"roomHeight": 8,
		"roomCount": 1
	}
}

func _ready():
	randomize()
	make_rooms()

func _process(_delta):
	update()

func make_rooms(): 
#	Get an array of all the total number of rooms in a single array
	shuffledRooms = shuffle_rooms(room_types)
#	Loop through array of rooms and instance each one
	for _i in range(roomCount):
		if shuffledRooms.size() > 0:
			var room = shuffledRooms[randomNumber(0, shuffledRooms.size() - 1)]
			var pos = dungeonCreationOrigin
			var roomInstance = Rooms.instance()
			if room == "SPAWN_ROOM":
				spawnRoom = roomInstance
			elif room == "BOSS_ROOM":
				endRoom = roomInstance
			var w = room_types[room]["roomWidth"] + randi() % (room_types[room]["roomHeight"] - room_types[room]["roomWidth"])
			var h = room_types[room]["roomWidth"] + randi() % (room_types[room]["roomHeight"] - room_types[room]["roomWidth"])
			roomInstance.make_room(pos, Vector2(w * roomScaling, h * roomScaling) * tileSize)
			
			$AllRooms.add_child(roomInstance)
			shuffledRooms.erase(room)

# 	To add space between rooms we take rooms and then resize them down after waiting for rooms to stop moving
	yield(get_tree().create_timer(0.2), "timeout")
	resize_rooms()

#Get a random number (Used with shuffle_rooms to create a pseudorandom generation of rooms
func randomNumber(min_range, max_range):
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var num = rng.randi_range(min_range, max_range)
	return num

#Adds all the items from a dictionary into an array 
func shuffle_rooms(list):
	var combinedArr = []
	for item in list: 
		var roomCount = list[item]["roomCount"]
		var listItem = item
		for j in roomCount:
			combinedArr.push_back(listItem)

	return combinedArr

#Scales down the rooms to create spaces between them for hallways
func resize_rooms():
	for child in $AllRooms.get_children():

#		Scale the child down by 1.5
		child.size = child.size / 1.5

#		Turn the child node into a static body to prevent any further moving
		child.mode = RigidBody2D.MODE_STATIC
		
		if child.name == spawnRoom.name:
			spawnRoom = child
		
		roomPositions.append(Vector3(child.position.x, child.position.y, 0))
	
	path = find_mst(roomPositions)
	yield(get_tree().create_timer(1), "timeout")
	make_map()
	
func find_mst(nodes):
	var path = AStar.new()
	path.add_point(path.get_available_point_id(), nodes.pop_front())
	for _i in range(nodes.size()):
		var min_dist = INF
		var min_pos = null
		var point = null
		
		for point1 in path.get_points():
			point1 = path.get_point_position(point1)
			for point2 in nodes:
				# If the node is closer, make it the closest
				if point1.distance_to(point2) < min_dist:
					min_dist = point1.distance_to(point2)
					min_pos = point2
					point = point1
					
		var n = path.get_available_point_id()
		path.add_point(n, min_pos)
		path.connect_points(path.get_closest_point(point), n)
		# Remove the node from the array so we don't visit again
		nodes.erase(min_pos)
	return path

func make_map():
	dungeonBase.clear()
	var corridors = []
	for room in $AllRooms.get_children():
		var s = ((room.size*1.7) / tileSize ).floor()
		var pos = dungeonBase.world_to_map(room.position)
		var ul = (room.position / tileSize).floor() - s
		for x in range(2, (s.x * 2) - 2):
			for y in range(2, (s.y * 2) - 2):
				dungeonBase.set_cell(ul.x + x, ul.y + y, 13, false, false, false, Vector2(pos))
		
		var p = path.get_closest_point(Vector3(room.position.x, room.position.y, 0))
		for connection in path.get_point_connections(p):
			if not connection in corridors:
				var start = dungeonBase.world_to_map(Vector2(path.get_point_position(p).x, path.get_point_position(p).y))
				var end = dungeonBase.world_to_map(Vector2(path.get_point_position(connection).x, path.get_point_position(connection).y))
				make_hallway(start, end)
		corridors.append(p)
	
	dungeonBase.update_bitmask_region()
	dungeonBase.update_dirty_quadrants()
	disable_room_collision()
	yield(get_tree().create_timer(0.2), "timeout")
	spawn_player()
	

func make_hallway(pos1, pos2):
	var x_diff = sign(pos2.x - pos1.x)
	var y_diff = sign(pos2.y - pos1.y)
	if x_diff == 0: x_diff = pow(-1.0, randi() % 3)
	if y_diff == 0: y_diff = pow(-1.0, randi() % 3)
	var x_y = pos1
	var y_x = pos2
	
	if (randi() % 2) > 0:
		x_y = pos2
		y_x = pos1
		
	for x in range(pos1.x, pos2.x, x_diff):
		dungeonBase.set_cell(x, x_y.y, 13, false, false, false, Vector2(x, x_y.y))
		dungeonBase.set_cell(x, x_y.y + y_diff, 13, false, false, false, Vector2(x, x_y.y))
		dungeonBase.set_cell(x, (x_y.y + y_diff) + y_diff, 13, false, false, false, Vector2(x, x_y.y))
	for y in range(pos1.y, pos2.y, y_diff):
		dungeonBase.set_cell(y_x.x, y, 13, false, false, false, Vector2(y_x.x, y))
		dungeonBase.set_cell(y_x.x + x_diff, y, 13, false, false, false, Vector2(y_x.x, y))
		dungeonBase.set_cell((y_x.x + x_diff) + x_diff, y, 13, false, false, false, Vector2(y_x.x, y))

# Disables room collision so entities can be spawned inside the rooms
func disable_room_collision():
	for room in $AllRooms.get_children():
		var roomCollision = room.get_child(0)
		roomCollision.disabled = true

# Spawns the player 
func spawn_player():
	var playerCamera = Camera2D.new()
	instancedPlayer = player.instance()
	instancedPlayer.add_child(playerCamera)
	playerCamera.current = true
	get_tree().get_current_scene().add_child(instancedPlayer)
	instancedPlayer.position = spawnRoom.position
	instancedPlayer.scale.x = 0.75
	instancedPlayer.scale.y = 0.75

func spawn_enemies():
	pass

func save_seed():
	pass

#Allows for space to be pressed for re-generating of rooms: Uncomment _input() and _draw() for debug features
func _input(event):
	if event.is_action_pressed('ui_select'):
		for n in $AllRooms.get_children():
			n.queue_free()
		path = null
		make_rooms()
		dungeonBase.clear()
		instancedPlayer.queue_free()


#Draws the outlines of rooms & paths
#func _draw():
##	Create room outline	
#	for room in $AllRooms.get_children():
#		draw_rect(Rect2(room.position - room.size, room.size * 2), Color(32, 228, 0), false)
#
#	if spawnRoom: 
#		draw_rect(Rect2(spawnRoom.position - spawnRoom.size, spawnRoom.size * 2), Color(228, 0, 0), false)
#	if endRoom: 
#		draw_rect(Rect2(endRoom.position - endRoom.size, endRoom.size * 2), Color(0, 0, 228), false)
#
## 	Create path outline	
#	if path:
#		for point in path.get_points():
#			for connection in path.get_point_connections(point):
#				var currPoint = path.get_point_position(point)
#				var connPoint = path.get_point_position(connection)
#				draw_line(Vector2(currPoint.x, currPoint.y), Vector2(connPoint.x, connPoint.y),
#						  Color(1, 1, 0), 5, true)
