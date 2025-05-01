extends State
@onready var health_node: Health = $"../../Health"
@onready var animated_sprite_2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var hit_timer: Timer = $HitTimer
@onready var hp_bar: ProgressBar = $"../../UI/ProgressBar"


func enter():
	super.enter()
	
func exit():
	super.exit()
	
func _on_health_took_damage():
	animated_sprite_2d.play("hit")
	hp_bar.value = health_node.health
	hit_timer.start()

func _on_hit_timer_timeout():
	if not health_node.is_dead:
		animated_sprite_2d.play("idle")
