extends CanvasLayer

@onready var damage_vignetting: TextureRect = $DamageVignetting
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func damage_graphics():
	animation_player.play("damage")
