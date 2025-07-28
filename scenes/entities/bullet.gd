extends CharacterBody3D

const SPEED = 50.0

@onready var mesh = $MeshInstance3D
@onready var hitbox = $Area3D
@onready var anim_player = $MeshInstance3D/AnimationPlayer
@onready var ray = $RayCast3D

var is_bouncing_multiplier = 0.5
var is_detecting: bool = false

func _ready() -> void:
	anim_player.play("ball")

func _process(delta: float) -> void:
	if not is_on_floor():
		move_and_slide()
		position += (transform.basis * Vector3(0, 0, -SPEED) * delta) * is_bouncing_multiplier
		await get_tree().create_timer(0.05).timeout
		is_detecting = true
		await get_tree().create_timer(0.2).timeout
		velocity += get_gravity() * delta
	else:
		anim_player.play("puddle",0.1,1)
		set_collision_mask_value(1,0)
		await get_tree().create_timer(5).timeout
		anim_player.pause()

func _on_timer_timeout():
	queue_free()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if is_detecting:
		if body.is_in_group("Player"):
			Global.has_bullet = true
			Global.bullet_transition = true
			queue_free()
		elif body.is_in_group("Enemy"):
			is_bouncing_multiplier = 0.0
			velocity.x = randf_range(-5,5)
			velocity.y = 10
			velocity.z = randf_range(-5,5)
