extends RigidBody3D

var pitch = 1.0
func _ready() -> void:
	pitch = randf_range(0.5, 2.0)
	$ExplodeSound.pitch_scale = pitch
	$Chomp.pitch_scale = pitch
	
var gotten: bool = false
func collect():
	if gotten: return
	$Fly.emitting = true
	apply_central_impulse(Vector3(0, pitch * 10, 0))
	gotten = true
	$Chomp.play()
	Global.melon += 1
	await $Chomp.finished
	explode()

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	for ct: int in range(state.get_contact_count()):
		var obj = state.get_contact_collider_object(ct)
		if !obj: return
		if obj is Player:
			collect()
			break


func explode() -> void:
	$Explode.global_position = global_position
	$Explode.restart()
	$Sprite.hide()
	$Fly.emitting = false
	$ExplodeSound.play()
	await $Explode.finished
	if $ExplodeSound.playing: await $ExplodeSound.finished
	
