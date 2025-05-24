extends Node2D

@export var player_group : Node2D
@export var enemy_group : Node2D
@export var timeline : HBoxContainer
@export var options : VBoxContainer
@export var enemy_button : PackedScene
@export var progress_bar : ProgressBar

@export var max_health: = 100
var current_health = max_health

var sorted_array = []
var players : Array[Character]
var enemies : Array[Character]

var player_health : int

func _ready() -> void:
	for player in player_group.get_children():
		#if "character" in player and player.character != null:
		players.append(player.character)
	for enemy in enemy_group.get_children():
		enemies.append(enemy.character)
		
		var button = enemy_button.instantiate()
		button.character = enemy.character
		%EnemySelection.add_child(button)
		#print("SO this happened three times?")
		#else:
			#push_warning("%s is missing a valid 'character' resource." % player.name)
	
	#print("len(players) = ",len(players))

	sort_and_display()
	EventBus.next_attack.connect(next_attack)  # ✅ pass function reference, not a call
	next_attack()

	var root = get_tree().root
	var current_scene = root.get_child(root.get_child_count() - 1)
	print_debug(current_scene)

	player_health = 20
	global.in_arena = true
	#print("_ready is done")

func sort_combined_queue():
	#print("sort_combined_queue")
	var player_array = []
	for player in players:
		#if player != null and "queue" in player:
			#print("queue in player")
			#print("\tplayer.queue = ",player.queue)
		for i in player.queue:
			player_array.append({ "character": player, "time": i })
	#print("len(player_array) = ",len(player_array))
	var enemy_array = []
	for enemy in enemies:
		for i in enemy.queue:
			enemy_array.append({"character" : enemy, "time" : i })
			
	sorted_array = player_array
	sorted_array.append_array(enemy_array)
	sorted_array.sort_custom(sort_by_time)
	#print("len(sorted_array) = ",len(sorted_array))
	
func sort_by_time(a, b):
	return a["time"] < b["time"]

func _update_timeline():
	#print("update timeline")
	var index : int = 0
	for slot in timeline.get_children():
		#if index < sorted_array.size():
		#print("len(sorted_array) = ",len(sorted_array))
		#print("index =",index)
		slot.find_child("TextureRect").texture = sorted_array[index]["character"].icon
		index += 1
			#else:
			#break  # Avoid accessing beyond array bounds

func sort_and_display():
	#print("sort and display")
	sort_combined_queue()
	_update_timeline()
	if sorted_array[0]['character'] in players:
		show_options()
		
func _process(delta: float) -> void:
	if player_health == 0:
		#print("fight is over")
		global.load_scene()

func pop_out():
	sorted_array[0]["character"].pop_out()
	sort_and_display()

func attack():
	sorted_array[0]["character"].attack(get_tree())


func next_attack():
	if sorted_array[0]["character"] in players:
		return
	attack()
	pop_out()
	global.player_to_take_damage = players.pick_random() # save the randomly selected victom
	global.player_to_take_damage.get_attacked() # call the attack on them
		
func set_status(status_type):
	sorted_array[0]["character"].set_status(status_type)
	sort_and_display()
	
func show_options():
	options.show()
	options.get_child(0).grab_focus()
	
func choose_enemy():
	%EnemySelection.show()
	%EnemySelection.get_child(0).grab_focus()
