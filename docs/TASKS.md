# Tarefas de Implementação: Cadastro de Clientes e Lojistas

Este documento lista as etapas recomendadas para adicionar o fluxo completo de criação de contas na aplicação Flutter usando Supabase. Siga as tarefas na ordem descrita.

## 1. Migrations e Policies no Supabase

1. Criar uma nova migration em `supabase/migrations/` chamada algo como `20240425000000_create_profiles.sql`.
2. Nesta migration, criar a tabela `profiles` com o esquema abaixo e ativar RLS:

```sql
create table profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  name text,
  phone text,
  user_type text check (user_type in ('cliente', 'lojista')),
  store_name text,
  created_at timestamp default now()
);

alter table profiles enable row level security;

create policy "Users can access their profile" on profiles
  for all
  using (auth.uid() = id)
  with check (auth.uid() = id);
```

3. Executar `supabase db reset` localmente para aplicar a nova migration e garantir que as tabelas existentes continuem funcionando.

## 2. Edge Function opcional

1. Dentro de `supabase/functions/` criar a função `create_user_profile` conforme o exemplo abaixo. Ela recebe e-mail, senha e dados do perfil e cria tudo de forma atômica:

```ts
// functions/create_user_profile/index.ts
import { serve } from 'https://deno.land/std/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js'

serve(async (req) => {
  const { email, password, name, user_type, store_name, phone } = await req.json()

  const supabase = createClient(
    Deno.env.get('SUPABASE_URL')!,
    Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
  )

  const { data: user, error } = await supabase.auth.admin.createUser({
    email,
    password,
    email_confirm: true
  })

  if (error) return new Response(JSON.stringify({ error }), { status: 400 })

  await supabase.from('profiles').insert({
    id: user.user.id,
    name,
    user_type,
    store_name,
    phone
  })

  return new Response(JSON.stringify({ user }), { status: 200 })
})
```

2. Ajustar `supabase/functions/README.md` explicando como implantar e testar essa função.

## 3. Models e Repositórios compartilhados

1. No pacote `packages/shared_models` criar um novo enum `UserType` em `lib/src/models/enums.dart` com valores `cliente` e `lojista`.
2. Atualizar `UserModel` (`lib/src/models/user_model.dart`) para incluir campos opcionais `phone`, `userType` e `storeName`.
3. Acrescentar na interface `AuthRepository` (`lib/src/repositories/auth_repository.dart`) o método:

```dart
Future<AuthResponse> signUp({
  required String email,
  required String password,
  required String name,
  required UserType userType,
  String? phone,
  String? storeName,
});
```

4. Criar um novo caso de uso `register_use_case.dart` em `lib/src/usecases/` que chama `AuthRepository.signUp`.

## 4. Implementação Supabase no aplicativo

1. Em `apps/barnostri_app/lib/src/features/auth/data/repositories/supabase_auth_repository.dart` implementar o novo método `signUp` utilizando `supabase.auth.signUp` e inserindo os dados na tabela `profiles`.
2. Se a aplicação estiver em modo mock (`_client == null`), simular a criação do usuário retornando `AuthResponse` parecido com o já existente em `signIn`.
3. Atualizar `auth_repository_provider` em `lib/src/core/repositories.dart` se necessário.
4. Criar um `RegisterService` ou estender `AuthService` para expor um método `register` que utilize o `RegisterUseCase`.

## 5. Telas e Fluxo de Cadastro

1. Dentro de `apps/barnostri_app/lib/src/features/auth/presentation/pages` criar `register_page.dart` com formulário para e-mail, senha, nome, telefone e tipo de usuário. Se o tipo for `lojista`, exibir campo `store_name`.
2. Adicionar rotas no `GoRouter` do aplicativo para `/register`.
3. Ajustar a `HomePage` para oferecer opção de cadastro e login, direcionando para a nova página.
4. Garantir que ao finalizar o cadastro o usuário seja automaticamente autenticado.

## 6. Bloqueio de finalização de pedido

1. No arquivo `cart_page.dart` é possível localizar o método `_processCheckout` responsável pela criação do pedido【F:apps/barnostri_app/lib/src/features/order/presentation/pages/cart_page.dart†L556-L592】.
2. Antes de chamar `processPayment` verificar `ref.read(authServiceProvider).isAuthenticated`. Caso `false`, redirecionar para a tela de login/cadastro ou mostrar mensagem de que é necessário autenticar.
3. Apenas permitir a criação do pedido se o usuário estiver autenticado.

## 7. Testes

1. Adicionar testes unitários em `packages/shared_models` para o novo enum e modelo.
2. Criar testes de unidade para `RegisterUseCase` utilizando `mockito` para simular o `AuthRepository`.
3. Atualizar ou criar testes de integração em `apps/barnostri_app/integration_test/` cobrindo o fluxo de cadastro de cliente e lojista com dados fictícios.
4. Incluir teste que garante o bloqueio da finalização de pedido quando o usuário não está autenticado.

## 8. Documentação

1. Atualizar `README.md` e `docs/README.md` explicando rapidamente a tabela `profiles` e o fluxo de cadastro.
2. Reforçar que a Service Role Key utilizada pela Edge Function **não** deve ser incluída no aplicativo Flutter.

Siga estas tarefas para implementar o cadastro de usuários e lojistas mantendo a organização atual do projeto. Execute `flutter pub get` e `flutter test` nos diretórios afetados após cada etapa relevante para garantir que tudo continua passando.
