Atividade Prática – MongoDB: Antes e Depois
Objetivo
Praticar os principais comandos do MongoDB analisando o estado da coleção antes e produzindo o estado depois por meio de operações no banco de dados.



Cenário
Você foi contratado para administrar o banco de dados de uma loja online.



Crie um banco chamado store e uma coleção chamada customers.



Insira os seguintes documentos:

[
  {
    "name": "Ana",
    "age": 25,
    "city": "Salvador",
    "active": true,
    "points": 120
  },
  {
    "name": "Bruno",
    "age": 32,
    "city": "Feira de Santana",
    "active": true,
    "points": 300
  },
  {
    "name": "Carlos",
    "age": 28,
    "city": "Salvador",
    "active": false,
    "points": 80
  },
  {
    "name": "Daniela",
    "age": 40,
    "city": "São Paulo",
    "active": true,
    "points": 500
  },
  {
    "name": "Eduarda",
    "age": 22,
    "city": "Rio de Janeiro",
    "active": false,
    "points": 50
  }
]
 
Exercício 1 – Consulta
Antes
Todos os documentos acima.

Depois
Resultado esperado:

[
  {
    "name": "Ana",
    "city": "Salvador"
  },
  {
    "name": "Carlos",
    "city": "Salvador"
  }
]
Sua tarefa

Escreva o comando MongoDB que produz esse resultado.



Exercício 2 – Atualização
Antes
{
  "name": "Carlos",
  "active": false
}
Depois
{
  "name": "Carlos",
  "active": true
}
Sua tarefa

Escreva o comando necessário.



Exercício 3 – Atualizar vários documentos
Antes
{
  "city": "Salvador"
}
Depois
Todos os clientes de Salvador passam a possuir:

"state": "BA"
Sua tarefa

Escreva o comando.



Exercício 4 – Incremento
Antes
{
  "name": "Ana",
  "points": 120
}
Depois
{
  "name": "Ana",
  "points": 170
}
Sua tarefa

Escreva o comando utilizando o operador mais adequado.



Exercício 5 – Inserção
Antes
A coleção possui cinco documentos.

Depois
A coleção passa a possuir mais um documento:

{
  "name": "Fernando",
  "age": 29,
  "city": "Recife",
  "active": true,
  "points": 90
}
Sua tarefa

Escreva o comando.



Exercício 6 – Remoção
Antes
Existe o cliente:

{
  "name": "Eduarda"
}
Depois
O documento não existe mais.

Sua tarefa

Escreva o comando.



Exercício 7 – Criar um novo campo
Antes
{
  "name": "Daniela"
}
Depois
{
  "name": "Daniela",
  "vip": true
}
Sua tarefa

Escreva o comando.



Exercício 8 – Remover um campo
Antes
{
  "name": "Bruno",
  "points": 300
}
Depois
{
  "name": "Bruno"
}
O campo points não deve mais existir.

Sua tarefa

Escreva o comando.



Exercício 9 – Ordenação
Antes
Todos os documentos.

Depois
Os clientes aparecem ordenados por idade em ordem decrescente.

Sua tarefa

Escreva o comando.



Exercício 10 – Filtro com múltiplas condições
Antes
Todos os documentos.

Depois
Resultado esperado:

[
  {
    "name": "Bruno"
  },
  {
    "name": "Daniela"
  }
]
Somente clientes ativos com mais de 30 anos.

Sua tarefa

Escreva o comando.



Desafio
Sem alterar os documentos existentes, escreva comandos para obter os seguintes resultados:

Mostrar apenas os nomes dos clientes.
Contar quantos clientes existem.
Contar apenas os clientes ativos.
Mostrar o cliente com maior pontuação.
Mostrar o cliente com menor idade.
Mostrar apenas clientes com pontuação entre 100 e 400.
Mostrar apenas clientes das cidades de Salvador ou São Paulo.
Mostrar todos os clientes ordenados por nome.
Mostrar apenas os três primeiros clientes.
Mostrar apenas os clientes inativos.


# RESOLUCAO DOS EXERCICIOS
// Seleciona ou cria o banco de dados 'store'
use store

// Insere os 5 documentos iniciais na coleção 'customers'
db.customers.insertMany([
  { "name": "Ana", "age": 25, "city": "Salvador", "active": true, "points": 120 },
  { "name": "Bruno", "age": 32, "city": "Feira de Santana", "active": true, "points": 300 },
  { "name": "Carlos", "age": 28, "city": "Salvador", "active": false, "points": 80 },
  { "name": "Daniela", "age": 40, "city": "São Paulo", "active": true, "points": 500 },
  { "name": "Eduarda", "age": 22, "city": "Rio de Janeiro", "active": false, "points": 50 }
])
📝 Resolução dos Exercícios (1 a 10)
Exercício 1 – Consulta
Objetivo: Buscar clientes de "Salvador" e exibir apenas os campos name e city
.
Comando:
db.customers.find(
  { city: "Salvador" },
  { name: 1, city: 1, _id: 0 }
)
Exercício 2 – Atualização
Objetivo: Alterar o status do cliente "Carlos" de inativo para ativo (active: true)

Comando:
db.customers.updateOne(
  { name: "Carlos" },
  { $set: { active: true } }
)
Exercício 3 – Atualizar vários documentos
Objetivo: Adicionar o campo state: "BA" para todos os clientes que moram em "Salvador"
.
Comando:
db.customers.updateMany(
  { city: "Salvador" },
  { $set: { state: "BA" } }
)
Exercício 4 – Incremento
Objetivo: Adicionar 50 pontos à conta da "Ana", fazendo com que sua pontuação mude de 120 para 170
.
Comando:
db.customers.updateOne(
  { name: "Ana" },
  { $inc: { points: 50 } }
)
(Nota: O operador $inc é o mais adequado por realizar o incremento matemático diretamente no banco, sem a necessidade de ler o valor atual no backend e calcular o resultado final manualmente
.)
Exercício 5 – Inserção
Objetivo: Adicionar o novo cliente "Fernando" à coleção
.
Comando:
db.customers.insertOne({
  "name": "Fernando",
  "age": 29,
  "city": "Recife",
  "active": true,
  "points": 90
})
Exercício 6 – Remoção
Objetivo: Remover permanentemente o documento da cliente "Eduarda"
.
Comando:
db.customers.deleteOne({ name: "Eduarda" })
Exercício 7 – Criar um novo campo
Objetivo: Inserir a propriedade vip: true apenas para o documento da "Daniela"
.
Comando:
db.customers.updateOne(
  { name: "Daniela" },
  { $set: { vip: true } }
)
Exercício 8 – Remover um campo
Objetivo: Remover inteiramente o campo points do documento do "Bruno"
.
Comando:
db.customers.updateOne(
  { name: "Bruno" },
  { $unset: { points: "" } }
)
(Nota: Diferente de definir o campo como null ou "", o operador $unset elimina fisicamente a propriedade da estrutura do documento JSON
.)
Exercício 9 – Ordenação
Objetivo: Listar todos os documentos ordenando os clientes pela idade de forma decrescente
.
Comando:
db.customers.find().sort({ age: -1 })
Exercício 10 – Filtro com múltiplas condições
Objetivo: Retornar os nomes dos clientes ativos que possuem idade superior a 30 anos
.
Comando:
db.customers.find(
  { active: true, age: { $gt: 30 } },
  { name: 1, _id: 0 }
)