
extends TextureRect

var base_position: Vector2
var base_scale: Vector2
var tempo := 0.0

func _ready():
	await get_tree().process_frame
	base_position = position
	base_scale = scale
	pivot_offset = size / 2
	mouse_filter = Control.MOUSE_FILTER_IGNORE
func _process(delta):
	tempo += delta

	# Pulsação bem leve
	var pulse = 1.0 + sin(tempo * 2.5) * 0.025
	scale = base_scale * pulse

	# Glitch rápido de vez em quando
	if sin(tempo * 18.0) > 0.965:
		position = base_position + Vector2(randf_range(-2.0, 2.0), randf_range(-1.0, 1.0))
		modulate = Color(0.85, 1.0, 1.0, 0.95)
	else:
		position = position.lerp(base_position, 0.25)
		modulate = Color(1, 1, 1, 1)
