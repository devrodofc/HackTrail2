class_name DialogueDB
extends Node

# Estrutura: "ID_DO_DIALOGO": [ { "name": "Quem fala", "text": "O que fala" }, ... ]
const DATA: Dictionary = {
	"intro_lore": [
		{
			"name": "Prof. Ronisson",
			"text": "Bem-vindo ao laboratório de programação da Unifor. Hoje o dia será longo..."
		},
		{
			"name": "Prof. Ronisson",
			"text": "Algum engraçadinho invadiu o sistema ontem. Preciso que você analise o código dos alunos."
		},
		{
			"name": "Prof. Ronisson",
			"text": "Fique atento a códigos maliciosos ou comportamentos estranhos. Não temos muito tempo!"
		}
	],
	"aluno_suspeito": [
		{
			"name": "Lorrân",
			"text": "Eu? Professor, eu passei a noite inteira atualizando o SSD, juro!"
		}
	],
	"tutorial_pc": [
		{
			"name": "Prof. Ronisson",
			"text": "Bem vindo à sala de aula, aqui lhe ensinarei a analisar os códigos dos alunos"
		}
	],
	"time_out_pc": [
		{
			"name": "Professor Ronisson",
			"text": "BIP... BIP... Bloqueio de segurança ativado! Seu tempo de expediente no terminal esgotou."
		},
		{
			"name": "Professor Ronisson",
			"text": "Precisamos ir para a próxima fase da investigação. Saia do computador e venha falar comigo na sala de interrogatórios imediatamente."
		}
	],
	"day_finished_pc": [
		{
			"name": "Professor Ronisson",
			"text": "Excelente trabalho analisando os dados dos alunos, sua cota do dia foi batida com sucesso."
		},
		{
			"name": "Professor Ronisson",
			"text": "O terminal foi encriptado. Vamos para a próxima fase. É hora de descobrir quem plantou esses códigos maliciosos."
		}
	]
}

static func get_dialogue(id: String) -> Array:
	if DATA.has(id):
		return DATA[id]
	push_error("Diálogo não encontrado no banco de dados: " + id)
	return []
