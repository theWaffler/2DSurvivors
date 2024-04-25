extends Node2D

@export var health_component: Node
@export var sprites: Sprite2D
@onready var gpu = $GPUParticles2D


func _ready():
	gpu.texture = sprites.texture
	health_component.died.connect(on_died)


func on_died():
	if owner == null || not owner is Node2D:
		return

	var spaw_position = owner.global_position

	var entities = get_tree().get_first_node_in_group("entities_layer")
	get_parent().remove_child(self) #remove myself
	entities.add_child(self)

	global_position = spaw_position

	$AnimationPlayer.play("default")

