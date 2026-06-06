extends Control

# Caixinhas para você arrastar as imagens no Inspector
@export var prof_sprite: TextureRect
@export var player_sprite: TextureRect

# Configurações do Efeito Visual (Sutis e Elegantes)
@export var scale_active := Vector2(1.05, 1.05) # Aumenta só um pouquinho (5%)
@export var scale_normal := Vector2(1.0, 1.0)   # Tamanho normal (100%)
@export var alpha_active := 1.0                 # Totalmente sem transparência
@export var alpha_inactive := 0.5               # Meio transparente para quem está calado

var current_tween: Tween

func _ready() -> void:
	# 1. Conecta os sinais
	EventBus.dialogue_finished.connect(_on_dialogue_finished)
	EventBus.speaker_changed.connect(_on_speaker_changed)
	
	# 2. Define o estado inicial (ambos normais e levemente transparentes no segundo 0)
	_set_initial_state(prof_sprite)
	_set_initial_state(player_sprite)
	
	# 3. Dá 1 segundo de respiro ao carregar a tela e depois inicia o diálogo
	await get_tree().create_timer(1.0).timeout
	EventBus.dialogue_requested.emit("intro_lore")

func _set_initial_state(sprite: TextureRect) -> void:
	if sprite:
		sprite.scale = scale_normal
		sprite.modulate.a = alpha_inactive

# --- SISTEMA DE FOCO VISUAL ---

func _on_speaker_changed(character_name: String) -> void:
	# ATENÇÃO: Os nomes aqui devem ser rigorosamente iguais aos que estão no seu DialogueDB!
	if character_name == "Prof. Ronisson":
		_focus_character(prof_sprite, player_sprite)
	elif character_name == "Player": 
		_focus_character(player_sprite, prof_sprite)

func _focus_character(active_char: TextureRect, inactive_char: TextureRect) -> void:
	# Se já tiver um Tween rolando da fala anterior, a gente mata ele pra não bugar
	if current_tween and current_tween.is_running():
		current_tween.kill()
		
	current_tween = create_tween().set_parallel(true)
	
	# O personagem que fala: cresce levemente e fica com cor normal
	if active_char:
		current_tween.tween_property(active_char, "scale", scale_active, 0.3).set_trans(Tween.TRANS_SINE)
		current_tween.tween_property(active_char, "modulate:a", alpha_active, 0.3)
	
	# O personagem que escuta: volta ao tamanho normal e fica transparente
	if inactive_char:
		current_tween.tween_property(inactive_char, "scale", scale_normal, 0.3).set_trans(Tween.TRANS_SINE)
		current_tween.tween_property(inactive_char, "modulate:a", alpha_inactive, 0.3)

# --- TRANSIÇÃO DE CENA ---

func _on_dialogue_finished() -> void:
	if EventBus.dialogue_finished.is_connected(_on_dialogue_finished):
		EventBus.dialogue_finished.disconnect(_on_dialogue_finished)
	if EventBus.speaker_changed.is_connected(_on_speaker_changed):
		EventBus.speaker_changed.disconnect(_on_speaker_changed)
	
	get_tree().change_scene_to_file("res://gameplay/pc/pc_main.tscn")
