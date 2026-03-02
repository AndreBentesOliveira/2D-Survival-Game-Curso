extends Node2D
class_name SpearAbility

@onready var hitbox_component: HitboxComponent = $hitboxComponent
@onready var sprite = $Spear

var velocity := Vector2()

func start(direction: Vector2, speed: float) -> void:
	rotation = direction.angle()
	sprite.rotation = deg_to_rad(90)
	velocity = direction * speed
	print("direction: " + str(direction))
	print("speed: " + str(speed))
	print("velocity: " + str(velocity))


func _process(delta: float) -> void:
	position += velocity * delta
