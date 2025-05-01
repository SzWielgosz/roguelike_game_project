extends CanvasLayer

@onready var time_played_label: Label = $NinePatchRect/VBoxContainer/TimePlayedLabel
@onready var mobs_killed_label: Label = $NinePatchRect/VBoxContainer/MobsKilledLabel
@onready var coins_collected_label: Label = $NinePatchRect/VBoxContainer/CoinsCollectedLabel
@onready var bombs_used_label: Label = $NinePatchRect/VBoxContainer/BombsUsedLabel
@onready var spells_casted_label: Label = $NinePatchRect/VBoxContainer/SpellsCastedLabel
@onready var summary_appear_timer: Timer = $SummaryAppearTimer
@onready var player_health: PlayerHealth = get_tree().current_scene.find_child("PlayerHealth")


func _ready():
	player_health.player_died.connect(_on_player_died)


func _on_player_died():
	create_summary()


func _on_summary_appear_timer_timeout():
	visible = true


func _on_back_to_lobby_button_pressed():
	PlayerStats.reset()
	GameStats.reset()
	get_tree().change_scene_to_file("res://scenes/rooms/lobby.tscn")


func create_summary():
	time_played_label.text = "Time played: %.2f" % [GameStats.time_played]
	mobs_killed_label.text = "Mobs killed: %d" % [GameStats.mobs_killed]
	coins_collected_label.text = "Gold collected: %d" % [GameStats.coins_collected]
	bombs_used_label.text = "Bombs used: %d" % [GameStats.bombs_used]
	spells_casted_label.text = "Spells casted: %d" % [GameStats.spells_casted]
	summary_appear_timer.start()
