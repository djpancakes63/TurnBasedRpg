extends CharacterBody2D
signal dialogue_finished

const speed = 300.0
var current_dir = "walk_n"
var npc_in_range = false
var in_dialogue = false
var direction : Vector2
var step_size : int = 7


func show_dialogue_balloon(dialogue_resource, type):
	# Logic to show the dialogue
	print("Starting dialogue...")  # Debugging message
	# You can call this function when the dialogue is finished
	# After the dialogue ends, emit the signal to notify that the dialogue has finished
	end_dialogue()

# Example function to call when the dialogue is finished
func end_dialogue():
	print("Dialogue ended!")  # Debugging message
	emit_signal("dialogue_finished") 
	print("Emitting dialogue_finished signal")  # Debugging

func _physics_process(delta):
	#print("in range:",global.npc_in_range)
	#if not global.in_dialogue and Input.is_action_just_pressed("ui_accept"):
	#	DialogueManager.show_dialogue_balloon(load("res://main.dialogue"), "main")
	# Handle dialogue trigger when NPC is in range and input is pressed
	if global.npc_in_range and (Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("action")) and not global.in_dialogue:
		in_dialogue = true
		global.in_dialogue = true
				
		if (global.friend and global.friend.get_npc_name()=="npc"):
			# Start the dialogue (adjust the parameters as needed for your implementation)
			DialogueManager.show_dialogue_balloon(load("res://Dialogue folder/npc.dialogue"), "main")
		elif (global.friend and global.friend.get_npc_name()=="npc2"):
			DialogueManager.show_dialogue_balloon(load("res://Dialogue folder/npc2.dialogue"), "start")
		elif (global.enemy and global.enemy.get_npc_name()=="enemy1"):
			DialogueManager.show_dialogue_balloon(load("res://Dialogue folder/enemy.dialogue"), "start")
		return

	# Only allow movement if not in dialogue
	if not global.in_dialogue:
		#print("moving")
		player_1movement(delta)
	else:
		#print("not moving")

		velocity = Vector2.ZERO
		move_and_slide()
		play_anim(false)
	

func _ready():
	# Connect the dialogue finished signal to the function _on_dialogue_finished
	DialogueManager.connect("dialogue_finished", Callable(self, "_on_dialogue_finished"))

func player_1movement(delta):
	var moving = false

	if Input.is_action_pressed("ui_right"):
		current_dir = "walk_e"
		velocity.x = speed
		velocity.y = 0
		moving = true
		#print("Right button pressed")
	elif Input.is_action_pressed("ui_left"):
		current_dir = "walk_w"
		velocity.x = -speed
		velocity.y = 0
		moving = true
		#print("left button pressed")
	elif Input.is_action_pressed("ui_down"):
		current_dir = "walk_s"
		velocity.y = speed
		velocity.x = 0 
		moving = true
		#print("down button pressed")
	elif Input.is_action_pressed("ui_up"):
		current_dir = "walk_n"
		velocity.y = -speed
		velocity.x = 0
		moving = true
		#print("up button pressed")
	else:
		velocity = Vector2.ZERO

	play_anim(moving)
	move_and_slide()

func play_anim(moving):
	var anim = $AnimatedSprite2D
	
	match current_dir:
		"walk_e":
			anim.flip_h = false
			anim.play("walk_e" if moving else "idle")
		"walk_w":
			anim.flip_h = true
			anim.play("walk_w" if moving else "idle")
		"walk_s":
			anim.play("walk_s" if moving else "idle")
		"walk_n":
			anim.play("walk_n" if moving else "idle")

func _on_detection_area_body_entered(body):
	
	if body.has_method("npc"):
		npc_in_range = true
		global.npc_in_range = true
		global.friend = body
	
	if body.has_method("enemy"):
		npc_in_range = true
		global.npc_in_range = true
		global.enemy = body

func _on_detection_area_body_exited(body):
	if body.has_method("npc"):
		npc_in_range = false
		global.npc_in_range = false
		global.friend = null
		

# This function is called when the dialogue is finished
func _on_dialogue_finished():
	print("Dialogue finished!")  # Optional, for debugging
	in_dialogue = false  # This will allow the player to move again
	npc_in_range = false
