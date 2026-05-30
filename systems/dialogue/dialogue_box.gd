extends CanvasLayer

@onready var container: Control = $DialogueContainer
@onready var name_label: Label = $DialogueContainer/PanelContainer/MarginContainer/VBoxContainer/Control/NameLabel
@onready var text_label: RichTextLabel = $DialogueContainer/PanelContainer/MarginContainer/VBoxContainer/Control/TextLabel

var current_dialogue_lines: Array = []
var current_line_index: int = 0
var is_typing: bool = false
var tween: Tween

func _ready() -> void:
	# Começa invisível/escondido
	container.hide()
	
	# Conecta ao EventBus global
	EventBus.dialogue_requested.connect(_on_dialogue_requested)

func _input(event: InputEvent) -> void:
	# Se a caixa de diálogo não estiver na tela, ignoramos qualquer botão apertado
	if not container.visible:
		return
		
	# Verifica se foi um clique com o botão ESQUERDO do mouse
	var is_mouse_click = event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed
	# Verifica se foi a tecla de confirmar (Enter, Espaço ou botão A do controle)
	var is_action_accept = event.is_action_pressed("ui_accept")

	# Se for um clique ou um Enter/Espaço, avançamos o texto
	if is_mouse_click or is_action_accept:
		if is_typing:
			# Se ainda está digitando, pula a animação direto para o texto completo
			complete_typing()
		else:
			# Se já terminou de digitar, avança para a próxima linha
			advance_dialogue()

func _on_dialogue_requested(dialogue_id: String) -> void:
	current_dialogue_lines = DialogueDB.get_dialogue(dialogue_id)
	if current_dialogue_lines.size() > 0:
		current_line_index = 0
		container.show()
		display_current_line()

func display_current_line() -> void:
	var line_data = current_dialogue_lines[current_line_index]
	name_label.text = line_data["name"]
	text_label.text = line_data["text"]
	
	# Efeito Máquina de Escrever usando Tween
	text_label.visible_characters = 0
	is_typing = true
	
	if tween:
		tween.kill() # Garante que nenhuma animação antiga interfira
	
	tween = create_tween()
	# Calcula a duração com base no tamanho do texto (0.03 segundos por caractere)
	var duration = text_label.text.length() * 0.03
	tween.tween_property(text_label, "visible_characters", text_label.text.length(), duration)
	tween.finished.connect(func(): is_typing = false)

func complete_typing() -> void:
	if tween:
		tween.kill()
	text_label.visible_characters = text_label.text.length()
	is_typing = false

func advance_dialogue() -> void:
	current_line_index += 1
	if current_line_index < current_dialogue_lines.size():
		display_current_line()
	else:
		# Acabaram as linhas do ID solicitado
		container.hide()
		EventBus.dialogue_finished.emit()
		
