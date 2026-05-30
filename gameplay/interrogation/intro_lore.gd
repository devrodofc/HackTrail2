extends Control

@onready var anim_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	# 1. Conecta o sinal de diálogo para o futuro
	EventBus.dialogue_finished.connect(_on_dialogue_finished)
	
	# 2. Inicia o Fade In (Professor aparecendo)
	anim_player.play("fade")
	
	# 3. A MÁGICA: Espera o Fade In terminar antes de seguir
	await anim_player.animation_finished
	
	# 4. Agora que ele apareceu, inicia o loop de respiração (Idle)
	anim_player.play("idle")
	
	# 5. Espera um pequeno respiro (0.5s) e inicia o diálogo
	await get_tree().create_timer(0.5).timeout
	EventBus.dialogue_requested.emit("intro_lore")

func _on_dialogue_finished() -> void:
	# Desconecta para evitar repetições
	if EventBus.dialogue_finished.is_connected(_on_dialogue_finished):
		EventBus.dialogue_finished.disconnect(_on_dialogue_finished)
	
	# Vai para a gameplay do PC
	get_tree().change_scene_to_file("")
