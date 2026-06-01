extends Control

# Referências aos nós
@onready var volume_slider: HSlider = $MarginContainer/VBoxContainer/Control/HBoxContainer/VolumeSlider
@onready var fullscreen_button: Button = $MarginContainer/VBoxContainer/Spacer2/VBoxContainer/FullscreenButton
@onready var credits_button: Button = $MarginContainer/VBoxContainer/Spacer2/VBoxContainer/CreditsButton
@onready var back_button: Button = $MarginContainer/VBoxContainer/Spacer2/VBoxContainer/BackButton

# Pega o ID do barramento de áudio principal da Godot ("Master")
var master_bus_index: int = AudioServer.get_bus_index("Master")

var selected_button: Button = null
var pulse_time := 0.0

func _ready() -> void:
	# Espera o layout dos containers terminar
	await get_tree().process_frame
	
	# Configura o slider para mostrar o volume atual do jogo ao abrir a tela
	var current_db = AudioServer.get_bus_volume_db(master_bus_index)
	volume_slider.value = db_to_linear(current_db)
	
	# Configura visual dos botões
	_setup_button(fullscreen_button)
	_setup_button(credits_button)
	_setup_button(back_button)
	
	# Foca no slider para quem joga no teclado/controle
	volume_slider.grab_focus()
	
	# Conectando os sinais
	volume_slider.value_changed.connect(_on_volume_changed)
	fullscreen_button.pressed.connect(_on_fullscreen_pressed)
	credits_button.pressed.connect(_on_credits_pressed)
	back_button.pressed.connect(_on_back_pressed)

func _process(delta: float) -> void:
	pulse_time += delta
	
	if selected_button == null:
		return
	
	var pulse = 1.08 + sin(pulse_time * 4.0) * 0.025
	selected_button.scale = Vector2(pulse, pulse)
	
	if sin(pulse_time * 18.0) > 0.96:
		selected_button.modulate = Color("#FF2BD6")
	else:
		selected_button.modulate = Color("#00C8E8")

func _setup_button(button: Button) -> void:
	button.pivot_offset = button.size / 2
	
	button.mouse_entered.connect(func():
		_select_button(button)
	)
	
	button.mouse_exited.connect(func():
		if button != selected_button:
			_reset_button(button)
	)
	
	button.focus_entered.connect(func():
		_select_button(button)
	)

func _select_button(button: Button) -> void:
	if selected_button != null and selected_button != button:
		_reset_button(selected_button)
	
	selected_button = button
	selected_button.scale = Vector2(1.08, 1.08)
	selected_button.modulate = Color("#00C8E8")
	pulse_time = 0.0

func _reset_button(button: Button) -> void:
	button.scale = Vector2.ONE
	button.modulate = Color("#F2F4F8")

# --- FUNÇÕES DE SINAIS ---

func _on_volume_changed(value: float) -> void:
	# Converte o valor do slider (0.0 a 1.0) para Decibéis e aplica no som global
	AudioServer.set_bus_volume_db(master_bus_index, linear_to_db(value))

func _on_fullscreen_pressed() -> void:
	# Verifica o estado atual da tela e inverte
	var current_mode = DisplayServer.window_get_mode()
	
	if current_mode == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://ui/menus/credits/credits.tscn")

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://ui/menus/main/main.tscn")
