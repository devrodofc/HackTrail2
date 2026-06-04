extends Control

# Referências visuais aos nós
@onready var main_layout: VBoxContainer = $OSWindow/MarginContainer/MainLayout
@onready var task_progress_label: Label = $OSWindow/MarginContainer/MainLayout/HeaderSection/TaskProgressLabel

@onready var ref_code_box: RichTextLabel = $OSWindow/MarginContainer/MainLayout/CodeSplitter/ReferenceBox/RefCodeBox
@onready var fix_code_edit: CodeEdit = $OSWindow/MarginContainer/MainLayout/CodeSplitter/FixBox/FixCodeEdit

@onready var compile_btn: TextureButton = $OSWindow/MarginContainer/MainLayout/ActionButtons/CompileButton

# Variáveis de controle do minigame
var tasks_to_fix: Array = []
var current_fix_index: int = 0
var fix_time_left: int = 90 # Tempo em segundos para corrigir os códigos
var is_fixing: bool = false

func _ready() -> void:
	# Esconde a interface no início, deixando apenas a tela preta do OSWindow
	main_layout.modulate.a = 0.0
	
	compile_btn.pressed.connect(_on_compile_pressed)
	
	# Inicia a sequência de diálogo antes de mostrar a tela
	start_hacker_dialogue()

# --- SEQUÊNCIA DE INICIALIZAÇÃO ---

func start_hacker_dialogue() -> void:
	EventBus.dialogue_finished.connect(_on_dialogue_finished)
	# Dispara o diálogo do professor explicando a fase (lembre de criar no DialogueDB)
	EventBus.dialogue_requested.emit("tutorial_hacker_fix") 

func _on_dialogue_finished() -> void:
	if EventBus.dialogue_finished.is_connected(_on_dialogue_finished):
		EventBus.dialogue_finished.disconnect(_on_dialogue_finished)
	
	# Puxa os dados das ameaças que o jogador encontrou na fase anterior
	tasks_to_fix = GameManager.hacked_tasks_to_fix
	
	if tasks_to_fix.size() > 0:
		current_fix_index = 0
		# CHAMADA ATUALIZADA AQUI:
		boot_system()
	else:
		# Caso o jogador não tenha classificado nada como "HACKED" na fase 1
		print("Nenhuma ameaça detectada na fase anterior. Pulando correção...")
		finish_hacker_phase()

# NOME DA FUNÇÃO ATUALIZADO AQUI:
func boot_system() -> void:
	var tween = create_tween()
	# Faz o terminal "acender" suavemente
	tween.tween_property(main_layout, "modulate:a", 1.0, 1.0)
	await tween.finished
	
	is_fixing = true
	update_fix_ui()
	start_countdown()

# --- SISTEMA DE TEMPO ---

func start_countdown() -> void:
	while fix_time_left > 0 and is_fixing:
		update_time_display()
		await get_tree().create_timer(1.0).timeout
		fix_time_left -= 1
		
	if is_fixing:
		time_out_defeat()

func update_time_display() -> void:
	# Junta a tarefa atual com o tempo restante, mantendo o padrão visual
	var progress_text = "MITIGAÇÃO: " + str(current_fix_index + 1) + " / " + str(tasks_to_fix.size())
	var time_text = " | TEMPO CRÍTICO: " + str(fix_time_left) + "s"
	
	task_progress_label.text = progress_text + time_text

# --- ATUALIZAÇÃO E VALIDAÇÃO ---

func update_fix_ui() -> void:
	var current_task = tasks_to_fix[current_fix_index]
	
	update_time_display() # Garante que o texto fique correto instantaneamente
	
	# Preenche o gabarito limpo na esquerda
	ref_code_box.text = current_task["reference_code"]
	# Preenche o código infectado na direita para o jogador editar
	fix_code_edit.text = current_task["student_code"]

func _on_compile_pressed() -> void:
	if not is_fixing: return
	
	var expected_clean_code = tasks_to_fix[current_fix_index]["reference_code"]
	var player_written_code = fix_code_edit.text
	
	# Verifica se o jogador deixou o código igual ao gabarito
	# Usamos strip_edges() para ignorar espaços em branco extras no início/fim e não punir o jogador à toa
	if player_written_code.strip_edges() == expected_clean_code.strip_edges():
		print("COMPILAÇÃO BEM SUCEDIDA! Ameaça neutralizada.")
		advance_to_next_fix()
	else:
		print("ERRO DE COMPILAÇÃO! O código ainda contém anomalias.")
		# Espaço reservado para tocar um som de erro ou tremer a tela

func advance_to_next_fix() -> void:
	current_fix_index += 1
	
	if current_fix_index < tasks_to_fix.size():
		update_fix_ui()
	else:
		print("TODAS AS AMEAÇAS FORAM MITIGADAS!")
		finish_hacker_phase()

# --- FINAIS DA FASE ---

func time_out_defeat() -> void:
	is_fixing = false
	compile_btn.disabled = true
	print("TEMPO ESGOTADO. O SISTEMA FOI COMPROMETIDO.")
	# Emite o diálogo de derrota
	EventBus.dialogue_requested.emit("hacker_time_out")

func finish_hacker_phase() -> void:
	is_fixing = false
	compile_btn.disabled = true
	
	# Limpa a memória do GameManager para não acumular para o próximo dia
	GameManager.hacked_tasks_to_fix.clear() 
	
	# Emite o diálogo de sucesso
	EventBus.dialogue_requested.emit("hacker_phase_success")
