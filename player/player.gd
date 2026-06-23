extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

const MAX_SPEED = 32
var speed: float = 0.0
var last_dir: float = 1.0
func animate(delta: float) -> void:
	$HamsterWheel.rotate_x(speed * PI / 32 * delta)
	$Sprite.walking = speed != 0
	var rot = create_tween()
	rot.tween_property($Sprite, "rotation_degrees", Vector3(0, 0 if last_dir == 1 else 180, 0), 0.2)
	$Sprite.walk_speed = remap(abs(speed), 0, MAX_SPEED, 0.2, 0.025)

func _physics_process(delta: float) -> void:


	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
#
	## Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var accel_dir: float = Input.get_axis("ui_down", "ui_up")
	var turn_dir: float = Input.get_axis("ui_left", "ui_right")
	if turn_dir: rotate_y(-turn_dir * PI * delta) 

	_camera_pivot.global_position = global_position
	if accel_dir:
		last_dir = sign(accel_dir)
		speed = move_toward(speed, MAX_SPEED * accel_dir, delta * 8)
	else:
		speed = move_toward(speed, 0.0, delta * 8)
	
	animate(delta)
		
	var direction := (transform.basis * Vector3.BACK).normalized()
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed

	move_and_slide()



# Comment out this existing camera line.
# @onready var _camera := $Target/Camera3D as Camera3D

@onready var _camera := %Camera as Camera3D
@onready var _camera_pivot := %CameraPivot as Node3D

@export_range(0.0, 1.0) var mouse_sensitivity = 0.01
@export var tilt_limit = deg_to_rad(75)


func _unhandled_input(event: InputEvent) -> void:
	# Mouselook implemented using `screen_relative` for resolution-independent sensitivity.
	if event is InputEventMouseMotion:
		_camera_pivot.rotation.x -= event.screen_relative.y * mouse_sensitivity
		# Prevent the camera from rotating too far up or down.
		_camera_pivot.rotation.x = clampf(_camera_pivot.rotation.x, -tilt_limit, tilt_limit)
		_camera_pivot.rotation.y += -event.screen_relative.x * mouse_sensitivity
