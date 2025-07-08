# Code Review

Este documento resume inconsistências encontradas no código e recomendações de melhorias.

## Linguagem misturada
A maior parte das classes e funções está definida em português, por exemplo:
- `Mesa`, `Categoria`, `Pedido`, `ItemPedido` em `packages/shared_models/lib/src/models`.
- Métodos como `addCategoria`, `loadItensCardapio` e `criarPedido` em serviços e repositórios.

É recomendado padronizar o código em inglês para facilitar manutenção.

## Testes e dependências
Os testes utilizam `flutter_test`. Sem o Flutter SDK instalado, os testes não são executados corretamente.

## Análise estática
O comando `dart analyze` gera milhares de erros porque depende do SDK do Flutter. É necessário configurar o ambiente com o Flutter para realizar a análise corretamente.

## Tabelas do Supabase
Os arquivos de migração utilizam nomes de tabelas em português (`mesas`, `pedidos`, etc.). Avaliar a migração dos nomes para inglês para manter consistência com o código.

## Próximos passos
Renomear classes, arquivos e métodos para inglês e atualizar toda a base (tests, serviços e repositórios). Comentários podem continuar em português.
