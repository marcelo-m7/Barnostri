# Barnostri

Este repositório utiliza um **monorepo** contendo o aplicativo Flutter e a
configuração do Supabase. O pacote `packages/shared_models` concentra modelos e
utilidades compartilhadas entre módulos de cliente e administrador.

Consulte `docs/README.md` para uma visão geral da estrutura.

Aplicativo Flutter integrado ao Supabase. Todo o código e scripts de banco ficam reunidos neste monorepo.

Veja `docs/ARCHITECTURE_PLAN.md` para a organização completa e acompanhe as tarefas em `docs/tasks/`.
Consulte também `docs/CODE_REVIEW.md` para um resumo de inconsistências identificadas.

## Executando o aplicativo Flutter

1. Instale o Flutter (canal *stable*).
2. Baixe as dependências:

   ```bash
   (cd apps/barnostri_app && flutter pub get)
   (cd packages/shared_models && dart pub get)
   ```
3. Configure o Supabase preenchendo as variáveis em [`supabase/supabase-config.json`](supabase/supabase-config.json).
4. Inicie o Supabase local (requer o [Supabase CLI](https://supabase.com/docs/guides/cli)):

   ```bash
   supabase start
   ```
5. Execute o app:

   ```bash
   cd apps/barnostri_app
   flutter run -d <dispositivo>
   ```

O arquivo `supabase/supabase-config.json` é carregado pelo serviço `SupabaseConfig.createClient()` dentro do aplicativo.

## Executando os testes

Os testes unitários estão em `packages/shared_models/test` e podem ser executados com:

```bash
flutter test packages/shared_models
```

## Integração contínua

O workflow [`flutter.yml`](.github/workflows/flutter.yml) é acionado a cada *push* ou *pull request*. Ele instala dependências, formata o código, roda `flutter analyze` e executa os testes.
