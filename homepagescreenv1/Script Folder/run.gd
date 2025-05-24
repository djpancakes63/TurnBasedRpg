extends Button

@export var world : PackedScene

func _on_pressed() -> void:
	#get_tree().change_scene_to_file("res://world.tscn")
	global.load_scene()
