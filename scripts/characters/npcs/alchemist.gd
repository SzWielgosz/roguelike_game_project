extends Node2D
var player_nearby: bool = false
var dialogue_enabled: bool = false
@export var dialogue: DialogueResource
@export var shop: CanvasLayer


func _ready():
	$AnimatedSprite2D.play("idle")
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)


func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		player_nearby = true
		$Label.visible = true


func _on_area_2d_body_exited(body):
	if body.is_in_group("player"):
		player_nearby = false
		$Label.visible = false
		if shop:
			shop.close_shop()


func _input(event):
	if event.is_action_pressed("interact"):
		if player_nearby and !dialogue_enabled:
			DialogueManager.show_dialogue_balloon(dialogue)
			DialogueManager.dialogue_started.emit()
			dialogue_enabled = true


func _on_dialogue_ended(_dialogue: DialogueResource):
	dialogue_enabled = false


func open_shop():
	shop.open_shop()
