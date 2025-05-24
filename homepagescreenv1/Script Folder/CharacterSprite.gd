extends Sprite2D

@export var character : Character 

func _ready():
	if character:
		character.node = self
		texture = character.texture

func _process(delta: float) -> void:
	#print("current health:",character.current_health)
	#print("progress label:",$ProgressBar.value)
	#$ProgressBar.value = character.current_health # update health progress bar
	
	if character == global.player_to_take_damage:
		if $ProgressBar1:
			$ProgressBar1.set_value_no_signal(character.current_health)
		elif $ProgressBar2:
			$ProgressBar2.set_value_no_signal(character.current_health)
		elif $ProgressBar3:
			$ProgressBar3.set_value_no_signal(character.current_health)
