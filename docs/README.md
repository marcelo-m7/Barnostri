# Barnostri Monorepo

Este repositório reúne o aplicativo Flutter e os recursos do Supabase em um único monorepo.

```
apps/
  barnostri_app/
    lib/
      src/
        core/
        features/
          <feature>/
            presentation/
            domain/
            data/
    pubspec.yaml
packages/
  shared_models/
    lib/src/models/
    lib/src/repositories/
    lib/src/utils/
supabase/
  migrations/
  seed/
  functions/
apps/barnostri_app/supabase/
  supabase-config.example.json
  supabase-config.json (ignored)
```

### Diretórios

- **apps/barnostri_app**: código Flutter organizado por features com camadas `presentation`, `domain` e `data`.
- **packages/shared_models**: modelos e repositórios compartilhados.
- **supabase/**: scripts SQL e configurações do banco.

Consulte `docs/ARCHITECTURE_PLAN.md` para detalhes da arquitetura.

### Criando uma nova feature

1. Dentro de `apps/barnostri_app/lib/src/features` crie uma pasta com o nome da feature.
2. Adicione os subdiretórios `presentation`, `domain` e `data`.
3. Coloque widgets na camada **presentation**, casos de uso e entidades em **domain** e implementações de repositório em **data**.

Exemplo básico:

```
lib/src/features/profile/
  presentation/profile_page.dart
  domain/profile.dart
  domain/load_profile_use_case.dart
  data/profile_repository_impl.dart
```

### Cadastro de usuários e tabela `profiles`

A tabela `profiles` guarda informações extras de cada usuário e possui os campos
`id`, `name`, `phone`, `user_type`, `store_name` e `created_at`. O campo
`user_type` aceita apenas `cliente` ou `lojista` e define se o usuário acessará
o menu (cliente) ou a área administrativa (lojista). As políticas RLS permitem
que cada usuário visualize e atualize somente o seu próprio perfil.

O fluxo de cadastro no app cria a conta via `supabase.auth.signUp` e insere o
perfil na tabela. Caso precise manipular a chave de **service role**, utilize
variáveis de ambiente ou uma função Edge, mantendo-a fora do aplicativo Flutter.
