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


Veja `docs/ARCHITECTURE_PLAN.md` para uma visão geral da organização. O resumo abaixo destaca pontos observados durante o code review.

### Resumo do code review

- Vários arquivos e tabelas utilizam nomes em português. Padronizar os identificadores em inglês é recomendado.
- Os testes e a análise estática dependem do Flutter instalado no ambiente.
- As migrações do Supabase também seguem nomenclatura em português e podem ser atualizadas.
- Enums como `OrderStatus` e `PaymentMethod` aceitam valores em português para compatibilidade com dados existentes.

## Environment setup

1. Execute `./setup_environment.sh` para instalar o Flutter e dependências do sistema. O script formata os diretórios `packages/shared_models` e `apps/barnostri_app`, criando `apps/barnostri_app` apenas se ela ainda não existir.
2. Baixe as dependências do projeto:

   ```bash
   (cd apps/barnostri_app && flutter pub get)
   (cd packages/shared_models && dart pub get)
   ```

## Rodando `setup_environment.sh` e os testes

O script `setup_environment.sh` automatiza a instalação do Flutter SDK, do Google Chrome e de dependências do sistema. Ele deve ser executado no diretório raiz do repositório e requer permissões para instalar pacotes via `apt`.

```bash
chmod +x setup_environment.sh
./setup_environment.sh
```

Ao final da execução o Flutter estará disponível no `PATH`, o código será formatado e todos os testes unitários e de integração serão executados, por padrão usando o navegador Chrome.

## Executando o aplicativo Flutter

1. Copie o arquivo de exemplo [`apps/barnostri_app/supabase/supabase-config.example.json`](apps/barnostri_app/supabase/supabase-config.example.json)
   para `apps/barnostri_app/supabase/supabase-config.json`. O arquivo já contém
   a URL e a anon key do projeto Supabase de demonstração.
   Mantenha-o fora do versionamento para evitar expor outras chaves.
2. Execute no navegador ou em dispositivos:

 ```bash
  cd apps/barnostri_app
  flutter run -d web-server        # web
  flutter run -d android-emulator  # Android
  flutter run -d ios               # iOS (requer macOS)
  ```
3. Execute em um dispositivo ou emulador Android:

```bash
cd apps/barnostri_app
flutter run -d <id_android>
```
4. Em sistemas macOS, execute no simulador ou dispositivo iOS:

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

Caso possua um emulador ou dispositivo Android conectado, execute para validar 
os fluxos de navegação e os layouts responsivos no Android:

```bash
flutter test integration_test -d android-emulator     # ou o ID do dispositivo
```

Em sistemas macOS também é possível rodar no simulador ou em um iPhone real 
para verificar a mesma experiência no iOS:

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

O arquivo `apps/barnostri_app/supabase/supabase-config.json` (gerado a partir do exemplo) é carregado pelo serviço `SupabaseConfig.createClient()` dentro do aplicativo.
Mantenha este arquivo fora do versionamento para evitar vazamento de chaves.

## Executando os testes

Para rodar todos os testes de uma vez certifique-se de que o Flutter SDK esteja configurado:

```bash
flutter test
```

Para executar apenas os testes unitários do pacote compartilhado use:

```bash
flutter test packages/shared_models
```

### Testes de integração

Os testes de integração podem ser validados em diferentes plataformas. É necessário ter o Chrome instalado para testes web e um emulador ou dispositivo para Android/iOS.

```bash
flutter test integration_test -d chrome            # Web
flutter test integration_test -d android-emulator  # Android
flutter test integration_test -d ios               # iOS (requer macOS)
```

Esses testes cobrem, entre outros pontos, a conversão de valores em inglês e português para os enums `OrderStatus` e `PaymentMethod`, garantindo compatibilidade com os dados do Supabase.

## Integração contínua

O workflow [`flutter.yml`](.github/workflows/flutter.yml) é acionado a cada *push* ou *pull request*. Ele instala dependências, formata o código, roda `flutter analyze` e executa os testes.

## Tabela `profiles` e fluxo de cadastro

A migração [`supabase/migrations/20240102000000_create_profiles.sql`](supabase/migrations/20240102000000_create_profiles.sql)
cria a tabela `profiles` com os campos `id`, `name`, `phone`, `user_type`,
`store_name` e `created_at`. O campo `user_type` aceita apenas os valores
`'cliente'` ou `'lojista'`. As Row Level Policies garantem que cada usuário só
consiga ler e atualizar o seu próprio perfil.

Para testar o cadastro localmente:

1. Copie `apps/barnostri_app/supabase/supabase-config.example.json` para
   `apps/barnostri_app/supabase/supabase-config.json` e preencha com a URL e a
   anon key do seu projeto.
2. Execute `flutter run` dentro de `apps/barnostri_app`.
3. Na tela de login, escolha **Sign Up** e informe nome, telefone, e-mail e
   senha. Usuários do tipo **lojista** devem selecionar o tipo "Lojista" e
   preencher `store_name`.
4. O app chama `supabase.auth.signUp` e insere o registro correspondente na
   tabela `profiles`.

Mantenha a chave **service role** fora do aplicativo Flutter. Utilize variáveis
de ambiente ou uma [Edge Function](supabase/functions/create_user_profile) para
executar tarefas que exijam essa chave de forma segura.
