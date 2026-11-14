extends Node2D

@export var spawns: Array[SpawnInfo] = []

@onready var player = get_tree().get_first_node_in_group("player")

var time = 0


func _ready() -> void:
	for spawn in spawns:
		_schedule_wave(spawn)

func _schedule_wave(spawn: SpawnInfo) -> void:
	var wave_timer = Timer.new()
	wave_timer.wait_time = max(spawn.enemy_spawn_delay, 0.1)
	wave_timer.one_shot = false
	
	wave_timer.timeout.connect(_on_wave_timer_timeout.bind(spawn))
	add_child(wave_timer)
	
	if spawn.time_start <= 0:
		wave_timer.start()
	else:
		get_tree().create_timer(spawn.time_start, false).timeout.connect(wave_timer.start)

	if spawn.time_end > spawn.time_start:
		get_tree().create_timer(spawn.time_end, false).timeout.connect(_stop_wave_timer.bind(wave_timer))
	

func _on_wave_timer_timeout(spawn: SpawnInfo):
	for i in range(spawn.enemy_num):
		var new_enemy = spawn.enemy.instantiate()
		new_enemy.global_position = get_random_position()
		add_child(new_enemy)
		
func _stop_wave_timer(wave_timer: Timer) -> void:
	if is_instance_valid(wave_timer):
		wave_timer.stop()
		wave_timer.queue_free()


# Implementação antiga seguindo o tutorial (Deixei aqui pra poder testar a perfomance depois)
#func _on_timer_timeout() -> void:
	#time += 1
	#for spawn in spawns:
		#if time >= spawn.time_start and time <= spawn.time_end:
			#if spawn.spawn_delay_counter < spawn.enemy_spawn_delay:
				#spawn.spawn_delay_counter += 1
			#else:
				#spawn.spawn_delay_counter = 0
				#var counter = 0
				#while counter < spawn.enemy_num:
					#var new_enemy = spawn.enemy.instantiate()
					#new_enemy.global_position = get_random_position()
					#add_child(new_enemy)
					#counter += 1
					
func get_random_position() -> Vector2:
	var corners_vectors = _get_player_view_corners()
	var pos_direction = ["up", "down", "left", "right"].pick_random()
	var spawn_posA = Vector2.ZERO
	var spawn_posB = Vector2.ZERO
	
	match pos_direction:
		"up":
			spawn_posA = corners_vectors["top_left"]
			spawn_posB = corners_vectors["top_right"]
		"down":
			spawn_posA = corners_vectors["bottom_left"]
			spawn_posB = corners_vectors["bottom_right"]
		"left":
			spawn_posA = corners_vectors["top_left"]
			spawn_posB = corners_vectors["bottom_left"]
		"right":
			spawn_posA = corners_vectors["top_right"]
			spawn_posB = corners_vectors["bottom_right"]
		
	var x_spawn = randf_range(spawn_posA.x, spawn_posB.x)
	var y_spawn = randf_range(spawn_posA.y, spawn_posB.y)
	
	return Vector2(x_spawn, y_spawn)
	
	
	
func _get_player_view_corners():
	var vpr = get_viewport_rect().size * randf_range(1.1, 1.4)
	var pgp = player.global_position
	var corners_vectors: Dictionary[String, Vector2] = {
		"top_left": Vector2(pgp.x - vpr.x/2, pgp.y - vpr.y/2),
		"top_right": Vector2(pgp.x + vpr.x/2, pgp.y - vpr.y/2),
		"bottom_left": Vector2(pgp.x - vpr.x/2, pgp.y + vpr.y/2),
		"bottom_right": Vector2(pgp.x + vpr.x/2, pgp.y + vpr.y/2),
	}
	
	return corners_vectors
	
