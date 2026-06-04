extends Control

signal phase_finished

# Referências Visuais Exportadas
@export var main_layout: VBoxContainer
@export var task_progress_label: Label
@export var ref_code_box: RichTextLabel
@export var student_code_box: RichTextLabel

@export var approve_btn: TextureButton
@export var reject_btn: TextureButton
@export var hack_btn: TextureButton

# Controle da rodada
var current_tasks: Array = []
var current_task_index: int = 0
var score_for_the_day: int = 0

# --- NOVAS VARIÁVEIS DO TIMER ---
var time_left: int = 60 # Tempo total do dia em segundos (Mude para quanto quiser)
var is_game_active: bool = true
var countdown_timer: SceneTreeTimer = null

func _ready() -> void:
	if main_layout:
		main_layout.modulate.a = 0.0
	
	approve_btn.pressed.connect(_on_approve_pressed)
	reject_btn.pressed.connect(_on_reject_pressed)
	hack_btn.pressed.connect(_on_hack_pressed)
	
	current_tasks = CodeDB.get_randomized_tasks(GameManager.current_day)
	
	if current_tasks.size() > 0:
		current_task_index = 0
		score_for_the_day = 0
		update_ui_with_task()
	else:
		print("ERRO: Nenhuma tarefa encontrada")

func boot_system() -> void:
	var tween = create_tween()
	tween.tween_property(main_layout, "modulate:a", 1.0, 1.0)
	
	# INICIA O CRONÔMETRO AUTOMATICAMENTE APÓS O CORRETO BOOT
	await tween.finished
	start_countdown()

# --- NOVA LÓGICA DO CRONÔMETRO ---
func start_countdown() -> void:
	while time_left > 0 and is_game_active:
		update_time_display()
		# Espera 1 segundo real do relógio do jogo
		await get_tree().create_timer(1.0).timeout
		time_left -= 1
		
	if is_game_active:
		time_out_defeat()

func update_time_display() -> void:
	# Mantém o progresso de análises visível e anexa o tempo ao lado
	var analysis_text = "ANÁLISE: " + str(current_task_index + 1) + " / " + str(current_tasks.size())
	var time_text = " | TEMPO: " + str(time_left) + "s"
	task_progress_label.text = analysis_text + time_text

# --- O FIM DO TEMPO ---
func time_out_defeat() -> void:
	is_game_active = false
	approve_btn.disabled = true
	reject_btn.disabled = true
	hack_btn.disabled = true
	phase_finished.emit() # Avisa o maestro que acabou

# --- ATUALIZAÇÃO DA TELA ---
func update_ui_with_task() -> void:
	if not is_game_active: return
	
	var task = current_tasks[current_task_index]
	update_time_display() # Garante que o texto de tempo se mantenha atualizado
	
	ref_code_box.text = task["reference_code"]
	student_code_box.text = task["student_code"]

# --- VERIFICAÇÃO DE RESPOSTAS ---
func _on_approve_pressed() -> void:
	evaluate_answer(CodeDB.Status.CORRECT)

func _on_reject_pressed() -> void:
	evaluate_answer(CodeDB.Status.BUGGED)

func _on_hack_pressed() -> void:
	evaluate_answer(CodeDB.Status.HACKED)

func evaluate_answer(player_action: int) -> void:
	# Trava de segurança caso o jogador clique enquanto o tempo acaba
	if not is_game_active or current_task_index >= current_tasks.size():
		return 
		
	var expected_action = current_tasks[current_task_index]["expected_action"]
	
	if player_action == expected_action:
		print("ACERTOU!")
		score_for_the_day += 1
		if expected_action == CodeDB.Status.HACKED:
			# Se o jogador acertou que era um hack, salva a tarefa toda para a próxima fase!
			GameManager.hacked_tasks_to_fix.append(current_tasks[current_task_index])
			print("Tarefa suspeita guardada para análise manual!")
	else:
		print("ERROU!")
		
	advance_to_next_task()

func advance_to_next_task() -> void:
	current_task_index += 1
	
	if current_task_index < current_tasks.size() and is_game_active:
		update_ui_with_task() 
	elif is_game_active:
		# Se ele terminou todas as tarefas dentro do tempo, a fase acaba com sucesso
		is_game_active = false 
		finish_day() 

func finish_day() -> void:
	is_game_active = false
	approve_btn.disabled = true
	reject_btn.disabled = true
	hack_btn.disabled = true
	phase_finished.emit() # Avisa o maestro que acabou
