extends Node2D

@onready var camera: Camera2D = $Camera2D
@onready var start_button: TextureButton = $StartButton

# Certifique-se de que estes dois nós na árvore estão usando os scripts corretos!
@onready var terminal_fase1: Control = $Terminal
@onready var terminal_fase2: Control = $TerminalHacker 

var current_state: String = "intro"

func _ready() -> void:
	# Começa com tudo escondido e botão travado
	terminal_fase1.hide()
	terminal_fase2.hide()
	start_button.disabled = true
	
	# Conecta os sinais de conclusão das fases
	terminal_fase1.phase_finished.connect(_on_fase1_finished)
	terminal_fase2.hacker_phase_finished.connect(_on_fase2_finished)
	
	EventBus.dialogue_finished.connect(_on_dialogue_finished)
	
	await get_tree().create_timer(1.0).timeout
	
	# 1. COMEÇA COM O DIÁLOGO INICIAL
	current_state = "intro"
	EventBus.dialogue_requested.emit("tutorial_pc") 

func _on_dialogue_finished() -> void:
	if current_state == "intro":
		# Diálogo 1 acabou, libera o botão de power
		start_button.disabled = false
		
	elif current_state == "hacker_intro":
		# DIÁLOGO DO HACKER ACABOU, COMEÇA A GAMEPLAY 2 (EDITAR)
		current_state = "hacker_gameplay"
		terminal_fase1.hide() # Apaga a UI velha
		terminal_fase2.show() # Mostra a UI nova no mesmo lugar
		terminal_fase2.boot_system() # Inicia a Fase 2
		
	elif current_state == "end":
		pass # Espaço reservado para transição final (mudar de cena, etc)

func _on_start_button_pressed() -> void:
	# 2. CLICA NO BOTÃO E DÁ ZOOM
	start_button.disabled = true
	start_button.hide()
	
	var tween = create_tween()
	tween.tween_property(camera, "zoom", Vector2(3.0, 3.0), 2.0).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	
	# 3. COMEÇA A GAMEPLAY 1 (APROVAR/REPROVAR)
	current_state = "fase1_gameplay"
	terminal_fase1.show()
	terminal_fase1.boot_system()

func _on_fase1_finished() -> void:
	# 4. TERMINA OS CÓDIGOS OU O TEMPO DA FASE 1 E CHAMA DIÁLOGO DO HACKER
	current_state = "hacker_intro"
	EventBus.dialogue_requested.emit("tutorial_hacker_fix")

func _on_fase2_finished() -> void:
	# 5. TERMINA A FASE 2
	current_state = "end"
	EventBus.dialogue_requested.emit("hacker_phase_success")
