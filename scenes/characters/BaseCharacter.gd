extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# movement
var last_move_direction := Vector3.FORWARD

# camera
@onready var model = $CharacterModel
@onready var camera_target = $CameraController/CameraTarget

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	if Input.is_action_just_pressed("jump") and is_on_floor():
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
		last_move_direction = direction

		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED

		# rotate model to input direction
		var target_rotation_y = atan2(-direction.x, -direction.z)
		model.rotation.y = lerp_angle(model.rotation.y, target_rotation_y, delta * 15)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
