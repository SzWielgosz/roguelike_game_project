extends InstantSpell

@export var speed: int = 300
@export var attack_power: float = 25.0 * PlayerStats.damage_modifier
@export var knockback := 0
@export var target_position: Vector2 = Vector2.ZERO
@onready var caster = PlayerStats.player.get_node("Arm")
var initial_position: Vector2
var traveling_to_target = true


func _ready():
	super._ready()
	initial_position = caster.global_position
	target_position = global_position + get_global_mouse_position()
	$AnimatedSprite2D.play("flying")


func _physics_process(delta):
	if traveling_to_target:
		move_to_target(delta)
	else:
		return_to_owner(delta)


func move_to_target(delta):
	var direction_to_target = (target_position - initial_position).normalized()
	global_position += direction_to_target * speed * delta  

	if global_position.distance_to(target_position) <= 10:
		traveling_to_target = false


func return_to_owner(delta):
	var owner_position = caster.global_position
	var direction_to_owner = (owner_position - global_position).normalized()
	global_position += direction_to_owner * speed * delta


	if global_position.distance_to(owner_position) <= 10:
		queue_free()


func _on_area_2d_body_entered(body):
	if body.name == "TileMap" or body.name == "StaticBody2D":
		traveling_to_target = false

	if body.is_in_group("mobs"):
		if body.get_node("Health") != null:
			var damage = body.get_node("Health").take_damage(attack_power)
