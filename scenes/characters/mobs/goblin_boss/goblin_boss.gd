extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var hp_bar: ProgressBar = $UI/ProgressBar
@onready var health_node: Node = $Health
@export var area_2d: Area2D
@export var speed: int = 50
var direction: Vector2 = Vector2.ZERO
var knockback: Vector2 = Vector2.ZERO

func _ready():
	hp_bar.max_value = health_node.max_health
	hp_bar.value = health_node.health
	set_physics_process(true)

func _physics_process(_delta):
	move_and_slide()
