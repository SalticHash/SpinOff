extends Control

var opened: bool = false
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	$AnimationPlayer.play("hover")
	

func _input(event: InputEvent) -> void:
	if opened: return
	if event is InputEventKey:
		opened = true
		get_tree().change_scene_to_file("res://world/world.tscn")
		
