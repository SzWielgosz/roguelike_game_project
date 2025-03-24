extends State
@onready var health_node: Health = $"../../Health"
@onready var animated_sprite_2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var hit_timer: Timer = $HitTimer


func enter():
	super.enter()
	
func exit():
	super.exit()
	
func _on_health_took_damage():
	animated_sprite_2d.play("hit")
	hit_timer.start()

func _on_hit_timer_timeout():
	if not health_node.is_dead:
		animated_sprite_2d.play("flying")
