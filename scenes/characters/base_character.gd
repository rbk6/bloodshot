extends CharacterBody3D

var bullet = load("res://scenes/entities/Bullet.tscn")
var defaultCharacter = preload("res://assets/models/characters/fella.glb")
var instance

@onready var model = $CharacterModel
@onready var anim_player = $CharacterModel/fella/AnimationPlayer
@onready var camera_target = $CameraController/CameraTarget
@onready var gun_barrel = $CharacterModel/DefaultWeapon/RayCast3D
@onready var blood_anim = $CharacterModel/fella/Armature/Skeleton3D/Face/Face/MeshInstance3D/AnimationPlayer

func _ready() -> void:
	add_to_group("Player",true)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	elif Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = Global.JUMP_VELOCITY

	handle_input(delta)
	update_state()
	update_animation()
	move_and_slide()
	
	if Global.bullet_transition > 0:
		Global.has_bullet = true
		blood_anim.play("get_blood")
		Global.bullet_transition = 0
		return

func handle_input(delta: float) -> void:
	# handle directional input
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")

	if input_dir.length() > 0:
		# process input
		var direction = Vector3(input_dir.x, 0, input_dir.y).normalized()
		var rotation_basis = Basis(Vector3.UP, camera_target.rotation.y) * direction
		direction = rotation_basis.normalized()

		velocity.x = direction.x * Global.SPEED
		velocity.z = direction.z * Global.SPEED

		# rotate model to input direction
		var target_rotation_y = atan2(-direction.x, -direction.z)
		model.rotation.y = lerp_angle(model.rotation.y, target_rotation_y, delta * 15)
	else:
		velocity.x = move_toward(velocity.x, 0, Global.SPEED)
		velocity.z = move_toward(velocity.z, 0, Global.SPEED)
		
	if Input.is_action_just_pressed("shoot") and Global.has_bullet:
		shoot(delta)

func update_state() -> void:
	if Global.player_health <= 0:
		Global.player_state = Global.PlayerState.DEATH
		return
		
	if Input.is_action_just_pressed("shoot"):
		Global.player_state = Global.PlayerState.SHOOTING
		anim_player.play_section("Shoot",0.12)
		await get_tree().create_timer(1).timeout

	if not is_on_floor():
		if velocity.y > 0:
			Global.player_state = Global.PlayerState.JUMP_IDLE_UP
		else:
			Global.player_state = Global.PlayerState.FALLING
		return

	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	if input_dir.length() > 0:
		if Input.is_action_pressed("aim"):
			Global.player_state = Global.PlayerState.AIM_RUNNING
		else:
			Global.player_state = Global.PlayerState.RUNNING
		return

	if Input.is_action_pressed("aim"):
		Global.player_state = Global.PlayerState.AIM_IDLE
		return

	Global.player_state = Global.PlayerState.IDLE

func update_animation():
	var anim_attr = Global.state_dict.get(Global.player_state)
	if anim_player and anim_player.has_animation(anim_attr.anim_name):
		if anim_player.current_animation != anim_attr.anim_name:
			anim_player.play(anim_attr.anim_name, anim_attr.blend_time, anim_attr.speed)
	else:
		push_warning("animation not found: " + anim_attr.anim_name)

func shoot(_delta: float) -> void:
	Global.has_bullet = false
	blood_anim.play("use_blood")
	instance = bullet.instantiate()
	instance.position = gun_barrel.global_position
	instance.transform.basis = gun_barrel.global_transform.basis
	get_parent().add_child(instance)
