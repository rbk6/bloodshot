extends Control
class_name Game

@onready var ui: CanvasLayer = $Ui
@onready var main_menu: Control = $Ui/Control/MainMenu
@onready var stage: Node3D = $Stage

var level_instance: Node3D

func _ready() -> void:
	Global.main_scene = self
	main_menu.start_game.connect(start_game)

func start_game():
	main_menu.hide()
	ui.show()
	stage.show()
	load_level("operating_room")

func unload_level():
	if is_instance_valid(level_instance):
		level_instance.queue_free()
	level_instance = null
	
func load_level(level_name: String) -> void:
	unload_level()
	var level_path := "res://scenes/stages/%s.tscn" % level_name
	var level_resource := load(level_path)
	if level_resource:
		level_instance = level_resource.instantiate()
		stage.add_child(level_instance)
		print("Loaded level position: ", level_instance.global_transform.origin)
