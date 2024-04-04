extends Node

@export_range(0,1) var drop_percent: float = 0.75
@export var health_component: Node
@export var taco_scene: PackedScene


func _ready():
    (health_component as HealthComponent).died.connect(on_died)

func on_died():
    if randf() > drop_percent:
        return

    if taco_scene == null:
        return

    if not owner is Node:
        return

    var spawn_position = (owner as Node2D).global_position
    var taco_instance = taco_scene.instantiate() as Node2D
    owner.get_parent().add_child(taco_instance)
    taco_instance.global_position = spawn_position