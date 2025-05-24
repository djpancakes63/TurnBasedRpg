extends CharacterBody2D

func _physics_process(delta):
	$AnimatedSprite2D.play("idle")
	$AnimatedSprite2D.flip_h = true
	
func enemy():
	pass
	
func get_npc_name():
	return "enemy1"
