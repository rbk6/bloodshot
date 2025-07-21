extends Control

@onready var buttons_v_box: VBoxContainer = %ButtonsVbox

func togglePause():
	get_tree().paused = !get_tree().paused
	
	if get_tree().paused:
		visible = true
		mouse_filter = Control.MOUSE_FILTER_STOP
	else:
		visible = false
		mouse_filter = Control.MOUSE_FILTER_IGNORE
	
func _ready():
	visible = false
	set_process_input(true)
	set_process_mode(Node.PROCESS_MODE_ALWAYS)
	focus_button()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("escape"):
		togglePause()

func _on_resume_pressed() -> void:
	togglePause()

func _on_restart_pressed() -> void:
	togglePause()
	Global.main_scene.load_level("operating_room")

func _on_options_pressed() -> void:
	pass # Replace with function body.

func _on_quit_pressed() -> void:
	get_tree().quit()

func focus_button() -> void:
	if buttons_v_box:
		var button: Button = buttons_v_box.get_child(0)
		if button is Button:
			button.grab_focus()

func _on_visibility_changed() -> void:
	if visible:
		focus_button()
