extends Node3D

const SPEED = 50.0

@onready var mesh = $MeshInstance3D
@onready var ray = $RayCast3D

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	position += transform.basis * Vector3(0, 0, -SPEED) * delta
	if ray.is_colliding():
		mesh.visible = false
		await get_tree().create_timer(1.0).timeout
		queue_free()

func _on_timer_timeout():
	queue_free()
