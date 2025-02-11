#extends Area2D
#
#const RoomTypes = preload("res://Scripts/RoomTypes.gd")
#var cleared: bool = false
#var room_type = RoomTypes.RoomType.REGULAR
#var tile_size: int = 16
#
#signal entered_unclear_room
#
#
#func make_room(_pos: Vector2, _size: Vector2, type):
	#get_parent().position = _pos
	#var s = RectangleShape2D.new()
	#s.extents = _size / 2
	#$CollisionShape2D.shape = s
	#$CollisionShape2D.position = s.extents
	#room_type = type
	#var size = (s.extents / tile_size)
	#
	##var top_left = Map.local_to_map(position)  # Przeliczanie światowej pozycji pokoju na siatkę TileMap
	##for x in range(0, size.x * 2):
		##for y in range(0, size.y * 2):
			##var tile_pos = Vector2i(top_left.x + x, top_left.y + y)
##
			##if x == 0 or x == size.x * 2 - 1 or y == 0 or y == size.y * 2 - 1:
				##Map.set_cell(0, tile_pos, 0, Vector2i(0, 0), 0)
			##else:
				##Map.set_cell(0, tile_pos, 1, Vector2i(0, 0), 0)
#
#
#func _on_body_entered(body):
	#if body.name == "Player":
		#match room_type:
			#RoomTypes.RoomType.REGULAR:
				#if cleared:
					#return
				#close_room()
				#spawn_enemies()
			#RoomTypes.RoomType.TREASURE:
				#print("Entered treasure room")
			#RoomTypes.RoomType.START:
				#print("Entered start room")
			#RoomTypes.RoomType.END:
				#print("Entered end room")
				#if cleared:
					#return
				#close_room()
				#spawn_boss()
#
#
#func _on_body_exited(body):
	#pass
#
#
#func set_room_type(type):
	#room_type = type
#
#
#func set_cleared(value: bool):
	#cleared = value
#
#
#func close_room():
	#var size = (get_child(0).shape.extents / tile_size) * 2
	#var upper_left = Vector2(position.x - size.x / 2, position.y - size.y / 2)
	#var upper_right = Vector2(position.x + size.x / 2, position.y - size.y / 2)
	#var bottom_left = Vector2(position.x - size.x / 2, position.y + size.y /2)
	#var bottom_right = Vector2(position.x + size.x / 2, position.y + size.y / 2)
	## Przejście po górnej krawędzi (od upper_left do upper_right)
	##for x in range(int(upper_left.x), int(upper_right.x) + 1):
		##var current_position = Vector2i(x, upper_left.y)
		##var current_tile = Map.get_cell_source_id(0, current_position)
		##if current_tile == 1:
			##Map.set_cell(3, current_position, 0, Vector2i(0, 0), 0)
#
	## Przejście po prawej krawędzi (od upper_right do bottom_right)
	#for y in range(int(upper_right.y) + 1, int(bottom_right.y) + 1):
		#print(Vector2(upper_right.x, y))
#
	## Przejście po dolnej krawędzi (od bottom_right do bottom_left)
	#for x in range(int(bottom_right.x) - 1, int(bottom_left.x) - 1, -1):
		#print(Vector2(x, bottom_right.y))
#
	## Przejście po lewej krawędzi (od bottom_left do upper_left)
	#for y in range(int(bottom_left.y) - 1, int(upper_left.y), -1):
		#print(Vector2(bottom_left.x, y))
#
#
#func open_room():
	#print("Opening room")
#
#
#func spawn_player():
	#print("Spawning player")
#
#
#func spawn_enemies():
	#print("Spawning enemies")
#
#
#func spawn_reward():
	#print("Spawning reward")
#
#
#func spawn_boss():
	#print("Spawning boss")
