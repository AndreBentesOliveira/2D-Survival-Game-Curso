extends CharacterBody2D



@onready var damage_interval_timer = $DamageIntervalTimer
@onready var health_component = $HealthComponent
@onready var health_bar = $HealthBar
@onready var abillities = $Abillities
@onready var animation_player = $AnimationPlayer
@onready var visuals_node = $Visuals
@onready var velocity_component: Node = $VelocityComponent

var floating_text_scene = preload("res://scenes/ui/floating_text.tscn")
var number_colliding_bodies = 0
var base_speed = 0


func _ready():
	base_speed =  velocity_component.max_speed
	$HealthRegenInterval.timeout.connect(on_healthregeninterval_timeout)
	$CollisionAread2D.body_entered.connect(on_body_entered)
	$CollisionAread2D.body_exited.connect(on_body_exited)
	damage_interval_timer.timeout.connect(on_damage_interval_timer_timeout)
	health_component.health_decreased.connect(on_health_decreased)
	health_component.health_increased.connect(on_health_increased)
	GameEvents.ability_upgrades_added.connect(on_ability_upgrade_added)
	update_health_display()


func _process(delta):
	var movement_vector = get_movement_vector()
	var direction = movement_vector.normalized()
	velocity_component.accelerate_in_direction(direction)
	velocity_component.move(self)
	
	if movement_vector.x != 0 || movement_vector.y != 0:
		animation_player.play("walk")
	else:
		animation_player.play("RESET")
	
	var move_sign = sign(movement_vector.x)
	if move_sign != 0:
		visuals_node.scale = Vector2(move_sign, 1)

func get_movement_vector():
	var x_movement = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_movement = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return Vector2(x_movement, y_movement)


func check_deal_damage():
	if number_colliding_bodies == 0 || !damage_interval_timer.is_stopped():
		return
	
	var damage = 1 * number_colliding_bodies
	
	health_component.damage(damage)
	damage_interval_timer.start()
	
	floating_text_spawn(damage, Color(0.90980398654938, 0.27058801054955, 0.215685993433))
	print("Health: " + str(health_component.current_health))


func update_health_display():
	health_bar.value = health_component.get_health_percent()


func on_body_entered(other_body: Node2D):
	number_colliding_bodies += 1
	check_deal_damage()

func on_body_exited(other_body: Node2D):
	number_colliding_bodies -= 1


func on_damage_interval_timer_timeout():
	check_deal_damage()


func on_health_decreased():
	GameEvents.emit_player_damaged()
	update_health_display()
	$HitRandomStreamPlayer2DComponent.play_random()


func on_health_increased():
	update_health_display()


func on_ability_upgrade_added(ability_upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if ability_upgrade is Ability:
		var ability = ability_upgrade as Ability
		abillities.add_child(ability.ability_controll_scene.instantiate())
	elif ability_upgrade.id == "player_speed":
		velocity_component.max_speed = base_speed + (base_speed * current_upgrades["player_speed"]["quantity"] * .1)


func on_healthregeninterval_timeout():
	var health_regen_quantity = MetaProgression.get_upgrade_count("health_regeneration")
	if health_regen_quantity > 0:
		health_component.heal(health_regen_quantity)
		floating_text_spawn(health_regen_quantity, Color(0.26274511218071, 0.88235294818878, 0.70196080207825))


func floating_text_spawn(number: int, text_color: Color):
	var floating_text = floating_text_scene.instantiate() as Node2D
	get_tree().get_first_node_in_group("foreground_layer").add_child(floating_text)
	floating_text.global_position = self.global_position + (Vector2.UP * 16)
	var format_string = "%0.1f"
	if round(number) == number:
		format_string = "%0.0f"
	floating_text.start(format_string % number, text_color)
