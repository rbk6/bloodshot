extends CanvasLayer
class_name UI

signal start_game()

func _on_main_menu_start_game() -> void:
	start_game.emit()
