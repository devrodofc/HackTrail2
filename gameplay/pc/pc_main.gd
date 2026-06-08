extends Node2D

@onready var camera: Camera2D = $Camera2D
@onready var start_button: TextureButton = $StartButton
@onready var terminal_fase1: Control = $Terminal
@onready var terminal_fase2: Control = $TerminalHacker 

var current_state: String = "init"

func _ready() -> void:
	print("[MAESTRO] 1. Iniciando cena...")
	terminal_fase1.show()
	terminal_fase2.hide()
	
	# TRAVA 1: Previne que apertar "Espaço" ou "Enter" no diálogo clique no botão sem querer
	start_button.focus_mode = Control.FOCUS_NONE 
	start_button.disabled = true
	
	terminal_fase1.phase_finished.connect(_on_fase1_finished)
	terminal_fase2.hacker_phase_finished.connect(_on_fase2_finished)
	EventBus.dialogue_finished.connect(_on_dialogue_finished)
	
	await get_tree().create_timer(1.0).timeout
	
	# =========================================================
	# MUDANÇA AQUI: Verifica o dia antes de chamar o diálogo
	# =========================================================
	if GameManager.current_day == 1:
		print("[MAESTRO] 2. Dia 1. Chamando primeiro diálogo...")
		current_state = "intro"
		EventBus.dialogue_requested.emit("tutorial_pc")
	else:
		print("[MAESTRO] 2. Dia 2+. Pulando tutorial.")
		current_state = "waiting_button"
		start_button.disabled = false # Libera o botão imediatamente
	# =========================================================

func _on_dialogue_finished() -> void:
	print("[MAESTRO] 3. Diálogo fechado. Estado atual era: ", current_state)
	
	if current_state == "intro":
		print("[MAESTRO] 4. Liberando o botão de ligar o PC.")
		current_state = "waiting_button" 
		start_button.disabled = false
		
	elif current_state == "hacker_intro":
		print("[MAESTRO] 8. Diálogo do hacker concluído. Ligando Fase 2...")
		current_state = "hacker_gameplay"
		terminal_fase1.hide() 
		terminal_fase2.show() 
		terminal_fase2.boot_system() 
		
	elif current_state == "end":
		# MUDANÇA AQUI: Transição para a sala de interrogatório
		print("[MAESTRO] 10. PC desligado. Indo para a sala de interrogatório...")
		# Desconecta os sinais do PC antes de mudar de cena para não vazar memória
		if EventBus.dialogue_finished.is_connected(_on_dialogue_finished):
			EventBus.dialogue_finished.disconnect(_on_dialogue_finished)
			
		get_tree().change_scene_to_file("res://gameplay/lore/investigation_day1/investigation_day_1.tscn")

func _on_start_button_pressed() -> void:
	print("[MAESTRO] 5. Botão CLICADO fisicamente! Iniciando Zoom...")
	
	# TRAVA 3: Só deixa clicar se for a hora certa
	if current_state != "waiting_button": 
		print("Clique ignorado por segurança.")
		return 
	
	current_state = "zooming"
	start_button.disabled = true
	start_button.hide()
	
	var tween = create_tween()
	tween.tween_property(camera, "zoom", Vector2(2.5, 2.5), 2.0).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	
	print("[MAESTRO] 6. Zoom concluído. Dando boot na Fase 1...")
	current_state = "fase1_gameplay"
	terminal_fase1.show()
	terminal_fase1.boot_system()

func _on_fase1_finished() -> void:
	print("[MAESTRO] 7. Fase 1 encerrou! Chamando diálogo do hacker...")
	current_state = "hacker_intro"
	EventBus.dialogue_requested.emit("tutorial_hacker_fix")

func _on_fase2_finished() -> void:
	print("[MAESTRO] 9. Fase 2 encerrou com sucesso!")
	current_state = "end"
	EventBus.dialogue_requested.emit("hacker_phase_success")
