extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var hp_bar: ProgressBar = $UI/ProgressBar
@onready var health_node: Health = $Health
@onready var player: CharacterBody2D = $"../../Player"
@export var teleportation_points: Array[Marker2D]
@export var shoot_laser_point: Marker2D
@export var area_2d: Area2D
@export var speed: int = 80
var direction: Vector2 = Vector2.ZERO
var knockback: Vector2 = Vector2.ZERO
var player_in_sight: bool = false


func _ready():
	set_physics_process(true)
	hp_bar.max_value = health_node.max_health
	hp_bar.value = health_node.health
	area_2d.body_entered.connect(_on_body_entered)


func _process(_delta):
	if player.global_position.x - global_position.x < 0:
		animated_sprite.flip_h = true
	else:
		animated_sprite.flip_h = false


func _on_body_entered(body):
	player_in_sight = true
