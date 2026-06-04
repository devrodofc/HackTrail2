extends Control

signal hacker_phase_finished

# Referências Visuais Exportadas
@export var main_layout: VBoxContainer
@export var task_progress_label: Label
@export var ref_code_box: RichTextLabel
@export var fix_code_edit: CodeEdit

@export var compile_btn: TextureButton

# Variáveis de controle do minigame
var tasks_to_fix: Array = []
var current_fix_index: int = 0
var fix_time_left: int = 90
var is_fixing: bool = false

func _ready() -> void:
	if main_layout:
		main_layout.modulate.a = 0.0
	compile_btn.pressed.connect(_on_compile_pressed)

func boot_system() -> void:
	tasks_to_fix = GameManager.hacked_tasks_to_fix
	
	if tasks_to_fix.size() == 0:
		print("Nenhuma ameaça detectada na fase anterior. Pulando correção...")
		hacker_phase_finished.emit()
		return
		
	var tween = create_tween()
	tween.tween_property(main_layout, "modulate:a", 1.0, 1.0)
	await tween.finished
	
	is_fixing = true
	current_fix_index = 0
	update_fix_ui()
	start_countdown()

func start_countdown() -> void:
	while fix_time_left > 0 and is_fixing:
		update_time_display()
		await get_tree().create_timer(1.0).timeout
		fix_time_left -= 1
		
	if is_fixing:
		time_out_defeat()

func update_time_display() -> void:
	var progress_text = "MITIGAÇÃO: " + str(current_fix_index + 1) + " / " + str(tasks_to_fix.size())
	var time_text = " | TEMPO CRÍTICO: " + str(fix_time_left) + "s"
	task_progress_label.text = progress_text + time_text

func update_fix_ui() -> void:
	var current_task = tasks_to_fix[current_fix_index]
	
	update_time_display() 
	ref_code_box.text = current_task["reference_code"]
	fix_code_edit.text = current_task["student_code"]

func _on_compile_pressed() -> void:
	if not is_fixing: return
	
	var expected_clean_code = tasks_to_fix[current_fix_index]["reference_code"]
	var player_written_code = fix_code_edit.text
	
	if player_written_code.strip_edges() == expected_clean_code.strip_edges():
		print("COMPILAÇÃO BEM SUCEDIDA! Ameaça neutralizada.")
		advance_to_next_fix()
	else:
		print("ERRO DE COMPILAÇÃO! O código ainda contém anomalias.")

func advance_to_next_fix() -> void:
	current_fix_index += 1
	
	if current_fix_index < tasks_to_fix.size():
		update_fix_ui()
	else:
		print("TODAS AS AMEAÇAS FORAM MITIGADAS!")
		finish_hacker_phase()

func time_out_defeat() -> void:
	is_fixing = false
	compile_btn.disabled = true
	hacker_phase_finished.emit()

func finish_hacker_phase() -> void:
	is_fixing = false
	compile_btn.disabled = true
	GameManager.hacked_tasks_to_fix.clear() 
	hacker_phase_finished.emit()
