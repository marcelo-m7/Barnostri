# Tarefas para Implementar Cadastro de Clientes e Lojistas

Estas instruções guiam a implementação completa do fluxo de criação de contas utilizando Flutter e Supabase. Siga cada etapa para adicionar suporte aos dois tipos de usuário (`cliente` e `lojista`).

## 1. Banco de Dados - Supabase

1. Crie uma migração em `supabase/migrations/<timestamp>_create_profiles.sql` contendo:
   - Criação da tabela `profiles`:
     ```sql
     create table profiles (
       id uuid primary key references auth.users(id) on delete cascade,
       name text,
       phone text,
       user_type text check (user_type in ('cliente', 'lojista')),
       store_name text,
       created_at timestamp default now()
     );
     ```
   - Ative RLS e defina a policy permitindo que cada usuário acesse apenas seu próprio perfil conforme descrito no prompt.
2. Atualize `supabase/seed/sample_data.sql` inserindo registros de exemplo para a nova tabela.

## 2. Pacote `shared_models`

1. Em `packages/shared_models/lib/src/models` adicione `profile.dart` com os campos correspondentes à tabela `profiles`.
2. Crie um enum `UserType { cliente, lojista }` em `lib/src/models/enums.dart` ou arquivo dedicado.
3. Exporte o novo modelo e enum em `lib/shared_models.dart`.
4. Adicione testes unitários em `packages/shared_models/test` validando `fromJson` e `toJson` do modelo.

## 3. Repositório de Autenticação

1. Estenda `AuthRepository` (`packages/shared_models/lib/src/repositories/auth_repository.dart`) adicionando:
   ```dart
   Future<AuthResponse> signUp({required String email, required String password});
   ```
2. Implemente esse método em `SupabaseAuthRepository` (
   `apps/barnostri_app/lib/src/features/auth/data/repositories/supabase_auth_repository.dart`)
   utilizando `supabase.auth.signUp` e inserindo dados em `profiles`.
3. Inclua comportamento mock quando `_client` for `null` para o modo demo.

## 4. Casos de Uso e Serviço

1. Crie `SignUpUseCase` em `packages/shared_models/lib/src/usecases` chamando o novo método do repositório.
2. Atualize `AuthService` (`apps/barnostri_app/lib/src/features/auth/presentation/controllers/auth_service.dart`)
   adicionando método `signUp` que chama o use case e cria o perfil.

## 5. Telas de Cadastro

1. Em `apps/barnostri_app/lib/src/features/auth/presentation/pages` crie telas para cadastro de `cliente` e `lojista`.
2. Inclua campos de email, senha, nome, telefone e, quando aplicável, `store_name`.
3. Configure rotas em `main.dart` (ou onde o roteamento está definido) para acessar essas telas (`/signup` e `/signup_store`).

## 6. Bloqueio de Checkout sem Login

1. No arquivo `cart_page.dart` verifique `ref.read(authServiceProvider).isAuthenticated` antes de finalizar um pedido.
2. Caso não esteja autenticado, exiba um diálogo solicitando login ou redirecionamento para a tela de login/cadastro.

## 7. Edge Function (opcional)

1. Crie `supabase/functions/create_user_profile/index.ts` conforme o exemplo do prompt para realizar cadastro e criação do perfil de forma atômica.
2. Documente no `README.md` dentro de `supabase/functions` os passos para implantar a função.

## 8. Testes

1. Adicione testes unitários para `SignUpUseCase` e para o novo método do repositório.
2. Crie testes de integração (em `apps/barnostri_app/integration_test`) simulando cadastro de cliente e lojista com dados mockados.
3. Verifique via testes que o checkout é bloqueado quando `authServiceProvider` retorna não autenticado.

## 9. Documentação

1. Atualize `README.md` principal descrevendo o fluxo de cadastro e a tabela `profiles`.
2. Caso necessário, adicione explicações complementares em `docs/`.

Siga as etapas acima para implementar o novo fluxo de criação de contas no aplicativo e no Supabase.
