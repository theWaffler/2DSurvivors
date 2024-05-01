extends Node

#@export var upgrade_pool: Array[AbilityUpgrade]
@export var experience_manager: Node
@export var upgrade_screen_scene: PackedScene

var current_upgrades = {}
var upgrade_pool: WeightedTable = WeightedTable.new()

var upgrade_chanclas_rate = preload("res://resources/upgrades/chanclas_rate.tres")
var upgrade_chanclas_damge = preload("res://resources/upgrades/chanclas_damage.tres")
var upgrade_guitar = preload("res://resources/upgrades/guitar.tres")
var upgrade_guitar_damage = preload("res://resources/upgrades/guitar_damage.tres")

func _ready():
	upgrade_pool.add_item(upgrade_guitar, 10)
	upgrade_pool.add_item(upgrade_chanclas_rate, 10)
	upgrade_pool.add_item(upgrade_guitar, 10)

	experience_manager.level_up.connect(on_level_up)


func apply_upgrade(upgrade: AbilityUpgrade):

	var has_upgrade = current_upgrades.has(upgrade.id)
	if !has_upgrade:
		current_upgrades[upgrade.id] = {
			"resource": upgrade,
			"quantity": 1
		}
	else:
		current_upgrades[upgrade.id]["quantity"] += 1

	if upgrade.max_quantity > 0:
		var current_quantity = current_upgrades[upgrade.id]["quantity"]
		if current_quantity == upgrade.max_quantity:
			upgrade_pool.remove_item(upgrade)

	update_upgrade_pool(upgrade)
	GameEvents.emit_ability_upgrade_added(upgrade, current_upgrades)

	# debugging purpose
	#print(current_upgrades)


# checks to see if you have the ability and if player has selected ability
# update the upgrade pool. Greater weight == more likely to be chosen
func update_upgrade_pool(chosen_upgrade: AbilityUpgrade):
	if chosen_upgrade.id == upgrade_guitar.id:
		upgrade_pool.add_item(upgrade_guitar_damage, 10)


func pick_upgrade():

	var chosen_upgrades: Array[AbilityUpgrade]= []
	#var filtered_upgrades = upgrade_pool.duplicate() # pass by value. copy

	for i in 2:
		if upgrade_pool.items.size() == 0:
			break
		var chosen_upgrade = upgrade_pool.pick_item(chosen_upgrades)
		if chosen_upgrade == null:
			break
		chosen_upgrades.append(chosen_upgrade)

	return chosen_upgrades


func on_upgrade_selected(upgrade: AbilityUpgrade):
	apply_upgrade(upgrade)


func on_level_up(current_level: int):
	var upgrade_screen_instance = upgrade_screen_scene.instantiate()
	add_child(upgrade_screen_instance)

	var chosen_upgrades = pick_upgrade()

	upgrade_screen_instance.set_ability_upgrade(chosen_upgrades as Array[AbilityUpgrade]) 
	upgrade_screen_instance.upgrade_selected.connect(on_upgrade_selected)
