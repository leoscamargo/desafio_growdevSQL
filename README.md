Insights do Desafio — Análise de Dados Olist com SQL

Esse desafio começou com a exploração do modelo de dados da Olist, 
entendendo como as tabelas se conectam: pedidos, clientes, itens, produtos, 
vendedores, pagamentos e avaliações. A partir daí, fui evoluindo as consultas em complexidade, 
passando por joins, agregações, subqueries, CTEs, views, funções e window functions.

Sobre a lógica das consultas, o principal aprendizado foi perceber que uma mesma pergunta de negócio pode ser resolvida 
de formas bem diferentes, e nem sempre a primeira forma que parece "correta" é a mais eficiente. 
Em alguns momentos escrevi subqueries correlacionadas que, na teoria, entregavam o resultado certo, mas na prática travavam a execução porque recalculavam a mesma coisa para cada linha da tabela, milhares de vezes. 
Reescrever essas consultas como uma agregação única, feita antes e depois comparada ou juntada ao restante, resolveu tanto a lentidão quanto deixou a lógica mais clara. 
Isso me mostrou que pensar em performance faz parte de pensar na lógica, não é uma etapa separada.

Sobre as relações do banco, o principal insight foi entender que quase tudo gira em torno da tabela de pedidos, 
e que a forma como as tabelas se relacionam interfere diretamente no resultado das contas. 
Um pedido pode ter vários itens, então juntar avaliações direto com os itens distorce a média, porque a mesma nota acaba sendo contada mais de uma vez. 
Precisei isolar esse cálculo à parte para ele ficar correto. Também aprendi que relação não é só sobre chave estrangeira e join,
é sobre entender o que cada linha representa de verdade antes de somar ou tirar média dela.

Já com o CASE WHEN, o aprendizado foi sobre transformar número em categoria de negócio sem precisar criar tabela auxiliar nem processo externo. 
Dá pra classificar entrega, cliente, produto e forma de pagamento direto na consulta. A parte que mais me chamou atenção foi entender que a ordem das condições importa, 
porque o CASE só olha para a próxima condição se a anterior for falsa, então a lógica de faixas (leve, médio, pesado, ou bronze, prata, ouro) precisa ser pensada do mais restritivo para o mais aberto, senão o resultado sai errado silenciosamente, sem dar erro nenhum.

Por fim, teve bastante aprendizado só de debugar os erros que o banco devolvia. 
Vi na prática que datas guardadas como texto não se comportam como datas de verdade, então funções como date_trunc ou comparação com BETWEEN só funcionam depois de converter o tipo. 
Também aprendi que criar uma view não retorna linha nenhuma porque ela não é uma consulta, é a criação de um objeto, e a forma certa de confirmar que deu certo é consultando a view depois. 
No fim, o desafio deixou claro que escrever SQL não é só saber a sintaxe, é entender o dado por trás de cada tabela e testar bastante até a lógica realmente bater com a realidade.
