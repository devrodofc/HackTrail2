extends Control

# Referências aos nós
@onready var volume_slider: HSlider = $MarginContainer/VBoxContainer/Control/HBoxContainer/VolumeSlider
@onready var fullscreen_button: Button = $MarginContainer/VBoxContainer/Spacer2/VBoxContainer/FullscreenButton
@onready var credits_button: Button = $MarginContainer/VBoxContainer/Spacer2/VBoxContainer/CreditsButton
@onready var back_button: Button = $MarginContainer/VBoxContainer/Spacer2/VBoxContainer/BackButton

# Pega o ID do barramento de áudio principal da Godot ("Master")
var master_bus_index: int = AudioServer.get_bus_index("Master")

func _ready() -> void:
	# Configura o slider para mostrar o volume atual do jogo ao abrir a tela
	var current_db = AudioServer.get_bus_volume_db(master_bus_index)
	volume_slider.value = db_to_linear(current_db)
	
	# Foca no slider para quem joga no teclado/controle
	volume_slider.grab_focus()
	
	# Conectando os sinais
	volume_slider.value_changed.connect(_on_volume_changed)
	fullscreen_button.pressed.connect(_on_fullscreen_pressed)
	credits_button.pressed.connect(_on_credits_pressed)
	back_button.pressed.connect(_on_back_pressed)

# --- FUNÇÕES DE SINAIS ---

func _on_volume_changed(value: float) -> void:
	# Converte o valor do slider (0.0 a 1.0) para Decibéis e aplica no som global
	AudioServer.set_bus_volume_db(master_bus_index, linear_to_db(value))
	# Opcional: Aqui você pode tocar um "beep" sonoro para o jogador testar a altura

func _on_fullscreen_pressed() -> void:
	# Verifica o estado atual da tela e inverte
	var current_mode = DisplayServer.window_get_mode()
	if current_mode == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

func _on_credits_pressed() -> void:
	print("Abrindo créditos...")
	# Futuramente: carregar a cena de créditos

func _on_back_pressed() -> void:
	# Volta para o menu principal
	get_tree().change_scene_to_file("res://ui/menus/main/main.tscn")
