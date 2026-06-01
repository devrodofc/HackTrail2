extends Control

# Referências visuais aos nós de texto e botões
@onready var task_progress_label: Label = $OSWindow/MarginContainer/MainLayout/HeaderSection/TaskProgressLabel
@onready var ref_code_box: RichTextLabel = $OSWindow/MarginContainer/MainLayout/CodeSplitter/ReferenceBox/RefCodeBox
@onready var student_code_box: RichTextLabel = $OSWindow/MarginContainer/MainLayout/CodeSplitter/StudentBox/StudentCodeBox

@onready var approve_btn: TextureButton = $OSWindow/MarginContainer/MainLayout/ActionButtons/ApproveButton
@onready var reject_btn: TextureButton = $OSWindow/MarginContainer/MainLayout/ActionButtons/RejectButton
@onready var hack_btn: TextureButton = $OSWindow/MarginContainer/MainLayout/ActionButtons/HackButton

# Variáveis de controle da rodada
var current_tasks: Array = []
var current_task_index: int = 0
var score_for_the_day: int = 0

func _ready() -> void:
	# Conecta os botões
	approve_btn.pressed.connect(_on_approve_pressed)
	reject_btn.pressed.connect(_on_reject_pressed)
	hack_btn.pressed.connect(_on_hack_pressed)
	
	# Pede as tarefas do dia atual ao nosso CodeDB
	current_tasks = CodeDB.get_randomized_tasks(GameManager.current_day)
	
	# Inicia a tela
	if current_tasks.size() > 0:
		current_task_index = 0
		score_for_the_day = 0
		update_ui_with_task()
	else:
		print("ERRO: Nenhuma tarefa encontrada para o dia ", GameManager.current_day)

# --- ATUALIZAÇÃO DA TELA ---

func update_ui_with_task() -> void:
	# Pega o dicionário da tarefa atual na lista
	var task = current_tasks[current_task_index]
	
	# Preenche os textos na tela
	task_progress_label.text = "ANÁLISE: " + str(current_task_index + 1) + " / " + str(current_tasks.size())
	
	# Preenche as caixas de código
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
	
	if current_task_index >= current_tasks.size():
		return # Ignora o clique se já passamos do limite
		
	var expected_action = current_tasks[current_task_index]["expected_action"]
	
	if player_action == expected_action:
		print("ACERTOU! Boa análise.")
		score_for_the_day += 1
		# Futuramente: Tocar som de acerto, animar tela verde
	else:
		print("ERROU! O jogador fez a análise errada.")
		# Futuramente: Tocar som de erro, piscar tela vermelha, subtrair tempo
		
	# Guarda a pista do hacker no GameManager se a ação envolver um hack
	if expected_action == CodeDB.Status.HACKED and current_tasks[current_task_index]["hacker_clue"] != "":
		# Vamos criar isso no GameManager no futuro!
		pass 
	
	# Passa para a próxima tarefa
	advance_to_next_task()

func advance_to_next_task() -> void:
	current_task_index += 1
	
	if current_task_index < current_tasks.size():
		update_ui_with_task() # Carrega o próximo código
	else:
		finish_day() # Acabou a pilha de tarefas

func finish_day() -> void:
	print("Análises finalizadas! Pontuação: ", score_for_the_day, "/", current_tasks.size())
	# Aqui a tela do computador vai desligar e vamos para o minigame de Interrogatório!
	# EventBus.day_ended.emit(true)
