extends CharacterBody2D

@onready var velocity_component = $VelocityComponent
@onready var piggy_direction = $PiggyEnemyDirection

var is_moving = false


func _process(delta):
	if is_moving:
		velocity_component.acclerate_to_player()
	else:
		velocity_component.deaccelerate()

	velocity_component.move(self)

	var move_sign = sign(velocity.x)
	if move_sign != 0:
		piggy_direction = Vector2(-move_sign, 1)

func set_is_moving(moving: bool):
	is_moving = moving
