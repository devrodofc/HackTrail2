extends Control

@onready var play_button: Button = $MarginContainer/VBoxContainer/Control/TitleLabel/Spacer/VBoxContainer/PlayButton
@onready var options_button: Button = $MarginContainer/VBoxContainer/Control/TitleLabel/Spacer/VBoxContainer/OptionsButton
@onready var quit_button: Button = $MarginContainer/VBoxContainer/Control/TitleLabel/Spacer/VBoxContainer/QuitButton

func _ready() -> void:
	# Foca no botão Jogar automaticamente para quem joga no teclado
	play_button.grab_focus()
	
	# Conectando os sinais dos botões via código (Código limpo e seguro)
	play_button.pressed.connect(_on_play_button_pressed)
	options_button.pressed.connect(_on_options_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)

func _on_play_button_pressed() -> void:
	print("Iniciando Hacktrail...")
	# Aqui dizemos ao GameManager que o jogo vai começar!
	GameManager.start_game()
	
	# Futuramente: carregar a cena do primeiro dia ou da introdução
	# get_tree().change_scene_to_file("res://gameplay/interrogation/intro.tscn")

func _on_options_button_pressed() -> void:
	print("Abrindo menu de opções...")
	# Futuramente: Instanciar o menu de opções aqui

func _on_quit_button_pressed() -> void:
	print("Saindo do sistema...")
	# Fecha o jogo com segurança
	get_tree().quit()
