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
@export var damage: int 
@export var speed: float
@export var ui: Control
@export var pickup_area: Area2D
@export var scroll_name: String
@export var spell_name: String
var player_in_range: bool


func _ready():
	cooldown_timer.timeout.connect(_on_cooldown_timer_timeout)
	pickup_area.body_entered.connect(_on_pickup_area_body_entered)
	pickup_area.body_exited.connect(_on_pickup_area_body_exited)
	$Control/NinePatchRect/VBoxContainer/SpellNameLabel.text = self.name

func cast_spell():
	if spell_scene and !is_on_cooldown:
		var spell_instance = spell_scene.instantiate()
		spell_instance.cast.connect(_on_spell_cast)
		return spell_instance
	else:
		return null

func pick_up():
	pickup_area.monitoring = false
	ui.visible = false
	PlayerStats.equip_spell(self, self.global_position)
	PlayerStats.spell_equipped.emit()

func drop(at_position: Vector2, parent_node: Node):
	self.global_position = at_position
	var current_parent = self.get_parent()
	current_parent.remove_child(self)
	parent_node.add_child(self)
	pickup_area.monitoring = true
	ui.visible = false

func _on_spell_cast():
	cooldown_timer.start()
	is_on_cooldown = true

func _on_cooldown_timer_timeout():
	is_on_cooldown = false

func _on_pickup_area_body_entered(body):
	if body.is_in_group("player"):
		player_in_range = true
		ui.visible = true

func _on_pickup_area_body_exited(body):
	if body.is_in_group("player"):
		player_in_range = false
		ui.visible = false

func _input(event):
	if event.is_action_pressed("interact") and player_in_range:
		pick_up()
