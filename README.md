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
3. Configure o Supabase preenchendo as variáveis em [`apps/barnostri_app/supabase/supabase-config.json`](apps/barnostri_app/supabase/supabase-config.json).
4. Inicie o Supabase local (requer o [Supabase CLI](https://supabase.com/docs/guides/cli)):

   ```bash
   supabase start
   ```
5. Execute o app:

  ```bash
 cd apps/barnostri_app
 flutter run -d <dispositivo>
 ```

6. Para executar no navegador, utilize:

  ```bash
  cd apps/barnostri_app
  flutter run -d web-server
  ```

Para gerar o APK de distribuição, é necessário possuir o Android SDK
configurado (normalmente via Android Studio) e então executar:

```bash
cd apps/barnostri_app
flutter build apk
```

Já para compilar a aplicação web utilize:

```bash
cd apps/barnostri_app
flutter build web
```

Para testar o build web localmente, sirva o diretório `build/web` em um servidor
HTTP simples:

```bash
cd apps/barnostri_app/build/web
python3 -m http.server 8080
```

Em seguida acesse `http://localhost:8080` no navegador.

Para rodar todos os testes (unitários, widgets e integração) utilize:

```bash
flutter test
flutter test integration_test
```

### Atualizando arquivos de localização

Os textos em diferentes idiomas ficam nos arquivos `.arb` dentro de
`apps/barnostri_app/lib/l10n`. Sempre que modificar esses arquivos, gere os
fontes de localização com:

```bash
cd apps/barnostri_app
flutter gen-l10n
```

Isso atualizará o conteúdo de `lib/l10n/generated`, que deve ser versionado em
seguida.

O arquivo `apps/barnostri_app/supabase/supabase-config.json` é carregado pelo serviço `SupabaseConfig.createClient()` dentro do aplicativo.

## Executando os testes

Os testes unitários estão em `packages/shared_models/test` e podem ser executados com:

```bash
flutter test packages/shared_models
```

Os testes cobrem também a conversão de valores em inglês e português para os enums
`OrderStatus` e `PaymentMethod`, garantindo compatibilidade com os dados do Supabase.

## Integração contínua

O workflow [`flutter.yml`](.github/workflows/flutter.yml) é acionado a cada *push* ou *pull request*. Ele instala dependências, formata o código, roda `flutter analyze` e executa os testes.
