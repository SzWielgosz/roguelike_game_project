extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D
@export var speed: int = 80
var direction: Vector2 = Vector2.ZERO
var knockback: Vector2 = Vector2.ZERO

func _ready():
	set_physics_process(true)

func _process(_delta):
	if direction.x < 0:
		animated_sprite.flip_h = true
	else:
		animated_sprite.flip_h = false

func _physics_process(_delta):
	velocity = direction.normalized() * speed + knockback
	move_and_slide()
	knockback = lerp(knockback, Vector2.ZERO, 0.1)

func _on_hit_box_body_entered(body):
	if body.is_in_group("player") and !body.get_node("PlayerHealth").immortality:
		if PlayerStats.player_gold > 0 and !PlayerStats.gold_lost_this_frame:
			PlayerStats.substract_gold(1)
			PlayerStats.gold_lost_this_frame = true
