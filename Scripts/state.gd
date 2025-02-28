extends Node
class_name State

@onready var player = get_tree().root.get_node("Game").find_child("Player")
#@onready var player = get_tree().root.get_node("TestScene").find_child("Player")
@onready var debug = owner.find_child("debug")
@onready var animated_sprite = owner.find_child("AnimatedSprite2D")

func _ready():
	set_physics_process(false)


func enter():
	set_physics_process(true)


func exit():
	set_physics_process(false)


func transition():
	pass


func _physics_process(delta):
	transition()
	debug.text = name
