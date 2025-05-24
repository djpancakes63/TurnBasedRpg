extends Resource
class_name Character

@export var max_health: =100
var current_health = max_health
#code for health
@export var Character : Character
@export var title :String
@export var icon : Texture2D
@export var texture : Texture2D
@export var agility : int:
	set(value):
		agility = value
		speed = 200.0 / (log(agility)+ 2) -25
		queue_reset()

@export var vfx_node : PackedScene = preload("res://Scenes/vfx.tscn")		
var speed: float
var queue : Array[float]
var status = 1
var node
	
func queue_reset():
	#print("queue reset running")
	queue.clear()
	for i in range(4):
		if queue.size() == 0:
			queue.append(speed * status)
		else:
			queue.append(queue[-1]+ speed * status)
	#print("Max Health:",max_health)
	#print("Current Health",current_health)
	#print("queue = ",queue)
			
func tween_movement(shift, tree):
	var tween = tree.create_tween()
	tween.tween_property(node, "position", node.position + shift, 0.2)
	await tween.finished
 
 
func attack(tree):
	var shift = Vector2(30,0)
	if node.position.x < node.get_viewport_rect().size.x/2:
		shift = -shift
 
	await tween_movement(-shift, tree)
	await tween_movement(shift, tree)
	#current_health -= 10
	
	
	
	#print("HEY listen new HEalth here",current_health)
	EventBus.next_attack.emit()

func _update_progress_bar():
	if node and "update_health_bar" in node:
		node.update_health_bar(current_health, max_health)
		
func pop_out():
	queue.pop_front()
	queue.append(queue[-1] + speed * status)
	
func add_vfx(type : String = ""):
	var vfx = vfx_node.instantiate()
	node.add_child(vfx)
	if type == "":
		return
	vfx.find_child("AnimationPlayer").play(type)
	
func get_attacked(type = ""):
	add_vfx(type)
	current_health -= randi_range(1,20)
	current_health = clamp(current_health,0,max_health)
	_update_progress_bar()
	if current_health == 0:
		no_health()
	
	
func no_health():
	print("Health has reached zero")
	global.load_scene()

func set_status(status_type : String):
	add_vfx(status_type)
	match status_type:
		"Haste":
			status = 0.5
		"Slow":
			status = 2
 
	print(queue)
	for i in range(3):
		queue.pop_back()
	print(queue)
 
	for i in range(3):
		queue.append(queue[-1] + speed * status)
	print(queue)
