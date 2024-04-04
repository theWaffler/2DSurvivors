extends Node

@export var taco_scene: PackedScene
@export var health_component: Node


func _ready():
    (health_component as HealthComponent).died.connect(on_died)

func on_died():
    if taco_scene == null:
        return

    if not owner is Node:
        return

    var spawn_position = (owner as Node2D).global_position
    var taco_instance = taco_scene.instantiate() as Node2D
    owner.get_parent().add_child(taco_instance)
    taco_instance.global_position = spawn_position