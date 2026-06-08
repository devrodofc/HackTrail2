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
		if GameManager.current_day == 1:
			# Para o Dia 1 (início do jogo), vai para a introdução
			get_tree().change_scene_to_file("res://gameplay/lore/intro/intro_lore.tscn")
			
		elif GameManager.current_day == 2:
			# MUDANÇA AQUI: No início do Dia 2, o jogador vê a conclusão do caso Lusquinha primeiro!
			# Lembre-se de confirmar se o caminho da cena está correto no seu projeto
			get_tree().change_scene_to_file("res://gameplay/lore/conclusion_day2/conclusion_day2.tscn")
			
		else:
			# Dia 3 em diante: Vai direto trabalhar no PC (até criarmos mais histórias depois)
			get_tree().change_scene_to_file("res://gameplay/pc/pc_main.tscn")
