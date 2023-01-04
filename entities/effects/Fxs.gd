extends AnimatedSprite

func intialize(spriteFrames:SpriteFrames):
	frames = spriteFrames
	play("default")

func _on_Fxs_animation_finished() -> void:
	queue_free()
