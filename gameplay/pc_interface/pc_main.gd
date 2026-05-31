extends Node2D

@onready var camera: Camera2D = $Camera2D
@onready var start_button: TextureButton = $CanvasLayer/InteractionArea/StartButton
@onready var anim_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	# Começa com o botão de ligar desabilitado até o tutorial acabar
	start_button.disabled = true
	
	# Inicia o tutorial após 1 segundo
	await get_tree().create_timer(1.0).timeout
	start_dialogue_tutorial()

func start_dialogue_tutorial() -> void:
	# Conecta para saber quando o tutorial terminar
	EventBus.dialogue_finished.connect(_on_tutorial_finished)
	# Dispara um ID de diálogo novo que você deve criar no DialogueDB
	EventBus.dialogue_requested.emit("tutorial_pc")

func _on_tutorial_finished() -> void:
	EventBus.dialogue_finished.disconnect(_on_tutorial_finished)
	# Agora o player pode clicar no botão de ligar
	start_button.disabled = false
	print("Tutorial concluído. Aguardando clique no botão de ligar...")

func _on_start_button_pressed() -> void:
	start_button.disabled = true # Evita cliques duplos
	
	# 1. Toca um som de clique (opcional)
	# 2. Inicia o efeito de Zoom
	apply_zoom_effect()

func apply_zoom_effect() -> void:
	var tween = create_tween()
	# Suaviza o zoom da câmera para 4x o tamanho original em 2 segundos
	# Ajuste o valor de Vector2(4, 4) conforme o tamanho do seu monitor na arte
	tween.tween_property(camera, "zoom", Vector2(2.5, 2.5), 2.0).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN_OUT)
	
	# Ao mesmo tempo, podemos escurecer o fundo ou fazer um efeito de brilho
	
	await tween.finished
	print("Zoom concluído. Ligando o sistema...")
	# Aqui chamaremos a cena do sistema operacional/gameplay!
