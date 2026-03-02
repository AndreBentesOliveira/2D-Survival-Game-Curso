extends Node

const MAX_RANGE = 200

@export var spear_abillity: PackedScene

var base_damage = 2.5
var addictional_damage_percent = 1
var base_wait_time 
var base_speed : float = 1

func _ready():
	base_wait_time = $Timer.wait_time
	$Timer.timeout.connect(on_timer_timeout)
	GameEvents.ability_upgrades_added.connect(on_ability_upgrade_added)


func on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	var enemies = get_tree().get_nodes_in_group("enemy")
	enemies.filter(func(enemy: Node2D): 
		return enemy.global_position.distance_squared_to(player.global_position) < pow(MAX_RANGE, 2)
	)
	
	if enemies.size() == 0:
		return
	
	enemies.sort_custom(func(a: Node2D, b: Node2D):
		var a_distance = a.global_position.distance_squared_to(player.global_position)
		var b_distance = b.global_position.distance_squared_to(player.global_position)
		return a_distance < b_distance 
	)
	
	var spear_instance = spear_abillity.instantiate() as SpearAbility
	var foreground_layer = get_tree().get_first_node_in_group("foreground_layer")
	foreground_layer.add_child(spear_instance)
	spear_instance.hitbox_component.damage = base_damage * addictional_damage_percent
	
	
	spear_instance.global_position = player.global_position
	#enemies[0].global_position
	#spear_instance.global_position += Vector2.RIGHT.rotated(randf_range(0, TAU)) * 4
	
	var enemy_direction = (enemies[0].global_position - spear_instance.global_position).normalized()
	spear_instance.start(enemy_direction, base_speed * 200)
	#spear_instance.rotation = enemy_direction.angle()
	#spear_instance.sprite.rotation = deg_to_rad(90)
	#spear_instance.rotation = spear_instance.global_position.angle_to_point(enemies[0].global_position)

func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	#if upgrade.id == "sword_rate":
		#var percent_reduction = current_upgrades["sword_rate"]["quantity"] * .1
		#$Timer.wait_time = base_wait_time * (1- percent_reduction)
		#$Timer.start()
	if upgrade.id == "spear_damage":
		addictional_damage_percent = 1 + (current_upgrades["spear_damage"]["quantity"] * .15)
	
