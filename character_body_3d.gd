extends CharacterBody3D

signal freecamtoggle

@export var move_speed: float = 6.0
@export var freecam_speed: float = 10.0
@export var mouse_sensitivity: float = 0.002
@export var jump_velocity: float = 4.5
@export var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var camera: Camera3D = $Camera3D

var pitch: float = 0.0
var freecam_enabled: bool = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)

		pitch -= event.relative.y * mouse_sensitivity
		pitch = clamp(pitch, deg_to_rad(-89), deg_to_rad(89))
		camera.rotation.x = pitch

	if event.is_action_pressed("ui_cancel"):
		# ESC toggles mouse capture
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	if event.is_action_pressed("toggle_freecam"):
		freecam_enabled = !freecam_enabled
		emit_signal("freecamtoggle")
		velocity = Vector3.ZERO  # prevent weird carry-over motion


func _physics_process(delta):
	#print($Camera3D/RayCast3D.get_collider())
	if $Camera3D/RayCast3D.is_colliding():
		var col = $Camera3D/RayCast3D.get_collider()
		if col and col.has_method("interact"):
			col.interact()
			pass
	if freecam_enabled:
		_freecam_process(delta)
	else:
		_player_process(delta)


# -----------------------------------------
# Normal player (walking, gravity, jumping)
# -----------------------------------------
func _player_process(delta):
	var v = velocity

	# Gravity
	if not is_on_floor():
		v.y -= gravity * delta

	# Jump
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		v.y = jump_velocity

	# Movement
	var input_dir = Input.get_vector("move_left","move_right","move_forward","move_back")
	var dir = Vector3.ZERO

	if input_dir != Vector2.ZERO:
		var forward = -transform.basis.z
		var right = transform.basis.x
		dir = (forward * input_dir.y) + (right * input_dir.x)
		dir.y = 0
		dir = dir.normalized()

	v.x = dir.x * move_speed
	v.z = dir.z * move_speed

	velocity = v
	move_and_slide()


# -----------------------------------------
# FREECAM MODE (no collision, no gravity)
# -----------------------------------------
func _freecam_process(delta):
	var move_dir = Input.get_vector("move_left","move_right","move_forward","move_back")

	var forward = -global_transform.basis.z
	var right = global_transform.basis.x
	var up = Vector3.UP

	var direction = (
		forward * move_dir.y +
		right * move_dir.x
	)

	# Add vertical controls (space = up, shift = down)
	if Input.is_action_pressed("jump"):
		direction += up
	if Input.is_key_pressed(KEY_SHIFT):
		direction -= up

	if direction != Vector3.ZERO:
		direction = direction.normalized()

	# Move camera by transforming the player position in freecam mode
	global_translate(direction * freecam_speed * delta)
