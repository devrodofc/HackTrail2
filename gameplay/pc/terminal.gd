extends Control

# Referências visuais
@onready var main_layout: VBoxContainer = $OSWindow/MarginContainer/MainLayout
@onready var task_progress_label: Label = $OSWindow/MarginContainer/MainLayout/HeaderSection/TaskProgressLabel
@onready var ref_code_box: RichTextLabel = $OSWindow/MarginContainer/MainLayout/CodeSplitter/ReferenceBox/RefCodeBox
@onready var student_code_box: RichTextLabel = $OSWindow/MarginContainer/MainLayout/CodeSplitter/StudentBox/StudentCodeBox

@onready var approve_btn: TextureButton = $OSWindow/MarginContainer/MainLayout/ActionButtons/ApproveButton
@onready var reject_btn: TextureButton = $OSWindow/MarginContainer/MainLayout/ActionButtons/RejectButton
@onready var hack_btn: TextureButton = $OSWindow/MarginContainer/MainLayout/ActionButtons/HackButton

# Controle da rodada
var current_tasks: Array = []
var current_task_index: int = 0
var score_for_the_day: int = 0

# --- NOVAS VARIÁVEIS DO TIMER ---
var time_left: int = 60 # Tempo total do dia em segundos (Mude para quanto quiser)
var is_game_active: bool = true
var countdown_timer: SceneTreeTimer = null

func _ready() -> void:
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
	print("O TEMPO ACABOU!")
	
	# TRAVA TOTAL: Desabilita todos os botões para o jogador não interagir mais
	approve_btn.disabled = true
	reject_btn.disabled = true
	hack_btn.disabled = true
	
	# Avisa o professor pelo banco de diálogos (muda o fluxo narrativo)
	# Vamos criar esse diálogo no DialogueDB na sequência
	EventBus.dialogue_requested.emit("time_out_pc")

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
	print("Análises finalizadas com sucesso!")
	# Trava a tela e pede o diálogo de fim de expediente normal
	approve_btn.disabled = true
	reject_btn.disabled = true
	hack_btn.disabled = true
	
	EventBus.dialogue_requested.emit("day_finished_pc")
