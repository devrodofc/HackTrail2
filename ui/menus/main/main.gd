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
	# Instancie ou certifique-se que a DialogueBox está ativa na cena para ouvir o sinal
	EventBus.dialogue_requested.emit("intro_tutorial_professor")
	print("oioi")

func _on_options_button_pressed() -> void:
	get_tree().change_scene_to_file("res://ui/menus/options/options.tscn")

func _on_quit_button_pressed() -> void:
	print("Saindo do sistema...")
	# Fecha o jogo com segurança
	get_tree().quit()
