extends Node2D

@onready var camera: Camera2D = $Camera2D
@onready var start_button: TextureButton = $StartButton
@onready var terminal: Control = $Terminal

func _ready() -> void:
	# REMOVA O terminal.hide() DAQUI! O terminal precisa ficar visível para mostrar a tela preta.
	start_button.disabled = true
	
	await get_tree().create_timer(1.0).timeout
	start_dialogue_tutorial()

func start_dialogue_tutorial() -> void:
	EventBus.dialogue_finished.connect(_on_tutorial_finished)
	EventBus.dialogue_requested.emit("tutorial_pc")

func _on_tutorial_finished() -> void:
	if EventBus.dialogue_finished.is_connected(_on_tutorial_finished):
		EventBus.dialogue_finished.disconnect(_on_tutorial_finished)
	
	# Libera o botão de ligar para o jogador
	start_button.disabled = false

func _on_start_button_pressed() -> void:
	start_button.disabled = true
	start_button.hide() # O botão some imediatamente ao ser clicado
	
	apply_zoom_effect()

func apply_zoom_effect() -> void:
	var tween = create_tween()
	
	# Apenas altera o zoom. A câmera vai focar exatamente onde o nó dela foi posicionado no editor.
	tween.tween_property(camera, "zoom", Vector2(2.5, 2.5), 2.0).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN_OUT)
	
	await tween.finished
	print("Zoom concluído. Acendendo o Terminal...")
	
	# Como o Terminal já existe na árvore, basta torná-lo visível!
	terminal.boot_system()
