extends CharacterBody2D

@export var MAX_SPEED = 40
@onready var health_component: HealthComponent = $HealthComponent
@onready var BasicEnemyDirection = $BasicEnemyMovement

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var direction = get_direction_to_player()
	velocity = direction * MAX_SPEED
	move_and_slide()

	var move_sign = sign(velocity.x)
	if move_sign != 0:
		BasicEnemyDirection = Vector2(move_sign, 1)

func get_direction_to_player():
	var player_nodes = get_tree().get_first_node_in_group("player") as Node2D
	if player_nodes != null:
		return (player_nodes.global_position - global_position).normalized()
	return Vector2.ZERO