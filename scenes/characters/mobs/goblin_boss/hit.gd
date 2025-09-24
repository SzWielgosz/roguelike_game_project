extends State
@onready var health_node: Health = $"../../Health"
@onready var animated_sprite_2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var hp_bar: ProgressBar = $"../../UI/ProgressBar"


func enter():
	super.enter()
	
func exit():
	super.exit()

func flash_white_shader():
	var mat = animated_sprite_2d.material
	mat.set("shader_parameter/flash_strength", 1.0)
	await get_tree().create_timer(0.1).timeout
	mat.set("shader_parameter/flash_strength", 0.0)

func _on_health_took_damage():
	hp_bar.value = health_node.health
	flash_white_shader()
