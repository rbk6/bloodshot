extends Node

# CONSTANTS
# ---------
const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const JUMP_START_DURATION = 0.1

# STATE
# -----
enum PlayerState {
	IDLE,
	AIM_IDLE,
	
	RUNNING,
	AIM_RUNNING,
	
	JUMP_START,
	JUMP_IDLE_UP,
	JUMP_IDLE_DOWN,
	JUMP_LAND,
	JUMP_TO_FALL,
	
	FALLING,
	
	SHOOTING,
	
	HURT,
	DEATH,
	GAINING_LIFE,
	LOSING_LIFE
}

var state_dict = {
	PlayerState.IDLE: {"anim_name": "Idle", "blend_time": 0.2, "speed": 1.0},
	PlayerState.AIM_IDLE: {"anim_name": "Aim Idle", "blend_time": 0.2, "speed": 1.0},
	PlayerState.RUNNING: {"anim_name": "Running", "blend_time": 0.15, "speed": 1.0},
	PlayerState.AIM_RUNNING: {"anim_name": "Running Aim", "blend_time": 0.15, "speed": 1.0},
	PlayerState.JUMP_START: {"anim_name": "Jump Start", "blend_time": 0.05, "speed": 4},
	PlayerState.JUMP_IDLE_UP: {"anim_name": "Jump Up Idle", "blend_time": 2, "speed": 0.7},
	PlayerState.JUMP_LAND: {"anim_name": "Jump Land", "blend_time": 0, "speed": 1.0},
	PlayerState.FALLING: {"anim_name": "Fall Idle", "blend_time": 0.2, "speed": 1.0},
	PlayerState.SHOOTING: {"anim_name": "Shoot", "blend_time": 0, "speed": 1.0},
	PlayerState.HURT: {"anim_name": "Hurt", "blend_time": 0.2, "speed": 1.0},
	PlayerState.DEATH: {"anim_name": "Death", "blend_time": 0.5, "speed": 1.0}
}

# STATS
# -----
var player_health = 3
var player_state = PlayerState.IDLE
var has_bullet: bool = true

# MISC
# -----
var bullet_transition = 0

# RENDERING
# ---------
var main_scene
