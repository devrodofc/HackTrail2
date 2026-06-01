extends Node2D

@onready var camera: Camera2D = $Camera2D
@onready var start_button: TextureButton = $StartButton
@onready var terminal: Control = $Terminal # Pega a referência direta do terminal oculto

func _ready() -> void:
	start_button.disabled = true
	terminal.hide() # Garante que o computador comece desligado
	
	await get_tree().create_timer(1.0).timeout
	start_dialogue_tutorial()

func start_dialogue_tutorial() -> void:
	EventBus.dialogue_finished.connect(_on_tutorial_finished)
	EventBus.dialogue_requested.emit("tutorial_pc")

func _on_tutorial_finished() -> void:
	EventBus.dialogue_finished.disconnect(_on_tutorial_finished)
	start_button.disabled = false

func _on_start_button_pressed() -> void:
	start_button.disabled = true
	start_button.hide() # O botão some imediatamente ao clicar
	
	apply_zoom_effect()

func apply_zoom_effect() -> void:
	# Descobre onde fica o centro exato do terminal no mundo para a câmera focar
	var terminal_center = terminal.global_position + (terminal.size * terminal.scale / 2.0)
	
	var tween = create_tween()
	
	# Move a câmera para o centro do monitor físico
	tween.parallel().tween_property(camera, "global_position", terminal_center, 2.0).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN_OUT)
	
	# Dá o zoom (Ajuste o valor para que o terminal ocupe a tela inteira do jogador)
	# Se a escala do seu terminal no mundo for 0.25, um zoom de 4.0 (1 / 0.25) fará ele preencher a tela perfeitamente!
	tween.parallel().tween_property(camera, "zoom", Vector2(4.0, 4.0), 2.0).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN_OUT)
	
	await tween.finished
	print("Zoom concluído. Ligando o monitor...")
	
	# O computador acende exatamente onde foi posicionado, sem erros de proporção!
	terminal.show()
