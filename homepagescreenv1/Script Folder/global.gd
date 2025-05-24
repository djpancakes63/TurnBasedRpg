extends Node

var found_npc_items = true
var given_npc_items = false

var in_dialogue = false
var npc_in_range = false
var friend = null
var enemy = null

var fight = false
var in_arena = false

var player_to_take_damage : Character = null

var current_scene = null
var current_health =1
func switch_scene(res_path):
	print("switch scene called", res_path)
	call_deferred("_deferred_switch_scene",res_path)
	#print("Scene exists? ", ResourceLoader.exists("res://Savedfile/SavedWorld.tscn"))

func _deferred_switch_scene(res_path):
	print("Actually switching to:", res_path)
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count()-1)
	current_scene.free()
	
	var s = load(res_path)
	if s == null:
		push_error("Scene failed to load")
		return
		
		
	#await get_tree().process_frame	#wait a frame to safely free it
	#var new_scene = load(res_path)
	#if s is PackedScene:
	#	push_error("Failed to load valid scene at"+ res_path)
	#	return
		
	current_scene = s.instantiate()
	get_tree().root.add_child(current_scene)
	get_tree().current_scene = current_scene
	
func load_scene():
	call_deferred("_deferred_switch_scene_load")

func _deferred_switch_scene_load():
	var scene_path = "res://Savedfile/SavedWorld.tscn"
	var prev_scene = ResourceLoader.load(scene_path)
	
	if not prev_scene is PackedScene:
		push_error("Loaded resource is not a PackedScene. Type = %s" % typeof(prev_scene))
		return
		
	current_scene = prev_scene.instantiate()
	get_tree().change_scene_to_packed(prev_scene)
	get_tree().current_scene = current_scene
	in_arena = false
	#print("Loaded scene type:", prev_scene.get_class())  # Will say e.g., "PackedScene" or "Resource"
	
