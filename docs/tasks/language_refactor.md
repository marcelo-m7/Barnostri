# Language Refactor Tasks

Conjunto de ações para padronizar o código em inglês. Comentários podem permanecer em português.

- [ ] Renomear todas as classes de modelos para inglês (`Mesa` -> `TableModel`, `Pedido` -> `Order`, etc.).
- [ ] Atualizar serviços e repositórios para refletirem a nova nomenclatura (ex: `addCategoria` -> `addCategory`).
- [ ] Ajustar arquivos de testes e exemplos para os novos nomes.
- [ ] Verificar se migrations e tabelas no Supabase precisam de alteração de nomenclatura.
- [ ] Executar `flutter analyze` e `flutter test` após renomeações para garantir integridade.
