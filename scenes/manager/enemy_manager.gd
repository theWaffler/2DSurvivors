extends Node

@export var SPAW_RADIUS = 330

@export var basic_enemy_scene: PackedScene
@export var piggy_enemy_scene:PackedScene
@export var arena_time_manager: Node
@onready var timer = $Timer

var base_spawn_time = 0
var enemy_table = WeightedTable.new()

func _ready():

	enemy_table.add_item(basic_enemy_scene, 10)

	base_spawn_time = timer.wait_time
	timer.timeout.connect(on_timer_timeout)
	arena_time_manager.arena_difficulty_increased.connect(on_arena_difficulty_increase)

func get_spawn_position():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return Vector2.ZERO

	var spawn_position = Vector2.ZERO # initialize to 0
	var random_direction = Vector2.RIGHT.rotated(randf_range(0, TAU)) # set random position

	# not inclusive. max value is 3
	for i in 4:
		spawn_position = player.global_position + (random_direction  * SPAW_RADIUS)

		var query_paramaters = PhysicsRayQueryParameters2D.create(player.global_position,spawn_position, 1 << 0) # 1 << 19 so you don't have to type in the value at layer 20. use 1 as ref and shift 19x
		var results = get_tree().root.world_2d.direct_space_state.intersect_ray(query_paramaters)

		if results.is_empty(): #since insertsect ray returns empty dictionary 
			# we are clear
			break
		else:
			#change direction
			random_direction = random_direction.rotated(deg_to_rad(90))

	return spawn_position


func on_timer_timeout():
	timer.start()
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return

	
	var enemy_scene = enemy_table.pick_item()
	var enemy = enemy_scene.instantiate() as Node2D

	var entities_layer = get_tree().get_first_node_in_group("entities_layer")

	if entities_layer == null:
		return
	
	entities_layer.add_child(enemy)
	enemy.global_position = get_spawn_position()

func on_arena_difficulty_increase(arena_difficulty: int):
	var time_off = (0.1/12) * arena_difficulty

	time_off = min(time_off, 0.7)
	#debug
	print("Time off: " + str(time_off))
	timer.wait_time = base_spawn_time - time_off

	if arena_difficulty == 2: # 30 seconds (1 = 5sec)
		enemy_table.add_item(piggy_enemy_scene, 20)
	#elif arena_difficulty == 12: # one minute
	#	pass # add another enemy type
