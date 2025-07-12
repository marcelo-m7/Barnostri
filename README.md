# Barnostri

Este repositório utiliza um **monorepo** contendo o aplicativo Flutter e a
configuração do Supabase. O pacote `packages/shared_models` concentra modelos e
utilidades compartilhadas entre módulos de cliente e administrador.

Consulte `docs/README.md` para uma visão geral da estrutura.

Aplicativo Flutter integrado ao Supabase. Todo o código e scripts do banco ficam neste monorepo.

### Plataformas suportadas

O objetivo é manter o aplicativo executável em **Android**, **iOS** e **Web**. O alvo web é o mais utilizado e testado, mas builds para Android e iOS também estão disponíveis. Utilize os comandos abaixo para iniciar em cada plataforma:

```bash
cd apps/barnostri_app
flutter run -d chrome            # Web
flutter run -d android-emulator  # Android
flutter run -d ios               # iOS (requer macOS)
```


Veja `docs/ARCHITECTURE_PLAN.md` para uma visão geral da organização. Consulte `docs/CODE_REVIEW.md` para um resumo de inconsistências identificadas.

## Environment setup

1. Execute `./setup_environment.sh` para instalar o Flutter e dependências do sistema. O script formata os diretórios `packages/shared_models` e `apps/barnostri_app`, criando `apps/barnostri_app` apenas se ela ainda não existir.
2. Baixe as dependências do projeto:

   ```bash
   (cd apps/barnostri_app && flutter pub get)
   (cd packages/shared_models && dart pub get)
   ```

## Executando o aplicativo Flutter

1. Configure o Supabase preenchendo as variáveis em [`apps/barnostri_app/supabase/supabase-config.json`](apps/barnostri_app/supabase/supabase-config.json).
   Este é o único arquivo de configuração usado pelo app.
2. Inicie o Supabase local (requer o [Supabase CLI](https://supabase.com/docs/guides/cli)):

   ```bash
   supabase start
   ```
3. Execute no navegador ou em dispositivos:

 ```bash
  cd apps/barnostri_app
  flutter run -d web-server        # web
  flutter run -d android-emulator  # Android
  flutter run -d ios               # iOS (requer macOS)
  ```
4. Execute em um dispositivo ou emulador Android:

```bash
cd apps/barnostri_app
flutter run -d <id_android>
```
5. Em sistemas macOS, execute no simulador ou dispositivo iOS:

```bash
cd apps/barnostri_app
flutter run -d <id_ios>
```

Para compilar a aplicação web utilize:

```bash
cd apps/barnostri_app
flutter build web
```

Para gerar um APK Android ou uma build iOS utilize:

```bash
cd apps/barnostri_app
flutter build apk            # Android
flutter build ios            # iOS (requer macOS)
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
```

Os testes de integração podem ser executados em diferentes dispositivos. Para o
navegador Chrome (é necessário ter o Chrome instalado) basta rodar:

```bash
flutter test integration_test -d chrome
```

Caso possua um emulador ou dispositivo Android conectado execute:

```bash
flutter test integration_test -d android-emulator     # ou o ID do dispositivo
```

Em sistemas macOS também é possível rodar no simulador ou em um iPhone real:

```bash
flutter test integration_test -d ios
```

Se nenhum dispositivo móvel estiver disponível, os testes no Chrome podem ser u
m caminho alternativo.

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
Esse método foi atualizado para buscar apenas esse caminho, evitando duplicação de arquivos.

## Executando os testes

Os testes unitários estão em `packages/shared_models/test` e podem ser executados com:

```bash
flutter test packages/shared_models
```

Os testes cobrem também a conversão de valores em inglês e português para os enums
`OrderStatus` e `PaymentMethod`, garantindo compatibilidade com os dados do Supabase.

## Integração contínua

O workflow [`flutter.yml`](.github/workflows/flutter.yml) é acionado a cada *push* ou *pull request*. Ele instala dependências, formata o código, roda `flutter analyze` e executa os testes.
