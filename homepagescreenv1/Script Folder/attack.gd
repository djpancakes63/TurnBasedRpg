extends Button



func _on_pressed() -> void:
	owner.choose_enemy()
	get_parent().hide()
