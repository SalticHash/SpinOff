extends Control


func _process(delta: float) -> void:
	$Counters/Boxes/Label.text = "Boxes: " + str(Global.boxes)
	$Counters/Melons/Label.text = "Melons: " + str(Global.melon)
