extends Control

# Caixinhas para você arrastar as imagens no Inspector
@export var npc_sprite: TextureRect
@export var player_sprite: TextureRect

# Configurações do Efeito Visual
var scale_active := Vector2(0.72, 0.72)
var scale_normal := Vector2(0.7, 0.7)
var alpha_active := 1.0
var alpha_inactive := 0.5
var current_tween: Tween

func _ready() -> void:
	EventBus.dialogue_finished.connect(_on_dialogue_finished)
	EventBus.speaker_changed.connect(_on_speaker_changed)
	
	_set_initial_state(npc_sprite)
	_set_initial_state(player_sprite)
	
	await get_tree().create_timer(1.0).timeout
	EventBus.dialogue_requested.emit("interrogation_day1")

func _set_initial_state(sprite: TextureRect) -> void:
	if sprite:
		sprite.scale = scale_normal
		sprite.modulate.a = alpha_inactive

# --- SISTEMA DE FOCO VISUAL ---

func _on_speaker_changed(character_name: String) -> void:
	# O nome exato que está no banco de dados
	if character_name == "Lusquinha":
		_focus_character(npc_sprite, player_sprite)
	elif character_name == "Você": 
		_focus_character(player_sprite, npc_sprite)

func _focus_character(active_char: TextureRect, inactive_char: TextureRect) -> void:
	if current_tween and current_tween.is_running():
		current_tween.kill()
		
	current_tween = create_tween().set_parallel(true)
	
	if active_char:
		current_tween.tween_property(active_char, "scale", scale_active, 0.3).set_trans(Tween.TRANS_SINE)
		current_tween.tween_property(active_char, "modulate:a", alpha_active, 0.3)
	
	if inactive_char:
		current_tween.tween_property(inactive_char, "scale", scale_normal, 0.3).set_trans(Tween.TRANS_SINE)
		current_tween.tween_property(inactive_char, "modulate:a", alpha_inactive, 0.3)

# --- FIM DO DIA 1 ---

func _on_dialogue_finished() -> void:
	if EventBus.dialogue_finished.is_connected(_on_dialogue_finished):
		EventBus.dialogue_finished.disconnect(_on_dialogue_finished)
	if EventBus.speaker_changed.is_connected(_on_speaker_changed):
		EventBus.speaker_changed.disconnect(_on_speaker_changed)
	
	print("[INVESTIGAÇÃO] Diálogo do Dia 1 encerrado. Aguardando integração futura...")
	# Futuramente, colocaremos a transição para o Dia 2 ou para o Menu aqui
