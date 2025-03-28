extends Node
class_name SpellScroll 

enum CastType {INSTANT, CHANNEL}
enum CooldownType {TIME, ROOM_CLEAR, KILL_MOBS}
@export var cast_type: CastType
@export var cooldown_type: CooldownType
@export var spell_scene: PackedScene
@export var is_on_cooldown: bool = false
@export var cooldown_timer: Timer
@export var rooms_to_clear: int
@export var mobs_to_kill: int


func _ready():
	cooldown_timer.timeout.connect(_on_cooldown_timer_timeout)

func cast_spell():
	if spell_scene and !is_on_cooldown:
		var spell_instance = spell_scene.instantiate()
		spell_instance.cast.connect(_on_spell_cast)
		return spell_instance
	else:
		return null

func _on_spell_cast():
	cooldown_timer.start()
	is_on_cooldown = true

func _on_cooldown_timer_timeout():
	is_on_cooldown = false
