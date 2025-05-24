extends Sprite2D

@export var strength := 0.05

func _process(delta):
	var target_offset = (get_viewport().get_mouse_position() - get_viewport_rect().size / 2) * strength
	position = target_offset
