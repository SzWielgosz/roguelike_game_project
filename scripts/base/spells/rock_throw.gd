extends ChannelSpell

@export var speed: int = 150
@export var attack_power: int = 150
var thrown: bool = false
var collided: bool = false
var throw_rotation: float = 0.0


func _ready():
	super._ready()
	$Area2D/CollisionShape2D.shape = $Area2D/CollisionShape2D.shape.duplicate(true)
	if !is_channeled:
		$AnimatedSprite2D.play("channel")


func _process(delta):
	if thrown:
		position += direction * speed * delta


func _input(event):
	super._input(event)
	if event.is_action_released("use_spell"):
		if is_channeled:
			$Area2D/CollisionShape2D.disabled = false
			throw_rotation = rotation
			thrown = true


func _on_channel_timer_timeout():
	$AnimatedSprite2D.play("idle")


func _on_charge_timer_timeout():
	$AnimatedSprite2D.play("idle")


func destroy():
	speed = 0
	$AnimatedSprite2D.play("destroy")
	$Area2D/CollisionShape2D.position = Vector2(7, 0)
	$Area2D/CollisionShape2D.shape.radius = 14
	$Area2D/CollisionShape2D.shape.height = 36


func _on_animated_sprite_2d_animation_changed():
	if $AnimatedSprite2D.animation == "destroy":
		$DestroyTimer.start()


func _on_destroy_timer_timeout():
	queue_free()


func _on_area_2d_body_entered(body):
	if body.name == "TileMap" or body.name == "StaticBody2D":
		destroy()
	if body.is_in_group("mobs"):
		if body.get_node("Health") != null: 
			var damage = body.get_node("Health").take_damage(attack_power)
			print("Rock throw hit! Damage:", damage)
			destroy()
