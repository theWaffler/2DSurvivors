extends Node

@export var SPAW_RADIUS = 330

@export var basic_enemy_scene: PackedScene
@export var arena_time_manager: Node
@onready var timer = $Timer

var base_spawn_time = 0

func _ready():
	base_spawn_time = timer.wait_time
	timer.timeout.connect(on_timer_timeout)
	arena_time_manager.arena_difficulty_increased.connect(on_arena_difficulty_increase)


func on_timer_timeout():
	timer.start()
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	var random_direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	var spawn_position = player.global_position + (random_direction  * SPAW_RADIUS)

	var enemy = basic_enemy_scene.instantiate() as Node2D

	var entities_layer = get_tree().get_first_node_in_group("entities_layer")

	if entities_layer == null:
		return
	
	entities_layer.add_child(enemy)
	enemy.global_position = spawn_position

func on_arena_difficulty_increase(arena_difficulty: int):
	var time_off = (0.1/12) * arena_difficulty

	time_off = min(time_off, 0.7)
	#debug
	print("Time off: " + str(time_off))

	timer.wait_time = base_spawn_time - time_off
