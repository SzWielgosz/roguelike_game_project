extends State
@onready var boss = $"../.."
@onready var collision_shape_2d: CollisionShape2D = $"../../CollisionShape2D"
@onready var animated_sprite_2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var death_timer: Timer = $DeathTimer


func enter():
	super.enter()
	#owner.set_physics_process(false)
	collision_shape_2d.disabled = true
	animated_sprite_2d.play("death")
	death_timer.start()

func _on_death_timer_timeout():
	boss.queue_free()
