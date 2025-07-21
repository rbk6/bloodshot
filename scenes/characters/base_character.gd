extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var bullet = load("res://scenes/entities/Bullet.tscn")
var instance

@onready var model = $CharacterModel
@onready var camera_target = $CameraController/CameraTarget
@onready var gun_barrel = $CharacterModel/DefaultWeapon/RayCast3D


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	elif Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	handle_input(delta)
	
	move_and_slide()
	
func handle_input(delta: float) -> void:
		# handle directional input
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")

	if input_dir.length() > 0:
		# process input
		var direction = Vector3(input_dir.x, 0, input_dir.y).normalized()
		var rotation_basis = Basis(Vector3.UP, camera_target.rotation.y) * direction
		direction = rotation_basis.normalized()

		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED

		# rotate model to input direction
		var target_rotation_y = atan2(-direction.x, -direction.z)
		model.rotation.y = lerp_angle(model.rotation.y, target_rotation_y, delta * 15)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
	if Input.is_action_just_pressed("shoot"):
		shoot(delta)
		
func shoot(_delta: float) -> void:
	#if !gun_anim.is_playing():
		#gun_anim.play("shoot")
		#instance = bullet.instantiate()
		#instance.position = gun_barrel.global_position
		#instance.transform.basis = gun_barrel.global_transform.basis
		#get_parent().add_child(instance)
		
	instance = bullet.instantiate()
	instance.position = gun_barrel.global_position
	instance.transform.basis = gun_barrel.global_transform.basis
	get_parent().add_child(instance)
