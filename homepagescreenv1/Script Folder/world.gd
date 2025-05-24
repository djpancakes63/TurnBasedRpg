extends Node2D


func _ready() -> void:
	var root  = get_tree().root
	var current_scene = root.get_child(root.get_child_count()-1)
	get_tree().current_scene = current_scene
	
	
func _process(delta: float) -> void:
	if global.fight == true and global.in_arena == false:
		call_deferred("_swap_Battle_Scene")
		global.fight = false
	
	
func _swap_Battle_Scene() -> void:
	print("swap scene is running")
	var node_to_save = self
	var scene = PackedScene.new()
	scene.pack(node_to_save)
	#ResourceSaver.save(scene,"res://Savedfile/SavedWorld.tscn")
	print("Scene exists? ", ResourceLoader.exists("res://Scenes/battle scene.tscn"))
	global.switch_scene("res://Scenes/battle scene.tscn")
	
	
		
