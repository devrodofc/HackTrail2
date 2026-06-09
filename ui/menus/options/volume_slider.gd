extends HSlider

# Nome do bus que você criou no AudioServer (ex: "Master" ou "Music")
@export var bus_name: String = "Master"
var bus_index: int

func _ready() -> void:
	# Encontra o índice do barramento pelo nome
	bus_index = AudioServer.get_bus_index(Music)
	
	# Sincroniza o slider com o volume atual do sistema
	value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))
	
	# Conecta o sinal que detecta quando o jogador move o slider
	value_changed.connect(_on_value_changed)

func _on_value_changed(new_value: float) -> void:
	# Converte o valor linear (0 a 1) para Decibéis (o que o AudioServer entende)
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(new_value))
