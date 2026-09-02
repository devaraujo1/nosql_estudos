# Resolução: Atividade Prática MongoDB — Antes e Depois

Anotações da atividade prática da loja online (`store` / `customers`). Rodei tudo no `mongosh` e fui anotando o que cada comando faz e por quê.

---

## Cenário inicial

A atividade pede para criar o banco `store` e a coleção `customers` com 5 clientes. No MongoDB não precisa criar a coleção na mão — ela nasce na primeira inserção.

### Selecionar o banco

```javascript
use store
```

O `use` troca o contexto para o banco `store`. Se ele ainda não existir, o MongoDB só cria de fato quando eu inserir o primeiro documento.

### Inserir os 5 clientes iniciais

```javascript
db.customers.insertMany([
  { "name": "Ana", "age": 25, "city": "Salvador", "active": true, "points": 120 },
  { "name": "Bruno", "age": 32, "city": "Feira de Santana", "active": true, "points": 300 },
  { "name": "Carlos", "age": 28, "city": "Salvador", "active": false, "points": 80 },
  { "name": "Daniela", "age": 40, "city": "São Paulo", "active": true, "points": 500 },
  { "name": "Eduarda", "age": 22, "city": "Rio de Janeiro", "active": false, "points": 50 }
])
```

Usei `insertMany` porque são vários documentos de uma vez. Cada objeto vira um documento na coleção. O MongoDB gera um `_id` automático para cada um (tipo `ObjectId(...)`).

---

## Exercício 1 — Consulta com filtro e projeção

**O que a atividade pede:** mostrar só `name` e `city` dos clientes de Salvador.

```javascript
db.customers.find(
  { city: "Salvador" },
  { name: 1, city: 1, _id: 0 }
)
```

**Como funciona:**

| Parte | O que é | Por quê |
| :--- | :--- | :--- |
| Primeiro `{}` | **Filtro** | `{ city: "Salvador" }` — só documentos cuja cidade é Salvador (Ana e Carlos). |
| Segundo `{}` | **Projeção** | Diz quais campos trazer na resposta. |
| `name: 1, city: 1` | Incluir esses campos | `1` = mostrar o campo. |
| `_id: 0` | Esconder o `_id` | Por padrão o MongoDB sempre mostra `_id`. Com `0` some da saída, igual ao resultado esperado da atividade. |

É o equivalente a um `SELECT name, city FROM customers WHERE city = 'Salvador'` no SQL, só que em documentos.

**Resultado esperado:**

```json
[
  { "name": "Ana", "city": "Salvador" },
  { "name": "Carlos", "city": "Salvador" }
]
```

---

## Exercício 2 — Atualizar um documento (`$set`)

**Antes:** Carlos com `active: false`  
**Depois:** Carlos com `active: true`

```javascript
db.customers.updateOne(
  { name: "Carlos" },
  { $set: { active: true } }
)
```

**Por quê `updateOne`?** Só um cliente se chama Carlos — não preciso mexer em mais de um documento.

**Por quê `$set`?** É o operador de atualização que altera (ou cria) um campo sem apagar o resto do documento. Só muda `active`; `name`, `age`, `city`, `points` continuam iguais.

No terminal: `matchedCount: 1` e `modifiedCount: 1` — achou 1 e alterou 1.

---

## Exercício 3 — Atualizar vários documentos (`updateMany`)

**O que pede:** todos de Salvador ganham `"state": "BA"`.

```javascript
db.customers.updateMany(
  { city: "Salvador" },
  { $set: { state: "BA" } }
)
```

**Diferença do exercício 2:** aqui são **dois** clientes (Ana e Carlos), então `updateMany` em vez de `updateOne`.

De novo `$set` — estou **adicionando** um campo novo (`state`) nos documentos que batem com o filtro. Isso é normal no MongoDB (schemaless): um doc pode ter `state` e outro não, até essa atualização.

No terminal: `matchedCount: 2`, `modifiedCount: 2`.

---

## Exercício 4 — Incremento (`$inc`)

**Antes:** Ana com 120 pontos  
**Depois:** Ana com 170 pontos (+50)

```javascript
db.customers.updateOne(
  { name: "Ana" },
  { $inc: { points: 50 } }
)
```

**Por quê `$inc` e não `$set`?**

- `$set: { points: 170 }` funcionaria, mas eu teria que **saber** o valor atual (120) e calcular 170 na mão.
- `$inc: { points: 50 }` soma 50 **em cima do que já está no banco**. O MongoDB faz a conta lá dentro.

Em produção isso é melhor: se dois pedidos somarem pontos ao mesmo tempo, o `$inc` evita sobrescrever o valor errado.

---

## Exercício 5 — Inserir um documento (`insertOne`)

**O que pede:** adicionar o cliente Fernando (coleção passa de 5 para 6 documentos).

```javascript
db.customers.insertOne({
  "name": "Fernando",
  "age": 29,
  "city": "Recife",
  "active": true,
  "points": 90
})
```

`insertOne` para **um** documento só. Diferente do `insertMany` do início.

O MongoDB devolve `insertedId` com o `_id` novo do Fernando.

---

## Exercício 6 — Remover um documento (`deleteOne`)

**O que pede:** remover Eduarda da coleção.

```javascript
db.customers.deleteOne({ name: "Eduarda" })
```

`deleteOne` apaga **o primeiro** documento que bater no filtro. Como só existe uma Eduarda, é o comando certo.

`deletedCount: 1` confirma que sumiu. Não é soft delete — o documento some de verdade.

---

## Exercício 7 — Criar um campo novo (`$set`)

**O que pede:** Daniela passa a ter `vip: true`.

```javascript
db.customers.updateOne(
  { name: "Daniela" },
  { $set: { vip: true } }
)
```

Mesma ideia do `state` no exercício 3: `$set` cria o campo `vip` só no documento da Daniela. Os outros clientes não ganham `vip` — e tudo bem, é schemaless.

---

## Exercício 8 — Remover um campo (`$unset`)

**O que pede:** o Bruno deixa de ter o campo `points` (não é zerar — é **sumir** o campo).

```javascript
db.customers.updateOne(
  { name: "Bruno" },
  { $unset: { points: "" } }
)
```

**`$unset` vs `$set` com `null`:**

| Abordagem | O que acontece |
| :--- | :--- |
| `$set: { points: null }` | O campo `points` **continua existindo**, só que com valor `null`. |
| `$unset: { points: "" }` | O campo **some** do documento. O valor depois de `:` no `$unset` não importa (uso `""` por convenção). |

Depois disso, se eu listar o Bruno, não aparece mais `points` no JSON.

---

## Exercício 9 — Ordenação (`sort`)

**O que pede:** todos os clientes, do mais velho para o mais novo (idade decrescente).

```javascript
db.customers.find().sort({ age: -1 })
```

- `find()` sem filtro = traz **todos** os documentos.
- `.sort({ age: -1 })` ordena pelo campo `age`.
  - `-1` = decrescente (maior idade primeiro).
  - `1` seria crescente (menor idade primeiro).

**Ordem depois de todos os exercícios anteriores:**

1. Daniela (40)
2. Bruno (32)
3. Fernando (29)
4. Carlos (28)
5. Ana (25)

(Eduarda já foi removida no exercício 6.)

---

## Exercício 10 — Filtro com múltiplas condições

**O que pede:** só nomes de clientes **ativos** com **mais de 30 anos**.

```javascript
db.customers.find(
  { active: true, age: { $gt: 30 } },
  { name: 1, _id: 0 }
)
```

**O filtro:**

| Condição | Significado |
| :--- | :--- |
| `active: true` | Cliente ativo. |
| `age: { $gt: 30 }` | Idade **maior que** 30 (`$gt` = greater than). |
| Vírgula entre as duas | **E** lógico — as duas têm que ser verdadeiras ao mesmo tempo. |

**A projeção:** `{ name: 1, _id: 0 }` — só o nome, sem `_id`.

**Quem entra:** Bruno (32, ativo) e Daniela (40, ativa).  
**Quem fica de fora:** Ana (25), Carlos (28), Fernando (29) — todos com 30 ou menos.

```json
[
  { "name": "Bruno" },
  { "name": "Daniela" }
]
```

---

## Estado da coleção antes do Desafio

Depois dos exercícios 1 a 10, a coleção `customers` fica assim (resumo):

| Nome | Idade | Cidade | Ativo | Pontos | Outros |
| :--- | :---: | :--- | :---: | :--- | :--- |
| Ana | 25 | Salvador | sim | 170 | `state: "BA"` |
| Bruno | 32 | Feira de Santana | sim | — | `points` removido |
| Carlos | 28 | Salvador | sim | 80 | `state: "BA"` |
| Daniela | 40 | São Paulo | sim | 500 | `vip: true` |
| Fernando | 29 | Recife | sim | 90 | — |

**Total:** 5 clientes. **Todos ativos** (Carlos foi reativado no ex. 2; Eduarda foi apagada no ex. 6).

O Desafio pede comandos que **só leem** — não alteram nada.

---

## Desafio — 10 consultas extras

### 1. Mostrar apenas os nomes dos clientes

```javascript
db.customers.find({}, { name: 1, _id: 0 })
```

- Primeiro `{}` vazio = sem filtro, pega todos.
- Projeção: só `name`, esconde `_id`.

Lista: Ana, Bruno, Carlos, Daniela, Fernando.

---

### 2. Contar quantos clientes existem

```javascript
db.customers.countDocuments()
```

`countDocuments()` devolve um **número** — quantos documentos tem na coleção. Sem argumento = conta tudo.

**Resultado:** `5`

(Antigamente usava-se `count()`, mas `countDocuments()` é o recomendado hoje.)

---

### 3. Contar apenas os clientes ativos

```javascript
db.customers.countDocuments({ active: true })
```

Mesma função, mas com **filtro**: só conta quem tem `active: true`.

**Resultado:** `5` — depois dos exercícios, todo mundo está ativo.

---

### 4. Cliente com maior pontuação

```javascript
db.customers.find().sort({ points: -1 }).limit(1)
```

| Etapa | O que faz |
| :--- | :--- |
| `sort({ points: -1 })` | Ordena por `points` do maior para o menor. |
| `limit(1)` | Pega só o **primeiro** da lista = o de maior pontuação. |

**Resultado:** Daniela, com 500 pontos.

**Obs.:** Bruno não tem campo `points` (foi removido no ex. 8). Documentos sem o campo costumam ser tratados como se não tivessem valor para ordenação — não atrapalha aqui porque queremos o maior.

---

### 5. Cliente com menor idade

```javascript
db.customers.find().sort({ age: 1 }).limit(1)
```

Igual ao anterior, mas:
- `age: 1` = ordem **crescente** (menor idade primeiro).
- `limit(1)` = o mais novo.

**Resultado:** Ana, 25 anos.

---

### 6. Pontuação entre 100 e 400

```javascript
db.customers.find({ points: { $gte: 100, $lte: 400 } })
```

| Operador | Significado |
| :--- | :--- |
| `$gte` | Greater than or **equal** — maior ou igual |
| `$lte` | Less than or **equal** — menor ou igual |

Quero pontos **de 100 até 400**, inclusive.

**Quem entra:** Ana (170).  
**Quem fica de fora:** Carlos (80), Fernando (90), Daniela (500), Bruno (sem `points`).

---

### 7. Cidades Salvador ou São Paulo

```javascript
db.customers.find({ city: { $in: ["Salvador", "São Paulo"] } })
```

`$in` = o valor do campo tem que estar **dentro da lista**.

Equivalente a: `city = 'Salvador' OR city = 'São Paulo'`.

**Resultado:** Ana, Carlos (Salvador) e Daniela (São Paulo).

---

### 8. Todos ordenados por nome

```javascript
db.customers.find().sort({ name: 1 })
```

`sort({ name: 1 })` = ordem alfabética A→Z.

**Ordem:** Ana → Bruno → Carlos → Daniela → Fernando.

---

### 9. Só os três primeiros clientes

```javascript
db.customers.find().limit(3)
```

`limit(3)` corta a lista em 3 documentos. Sem `sort`, a ordem é a **ordem natural** da coleção (geralmente próxima da ordem de inserção, mas não é garantido em todos os cenários).

Na prática, depois das alterações, costuma vir algo como Ana, Bruno, Carlos — mas o importante é serem **3** registros.

Se a atividade quisesse “os 3 mais novos”, precisaria de `.sort({ age: 1 }).limit(3)`. Como só pediu “três primeiros”, `limit(3)` puro está certo.

---

### 10. Apenas clientes inativos

```javascript
db.customers.find({ active: false })
```

Filtro direto: `active` igual a `false`.

**Resultado depois dos exercícios 1–10:** lista **vazia** `[]`.

Por quê? Carlos foi ativado no exercício 2 e Eduarda (que era inativa) foi apagada no exercício 6. Não sobrou ninguém inativo.

Se rodar o Desafio **antes** dos exercícios 2 e 6, apareceriam Carlos e Eduarda. Por isso a ordem importa: o Desafio assume o estado **final** da coleção.

---

## Operadores que usei — cola rápida

| Operador | Onde | Função |
| :--- | :--- | :--- |
| `$set` | Update | Altera ou cria campo |
| `$inc` | Update | Soma/subtrai número no campo |
| `$unset` | Update | Remove o campo do documento |
| `$gt` | Filtro | Maior que |
| `$gte` | Filtro | Maior ou igual |
| `$lte` | Filtro | Menor ou igual |
| `$in` | Filtro | Valor está na lista |

---

## Ordem para rodar no mongosh

1. `use store`
2. `insertMany` com os 5 clientes iniciais
3. Exercícios 1 a 10 **na ordem** (cada um muda o estado para o próximo)
4. Desafio (só leitura, no estado final)

Se quiser recomeçar do zero:

```javascript
use store
db.customers.drop()
```

Apaga a coleção inteira. Aí rodo o `insertMany` de novo.

---

## O que aprendi com essa atividade

- **Filtro + projeção** no `find`: primeiro escolho *quem*, depois *o que mostrar*.
- **`updateOne` vs `updateMany`**: um doc vs vários.
- **`$set` / `$inc` / `$unset`**: cada um com papel diferente — não dá para trocar um pelo outro à toa.
- **`sort` + `limit`**: juntos servem para “o maior”, “o menor”, “top N”.
- **`countDocuments`**: contar sem trazer os documentos inteiros (mais leve).
- O MongoDB **não exige** que todos os documentos tenham os mesmos campos — Bruno sem `points` e Daniela com `vip` na mesma coleção é normal.

