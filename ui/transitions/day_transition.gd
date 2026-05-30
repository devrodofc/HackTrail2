extends Control

@onready var day_label: Label = $CenterContainer/DayLabel
@onready var anim_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	# Atualiza o texto dinamicamente perguntando ao GameManager
	day_label.text = "DIA " + str(GameManager.current_day)
	
	# Garante que a Label comece invisível antes da animação rodar
	day_label.modulate.a = 0
	
	# Conecta o sinal de quando a animação terminar para pularmos de cena
	anim_player.animation_finished.connect(_on_animation_finished)
	
	# Inicia a animação de Fade
	anim_player.play("fade")

func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "fade":
		print("Transição concluída. Carregando o gameplay do Dia ", GameManager.current_day, "...")
		
		# AQUI VAMOS CARREGAR A CENA DO COMPUTADOR / LABORATÓRIO!
		# get_tree().change_scene_to_file("res://gameplay/pc_interface/pc_main.tscn")
