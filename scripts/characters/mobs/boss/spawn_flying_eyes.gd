extends State
@onready var boss = $"../.."
@onready var animated_sprite_2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var mob_spawn_points: Node2D = $"../../MobSpawnPoints"
@onready var mobs_container: Node = $"../../.."
@export var flying_eye_scene: PackedScene
var can_transition: bool 


func enter():
	super.enter()
	player = get_tree().current_scene.find_child("Player")
	animated_sprite_2d.play("idle")
	can_transition = false
	#print(mob_spawn_points.get_child_count())
	await get_tree().create_timer(0.5).timeout
	spawn_flying_eyes()
	await get_tree().create_timer(0.5).timeout
	can_transition = true


func transition():
	if can_transition:
		get_parent().change_state("ShootLaser")


func spawn_flying_eyes():
	for marker in mob_spawn_points.get_children():
		var flying_eye_instance = flying_eye_scene.instantiate()
		mobs_container.add_child(flying_eye_instance)
		flying_eye_instance.global_position = marker.global_position
	
