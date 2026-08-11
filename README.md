# 📒 Guia de Estudos e Resumo Prático: NoSQL & MongoDB

Este guia foi elaborado para consolidar os conceitos aprendidos nas aulas de NoSQL e MongoDB, servindo como material de revisão organizado, didático e prático.

---

## 🚀 1. O que é NoSQL?

O **NoSQL** (Not Only SQL) é um paradigma de banco de dados que engloba diversos tipos de bancos de dados não relacionais [1]. Ele foi projetado para responder a desafios modernos de desenvolvimento, oferecendo três pilares principais [1]:
*   **Flexibilidade:** Modelos de dados flexíveis e sem esquemas rígidos (schemaless).
*   **Escalabilidade:** Facilidade para crescer horizontalmente (distribuindo dados em múltiplos servidores).
*   **Alto Desempenho:** Respostas rápidas e eficientes para grandes volumes de dados.

### 🧩 Os Quatro Principais Paradigmas NoSQL

Dependendo de como os dados são organizados e acessados, as soluções NoSQL dividem-se em quatro categorias principais [3]:

| Paradigma | Como Funciona | Principais Exemplos |
| :--- | :--- | :--- |
| **Documentos** | Armazena dados como documentos (semelhantes a JSON/BSON) [3]. | **MongoDB**, CouchDB [3] |
| **Chave-Valor** | Associa uma chave única a um valor específico (muito rápido) [3]. | **Redis**, DynamoDB [3] |
| **Família de Colunas** | Organiza dados em colunas flexíveis em vez de linhas rígidas [3]. | **Cassandra**, HBase [3] |
| **Grafos** | Focado em relacionamentos (nós e arestas) [3]. | **Neo4j**, Amazon Neptune [3] |

---

## 🍃 2. O que é o MongoDB e Como Ele Funciona?

O nome **"Mongo"** vem da palavra em inglês **Humongous** (que significa "Gigante") [3]. Isso reflete seu propósito principal: armazenar e gerenciar gigantescos volumes de dados de maneira altamente eficiente [3].

O **MongoDB** é um banco de dados NoSQL de código aberto e orientado a documentos [3].

### ⚖️ Relacional (SQL) vs. Não Relacional (MongoDB)

Ao contrário dos bancos relacionais (como MySQL ou PostgreSQL), que usam tabelas rígidas estruturadas em colunas e linhas, o MongoDB adota uma abordagem muito mais livre [4]:

```
┌───────────────────────────────────────────────────────────────┐
│                    TABELA RELACIONAL (SQL)                    │
│  ID   │      Nome      │    Idade    │        Cidade          │
├───────┼────────────────┼─────────────┼────────────────────────┤
│   1   │     Jefté      │     33      │       Salvador         │
└───────┴────────────────┴─────────────┴────────────────────────┘

                               VS

┌───────────────────────────────────────────────────────────────┐
│                     DOCUMENTO MONGODB (NoSQL)                 │
│  {                                                            │
│    "_id": ObjectId("60c72b2f9b1d8b2bad789102"),               │
│    "nome": "Jefté",                                           │
│    "idade": 33,                                               │
│    "cidade": "Salvador"                                       │
│  }                                                            │
└───────────────────────────────────────────────────────────────┘
```

### 🏢 A Hierarquia de Dados no MongoDB

A estrutura organizacional do MongoDB é simples e intuitiva [4, 12]:
1.  **Servidor:** Pode hospedar múltiplos bancos de dados (Databases) [4].
2.  **Banco de Dados (Database):** Agrupa coleções de dados [4].
3.  **Coleção (Collection):** Equivalente às tabelas do SQL, mas sem esquema fixo (schemaless) [4]. Contém os documentos [4].
4.  **Documento (Document):** Equivalente às linhas ou registros do SQL [4, 6]. É onde as informações reais ficam salvas no formato BSON [4, 6].

> 💡 **Nota Importante:** Bancos de dados e coleções são **criados implicitamente** no MongoDB assim que você insere o primeiro documento. Não há necessidade de criá-los manualmente antes do uso!

---

## 📄 3. A Estrutura dos Dados: JSON e BSON

### 📝 O Formato JSON

No MongoDB, as informações são manipuladas e visualizadas em formato **JSON** (JavaScript Object Notation) [6]. Um documento JSON é delimitado por chaves `{}` e composto por **campos** (fields) ou propriedades [16].

#### Anatomia de um Documento JSON [16]:
*   Cada campo é um par de **Chave (Key)** e **Valor (Value)** separado por dois-pontos `:` [16].
*   Múltiplos campos são separados por vírgulas `,` [16].
*   As chaves são sempre strings (entre aspas), enquanto os valores podem aceitar diversos tipos de dados [16]:

```json
{
  "nome": "Jefté",                // String (Texto)
  "idade": 35,                     // Número (Inteiro/Decimal)
  "ehProfessor": true,             // Booleano (true ou false)
  "hobbies": ["Lego", "Games"],    // Array (Lista de elementos)
  "endereco": {                    // Documento Incorporado (Objeto Aninhado)
    "rua": "San Martim",
    "cidade": "Salvador"
  }
}
```

### ⚙️ O Formato BSON (Binary JSON)

Embora escrevamos e visualizemos os dados em JSON, o MongoDB armazena esses registros internamente como **BSON** (Binary JSON) [6]. 
*   O BSON é uma representação binária do JSON [6].
*   Ele é extremamente rápido para busca, leitura e escrita, além de suportar mais tipos de dados nativos (como datas e identificadores exclusivos de ID do MongoDB).

### 🔗 Minimizando Relacionamentos (Documentos Incorporados)

Diferente do SQL convencional, onde dividimos informações em várias tabelas diferentes e as unimos usando `JOIN`, o MongoDB prefere manter os dados que pertencem juntos **no mesmo documento** [9].
*   Isso é feito usando **documentos incorporados** (embedded documents), como o campo `endereco` demonstrado no exemplo acima [9].
*   Isso elimina a lentidão e a complexidade de fazer junções de tabelas frequentes [9].

---

## 💻 4. Comandos Principais no Console (mongosh)

Para interagir com o MongoDB via prompt/terminal, utilizamos o shell do MongoDB (`mongosh`) [11]. Abaixo estão os comandos mais comuns do dia a dia [11]:

| Comando | Descrição |
| :--- | :--- |
| `mongosh` | Inicia o terminal interativo do MongoDB [11]. |
| `show databases` ou `show dbs` | Lista todos os bancos de dados ativos no servidor [11]. |
| `use <nome_do_banco>` | Cria ou alterna para o banco de dados especificado (ex: `use shop`) [11]. |
| `show collections` | Exibe as coleções existentes dentro do banco atual [11]. |
| `db.createCollection("<nome>")` | Cria explicitamente uma nova coleção (opcional) [11]. |
| `db.<coleção>.insertOne({ ... })` | Insere um único documento em uma coleção [11]. |
| `db.<coleção>.find()` | Lista todos os documentos de uma coleção [11]. |

---

## 🛠️ 5. Operações de CRUD no MongoDB

O termo **CRUD** representa as quatro operações essenciais de persistência de dados em qualquer sistema [12]:

### ➕ 1. Create (Inserção)
Insere novos registros (documentos) nas suas coleções [11, 12]:
*   **`insertOne(data, options)`**: Insere **um único** documento [11].
    ```javascript
    db.users.insertOne({ name: "Jefté", age: 35 })
    ```
*   **`insertMany(data, options)`**: Insere **múltiplos** documentos simultaneamente de forma rápida utilizando uma lista (array) de objetos.
    ```javascript
    db.users.insertMany([
      { name: "Brenno", age: 10 },
      { name: "Maria", age: 28 }
    ])
    ```

### 🔍 2. Read (Leitura / Consulta)
Encontra documentos salvos no seu banco de dados:
*   **`find(filter, options)`**: Busca **todos** os documentos que correspondem aos critérios de filtro. Se deixado vazio `find()`, retorna tudo [11].
    ```javascript
    db.users.find({ age: 35 })
    ```
*   **`findOne(filter, options)`**: Retorna apenas **o primeiro** documento que corresponde ao filtro.
    ```javascript
    db.users.findOne({ name: "Jefté" })
    ```

### 🔄 3. Update (Atualização)
Modifica documentos existentes:
*   **`updateOne(filter, data, options)`**: Atualiza apenas **um único** documento correspondente ao filtro.
    ```javascript
    db.users.updateOne({ name: "Jefté" }, { $set: { age: 36 } })
    ```
*   **`updateMany(filter, data, options)`**: Modifica **todos** os documentos que baterem com as condições do filtro.
    ```javascript
    db.users.updateMany({ age: { $lt: 18 } }, { $set: { menorDeIdade: true } })
    ```
*   **`replaceOne(filter, data, options)`**: Substitui **todo o documento** correspondente por um novo objeto (com exceção do campo imutável `_id`).
    ```javascript
    db.users.replaceOne({ name: "Brenno" }, { name: "Brenno", age: 11, status: "ativo" })
    ```

### ❌ 4. Delete (Remoção)
Exclui registros da coleção:
*   **`deleteOne(filter, options)`**: Deleta **apenas o primeiro** documento que corresponder aos filtros especificados.
    ```javascript
    db.users.deleteOne({ name: "Maria" })
    ```
*   **`deleteMany(filter, options)`**: Exclui **todos** os documentos que atendem às condições do filtro.
    ```javascript
    db.users.deleteMany({ status: "inativo" })
    ```

---
💡 *Dica de Ouro para a prova:* Lembre-se de que o MongoDB é **schemaless** (sem esquema estrito), o que significa que documentos dentro da mesma coleção podem possuir campos totalmente diferentes sem quebrar a estrutura do banco de dados!
