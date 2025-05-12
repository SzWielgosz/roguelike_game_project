extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D
@export var speed: int = 80
var direction: Vector2 = Vector2.ZERO
var knockback: Vector2 = Vector2.ZERO

func _physics_process(_delta):
	knockback = lerp(knockback, Vector2.ZERO, 0.1)
	velocity += knockback
	move_and_slide()

func _on_hit_box_body_entered(body):
	if body.is_in_group("player") and !body.get_node("PlayerHealth").immortality:
		if PlayerStats.player_coins > 0 and !PlayerStats.coin_lost_this_frame:
			PlayerStats.substract_coins(1)
			GameStats.coins_collected -= 1
			PlayerStats.coin_lost_this_frame = true
