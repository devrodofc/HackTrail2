extends Control

@onready var play_button: Button = $MarginContainer/VBoxContainer/Spacer/VBoxContainer/PlayButton
@onready var options_button: Button = $MarginContainer/VBoxContainer/Spacer/VBoxContainer/OptionsButton
@onready var quit_button: Button = $MarginContainer/VBoxContainer/Spacer/VBoxContainer/QuitButton

func _ready() -> void:
	# Foca no botão Jogar automaticamente para quem joga no teclado
	play_button.grab_focus()
	
	# Conectando os sinais dos botões via código (Código limpo e seguro)
	play_button.pressed.connect(_on_play_button_pressed)
	options_button.pressed.connect(_on_options_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)
	
func _on_play_button_pressed() -> void:
	# Dizemos ao sistema que o jogo começou (isso seta o current_day para 1)
	GameManager.start_game() 
	get_tree().change_scene_to_file("res://ui/transitions/day_transition.tscn")

func _on_options_button_pressed() -> void:
	get_tree().change_scene_to_file("res://ui/menus/options/options.tscn")

func _on_quit_button_pressed() -> void:
	print("Saindo do sistema...")
	# Fecha o jogo com segurança
	get_tree().quit()
