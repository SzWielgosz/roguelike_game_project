extends CanvasLayer
@onready var visibility_timer: Timer = $VisibilityTimer
@onready var game_saved: Control = $GameSaved
@onready var game_not_saved: Control = $GameNotSaved
@onready var item_popup: Control = $ItemPopup
@onready var item_popup_label: Control = $ItemPopup/Label
@onready var item_popup_visibility_timer: Timer = $ItemPopup/ItemPopupVisibilityTimer
var is_game_saved: bool = false


func _ready():
	SaveManager.game_save_result.connect(_on_game_save_result)
	GameManager.show_item_popup.connect(_on_show_item_popup)


func _on_game_save_result(success: bool):
	if success:
		game_saved.visible = true
		is_game_saved = true
		visibility_timer.start()
	else:
		game_not_saved.visible = true
		is_game_saved = false
		visibility_timer.start()


func _on_visibility_timer_timeout():
	if is_game_saved:
		game_saved.visible = false
	else:
		game_not_saved.visible = false


func _on_show_item_popup(item_text: String):
	item_popup.visible = true
	item_popup_label.text = item_text
	item_popup_visibility_timer.start()


func _on_item_popup_visibility_timer_timeout():
	item_popup_label.text = ""
	item_popup.visible = false
